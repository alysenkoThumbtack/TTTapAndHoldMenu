//
//  BFContextMenu.swift
//  bloomfire
//
//  Created by alysenko on 04/02/15.
//  Copyright (c) 2015 Bloomfire Inc. All rights reserved.
//

import Foundation

var gestureIsActive = false

private struct Constants {
    static let GestureSelector: Selector = "handleGestureRecognizerState:"
    static let DeviceOrientationDidChangeSelector: Selector = "deviceOrientationDidChange:"
    
    static let Angle: Double = M_PI_2
    static let Radius: CGFloat = 150
    
    static let ImageSize = CGSizeMake(40, 40)
    static let SelectedImageSize = CGSizeMake(40, 40)
    
    static let HintTextColor = UIColor.whiteColor()
    static let HintFont = UIFont(name: "HelveticaNeue", size: 14)!
    
    static let BackViewColor = UIColor(white: 0.0, alpha: 0.3)
    static let BackStancilViewColor = UIColor(white: 0.0, alpha: 0.6)
}

class TTTapAndHoldMenu: NSObject, UIGestureRecognizerDelegate {
    weak var delegate: TTTapAndHoldMenuDelegate?
    weak var dataSource: TTTapAndHoldMenuDataSource?
    
    var tableViewOptions = TTMTableViewOptions.All()
    
    var collectionViewOptions = TTMCollectionViewOptions.All()
    var collectionViewSupplementaryViewKinds = [String]()
    
    var angle: Double = Constants.Angle
    var radius: CGFloat = Constants.Radius
    
    var imageSize: CGSize = Constants.ImageSize
    var selectedImageSize: CGSize = Constants.SelectedImageSize
    
    var hintTextColor: UIColor = Constants.HintTextColor
    var hintFont: UIFont = Constants.HintFont
    
    var backViewColor = Constants.BackViewColor
    var backStancilViewColor = Constants.BackStancilViewColor
    
    private var _views = NSHashTable.weakObjectsHashTable()
    private var _longPressRecognizers = NSHashTable.weakObjectsHashTable()

    private(set) var recipient: TTTapAndHoldMenuRecipient = .None
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    private var menu: BFPinterestLikeMenu?
    
    // MARK: - Attach & Detach
    
