//
//  BFContextMenu.swift
//  bloomfire
//
//  Created by alysenko on 04/02/15.
//  Copyright (c) 2015 Bloomfire Inc. All rights reserved.
//

import Foundation


var gestureIsActive = false

class TTTapAndHoldMenu: NSObject, UIGestureRecognizerDelegate {
    weak var delegate: TTTapAndHoldMenuDelegate?
    weak var dataSource: TTTapAndHoldMenuDataSource?
    
    var tableViewOptions = TTMTableViewOptions.All()
    var collectionViewOptions = TTMCollectionViewOptions.All()
    
    var angle: Double = M_PI_2
    var radius: Float = 150
    
    var hintTextColor: UIColor = UIColor.whiteColor()
    var hintFont: UIFont = UIFont(name: "HelveticaNeue", size: 14)!
    
    var backViewColor = UIColor(white: 0.0, alpha: 0.3)
    var backStancilViewColor = UIColor(white: 0.0, alpha: 0.6)
    
    private var _views = NSHashTable.weakObjectsHashTable()
    private var _longPressRecognizers = NSHashTable.weakObjectsHashTable()

    private(set) var recipient: TTTapAndHoldMenuRecipient = .None
    
    func attachToView(view: UIView) {
        if _views.containsObject(view) {
            return
        }
        
        let selector: Selector = "popMenu:"
        
        let longPressRecognizer = UILongPressGestureRecognizer(target:self, action: selector)
        longPressRecognizer.delegate = self
        view.addGestureRecognizer(longPressRecognizer)
        
        _views.addObject(view)
        _longPressRecognizers.addObject(longPressRecognizer)
    }
    