    func attachToView(view: UIView) {
        if _views.containsObject(view) {
            return
        }
        
        let longPressRecognizer = UILongPressGestureRecognizer(target:self, action: Constants.GestureSelector)
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
                recognizer.removeTarget(self, action: Constants.GestureSelector)
                view.removeGestureRecognizer(recognizer)
            }
        }
        
    }

    // MARK: - Show & Hide
    
    private func show(point:CGPoint, fromView view: UIView, highlightedView: UIView) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Constants.DeviceOrientationDidChangeSelector, name: UIDeviceOrientationDidChangeNotification, object: nil)
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
            
            let windowRect = highlightedView.superview!.convertRect(highlightedView.frame, toView: nil)
            let highlightedRect = source.highlightedRect(self, defaultHightlightedRect: windowRect)
        
            menu = BFPinterestLikeMenu(submenus: items, startPoint: point, highlightedRect: highlightedRect)
            menu?.backViewColor = backViewColor
            menu?.backStancilViewColor = backStancilViewColor
            menu?.maxAngle = Float(angle)
            menu?.distance = Float(radius)
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
    
    // MARK: - Menu Item initialization
    
    func createItem(index: Int, source: TTTapAndHoldMenuDataSource) -> PinterestLikeMenuItem {
        let tag: String? = source.contextMenu(self, tagForItemAtIndex: index)
        
        let image = source.contextMenu(self, imageForItemAtIndex: index, withTag: tag, forState: false)
        let imageSize = source.contextMenu(self, imageSizeForItemAtIndex: index, withTag: tag, forState: false)
        
        let selectedImage = source.contextMenu(self, imageForItemAtIndex: index, withTag: tag, forState: true)
        let selectedImageSize = source.contextMenu(self, imageSizeForItemAtIndex: index, withTag: tag, forState: true)
        
        let hint: String = source.contextMenu(self, hintForItemAtIndex: index, withTag: tag)
        
        let item = PinterestLikeMenuItem(image: image, imageSize: imageSize, selectedImage: selectedImage, selectedImageSize: selectedImageSize) { () -> Void in
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
    
    // MARK: - Gesture recognizer handling
    
    func handleGestureRecognizerState(gesture: UIGestureRecognizer) {
        let location: CGPoint = gesture.locationInView(gesture.view!.window!)
        if gesture.state == UIGestureRecognizerState.Began {
            if !gestureIsActive {
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
        let theRecipient = determineMenuRecipient(gestureRecognizer)
        var shouldShow = true
        switch (theRecipient) {
        case .None:
            shouldShow = false
        default:
            break
        }
        
        shouldShow = shouldShow && (delegate?.contextMenuShouldAppear(self) ?? true)
        
        if shouldShow {
            recipient = theRecipient
        }
        
        return shouldShow
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    // MARK: - Device Orientation changes
    
    func deviceOrientationDidChange(notification: NSNotification) {
        hide()
    }
    
    // MARK: - Highlighted view logic
    
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
        case .CollectionViewSupplementaryView(let info):
            return info.collectionView.supplementaryViewForElementKind(info.kind, atIndexPath: info.indexPath)
        case .CollectionViewItem(let info):
            return info.collectionView.cellForItemAtIndexPath(info.indexPath)
        case .View(let info):
            return info.view
        default:
            return nil
        }
    }
    
    //MARK: - Menu Recipient methods
    
    private func resetMenuRecipient() {
        recipient = .None
    }
    
    private func determineMenuRecipient(gestureRecognizer: UIGestureRecognizer) -> TTTapAndHoldMenuRecipient {
        var theRecipient = TTTapAndHoldMenuRecipient.None
        if let view = gestureRecognizer.view {
            if let tableView = view as? UITableView {
                theRecipient = tableViewCase(tableView, gestureRecognizer: gestureRecognizer)
            }
            else if let collectionView = view as? UICollectionView {
                theRecipient = collectionViewCase(collectionView, gestureRecognizer: gestureRecognizer)
            }
            else {
                theRecipient = viewCase(view, gestureRecognizer: gestureRecognizer)
            }
        }
        
        return theRecipient
    }
    
    private func tableViewCase(tableView: UITableView, gestureRecognizer: UIGestureRecognizer) -> TTTapAndHoldMenuRecipient {
        if !isValidPair(tableView, gestureRecognizer: gestureRecognizer) {
            return .None
        }
        
        let location = gestureRecognizer.locationInView(tableView)
        if tableView.touchedTableViewHeader(location) && tableViewOptions.contains(.Header) {
            let info = TTMTableViewHeaderInfo(tableView: tableView, location: location)
            return .TableViewHeader(info: info)
        }
        else if tableView.touchedTableViewFooter(location) && tableViewOptions.contains(.Footer) {
            let info = TTMTableViewFooterInfo(tableView: tableView, location: location)
            return .TableViewFooter(info: info)
        }
        else if let section = tableView.indexForSectionHeaderAtPoint(location) where tableViewOptions.contains(.SectionHeaders) {
            let info = TTMTableViewSectionHeaderInfo(tableView: tableView, section: section, location: location)
            return .TableViewSectionHeader(info: info)
        }
        else if let section = tableView.indexForSectionFooterAtPoint(location) where tableViewOptions.contains(.SectionFooters) {
            let info = TTMTableViewSectionFooterInfo(tableView: tableView, section: section, location: location)
            return .TableViewSectionFooter(info: info)
        }
        else if let indexPath = tableView.indexPathForRowAtPoint(location) where tableViewOptions.contains(.Cells) {
            let info = TTMTableViewCellInfo(tableView: tableView, indexPath: indexPath, location: location)
            return .TableViewCell(info: info)
        }
        else if tableViewOptions.contains(.View) {
            let info = TTMViewInfo(view: tableView, location: location)
            return .View(info: info)
        }
        else {
            return .None
        }
    }
    
    private func collectionViewCase(collectionView: UICollectionView, gestureRecognizer: UIGestureRecognizer) -> TTTapAndHoldMenuRecipient {
        if !isValidPair(collectionView, gestureRecognizer: gestureRecognizer) {
            return .None
        }
        
        let location = gestureRecognizer.locationInView(collectionView)
        
        if let info = collectionView.infoForSupplementaryViewAtPoint(location, kinds: collectionViewSupplementaryViewKinds) where collectionViewOptions.contains(.SupplementaryViews) {
            return .CollectionViewSupplementaryView(info: info)
        }
        else if let indexPath = collectionView.indexPathForItemAtPoint(location) where collectionViewOptions.contains(.Items) {
            let info = TTMCollectionViewItemInfo(collectionView: collectionView, indexPath: indexPath, location: location)
            return .CollectionViewItem(info: info)
        }
        else {
            let info = TTMViewInfo(view: collectionView, location: location)
            return .View(info: info)
        }
    }
    
    private func viewCase(view: UIView, gestureRecognizer: UIGestureRecognizer) -> TTTapAndHoldMenuRecipient {
        if !isValidPair(view, gestureRecognizer: gestureRecognizer) {
            return .None
        }
        
        let location = gestureRecognizer.locationInView(view)
        
        let info = TTMViewInfo(view: view, location: location)
        return .View(info: info)
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