    func detachFromView(view: UIView) {
        if !_views.containsObject(view) {
            return
        }
        
        let recognizers = _longPressRecognizers.objectEnumerator().filter { (recognizer) -> Bool in
            _views.containsObject((recognizer as! UILongPressGestureRecognizer).view)
        }
        if recognizers.count > 0 {
            if let recognizer = recognizers[0] as? UILongPressGestureRecognizer {
                let selector: Selector = "popMenu:"
                recognizer.removeTarget(self, action: selector)
                view.removeGestureRecognizer(recognizer)
            }
        }
        
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    private var menu: BFPinterestLikeMenu?
    
    private func show(point:CGPoint, fromView view: UIView, highlightedView: UIView) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "deviceOrientationDidChange:", name: UIDeviceOrientationDidChangeNotification, object: nil)
        if let source = dataSource {
            let itemsCount: Int = source.numberOfItemsForMenu(self)
        
            var items: [PinterestLikeMenuItem]! = []
            for (var i = 0; i < itemsCount; i++) {
                items.append(self.createItem(i, source: source))
            }
            
            let angle = source.angleForMenu(self)
            let radius = source.radiusForMenu(self)
            let backViewColor = source.backViewColor(self)
            let backStancilViewColor = source.backStancilViewColor(self)
            
            menu = BFPinterestLikeMenu(submenus: items, startPoint: point, highlightView: highlightedView)
            menu?.backViewColor = backViewColor
            menu?.backStancilViewColor = backStancilViewColor
            menu?.maxAngle = Float(angle)
            menu?.distance = radius
            menu?.maxDistance = (menu?.distance)! + 20
            
            menu!.show()
        }
    }
    
    func hide() {
        gestureIsActive = false
        menu?.finished(false, completionBlock: { () -> Void in
            self.menu = nil
            self.resetMenuRecipient()
        })
    }
    
    func createItem(index: Int, source: TTTapAndHoldMenuDataSource) -> PinterestLikeMenuItem {
        let tag: String? = source.contextMenu(self, tagForItemAtIndex: index)
        let defaultImage: UIImage = source.contextMenu(self, imageForItemAtIndex: index, withTag: tag, forState: false)
        let selectedImage: UIImage = source.contextMenu(self, imageForItemAtIndex: index, withTag: tag, forState: true)
        let hint: String = source.contextMenu(self, hintForItemAtIndex: index, withTag: tag)
        
        let item: PinterestLikeMenuItem = PinterestLikeMenuItem(image: defaultImage, selctedImage: selectedImage) { () -> Void in
            self.delegate?.contextMenu(self, didSelectItemAtIndex: index, withTag: tag)
        }
        
        let label = item.label
        label.font = hintFont
        label.text = hint
        label.sizeToFit()
        label.textColor = hintTextColor
        label.hidden = true
        label.alpha = 0.0
        
        return item
    }
    
    func popMenu(gesture: UIGestureRecognizer) {
        let location: CGPoint = gesture.locationInView(gesture.view!.window!)
        if gesture.state == UIGestureRecognizerState.Began {
            if !gestureIsActive {
                //fillMenuInfo(gesture)
                
                var highlightedView = getHighlightedView(recipient)
                if highlightedView == nil {
                    highlightedView = gesture.view!
                }
                
                show(location, fromView: gesture.view!, highlightedView: highlightedView!)
                gestureIsActive = true
            }
        }
        else if gesture.state == UIGestureRecognizerState.Changed {
            menu?.updataLocation(location)
        }
        else
        {
            if menu != nil {
                gestureIsActive = false
            }
            menu?.finished(true, completionBlock: { () -> Void in
                self.menu = nil
                self.resetMenuRecipient()
            })
        }
    }
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        determineMenuRecipient(gestureRecognizer)
        var shouldShow = delegate?.contextMenuShouldAppear(self) ?? true
        switch (recipient) {
        case .None:
            shouldShow = false
        default:
            break
        }
        
        return shouldShow
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    func deviceOrientationDidChange(notification: NSNotification) {
        hide()
    }
    
    //MARK: -
    
    private func getHighlightedView(recipient: TTTapAndHoldMenuRecipient) -> UIView? {
        switch (recipient) {
        case .TableViewCell(let info):
            return info.tableView.cellForRowAtIndexPath(info.indexPath)
        case .TableViewSectionFooter(let info):
            return info.tableView.footerViewForSection(info.section)
        case .TableViewSectionHeader(let info):
            return info.tableView.headerViewForSection(info.section)
        case .TableViewHeader(let info):
            return info.tableView.tableHeaderView
        case .TableViewFooter(let info):
            return info.tableView.tableFooterView
        case .View(let info):
            return info.view
            //TODO: implement cases for UICollectionView
        default:
            return nil
        }
    }
    
    //MARK: - Menu Info methods
    
    private func resetMenuRecipient() {
        recipient = .None
    }
    
    private func determineMenuRecipient(gestureRecognizer: UIGestureRecognizer) {
        if let view = gestureRecognizer.view {
            if let tableView = view as? UITableView {
                tableViewCase(tableView, gestureRecognizer: gestureRecognizer)
            }
            else if let collectionView = view as? UICollectionView {
                collectionViewCase(collectionView, gestureRecognizer: gestureRecognizer)
            }
            else {
                viewCase(view, gestureRecognizer: gestureRecognizer)
            }
        }
    }
    
    private func tableViewCase(tableView: UITableView, gestureRecognizer: UIGestureRecognizer) {
        if !isValidPair(tableView, gestureRecognizer: gestureRecognizer) {
            return
        }
        
        let location = gestureRecognizer.locationInView(tableView)
        if tableView.touchedTableViewHeader(location) && tableViewOptions.contains(.Header) {
            let info = TTMTableViewHeaderInfo(tableView: tableView, location: location)
            recipient = .TableViewHeader(info: info)
        }
        else if tableView.touchedTableViewFooter(location) && tableViewOptions.contains(.Footer) {
            let info = TTMTableViewFooterInfo(tableView: tableView, location: location)
            recipient = .TableViewFooter(info: info)
        }
        if let section = tableView.indexForSectionHeaderAtPoint(location) where tableViewOptions.contains(.SectionHeaders) {
            let info = TTMTableViewSectionHeaderInfo(tableView: tableView, section: section, location: location)
            recipient = .TableViewSectionHeader(info: info)
        }
        else if let section = tableView.indexForSectionFooterAtPoint(location) where tableViewOptions.contains(.SectionFooters) {
            let info = TTMTableViewSectionFooterInfo(tableView: tableView, section: section, location: location)
            recipient = .TableViewSectionFooter(info: info)
        }
        else if let indexPath = tableView.indexPathForRowAtPoint(location) where tableViewOptions.contains(.Cells) {
            let info = TTMTableViewCellInfo(tableView: tableView, indexPath: indexPath, location: location)
            recipient = .TableViewCell(info: info)
        }
        else if tableViewOptions.contains(.View) {
            let info = TTMViewInfo(view: tableView, location: location)
            recipient = .View(info: info)
        }
        else {
            recipient = .None
        }
    }
    
    private func collectionViewCase(collectionView: UICollectionView, gestureRecognizer: UIGestureRecognizer) {
        if !isValidPair(collectionView, gestureRecognizer: gestureRecognizer) {
            return
        }
        
        let location = gestureRecognizer.locationInView(collectionView)
        let info = TTMViewInfo(view: collectionView, location: location)
        recipient = .View(info: info)
        //TODO: implement suitable handling
        
    }
    
    private func viewCase(view: UIView, gestureRecognizer: UIGestureRecognizer) {
        if !isValidPair(view, gestureRecognizer: gestureRecognizer) {
            return
        }
        
        let location = gestureRecognizer.locationInView(view)
        
        let info = TTMViewInfo(view: view, location: location)
        recipient = .View(info: info)
    }
    
    private func isValidPair(view: UIView, gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let v = gestureRecognizer.view {
            if v != view {
                return false
            }
        }
        else {
            return false
        }
        
        return true
    }
}