//
//  BFContextMenu.swift
//  bloomfire
//
//  Created by alysenko on 04/02/15.
//  Copyright (c) 2015 Bloomfire Inc. All rights reserved.
//

import Foundation

private extension UITableView {
    func indexForSectionHeaderAtPoint(point: CGPoint) -> NSInteger? {
        return indexForSupplementaryViewAtPoint(point, type: .Header)
    }
    
    func indexForSectionFooterAtPoint(point: CGPoint) -> NSInteger? {
        return indexForSupplementaryViewAtPoint(point, type: .Footer)
    }
    
    private enum UITableViewSupplementaryViewType: Int {
        case Header = 1
        case Footer = 2
    }
    
    private func indexForSupplementaryViewAtPoint(point: CGPoint, type: UITableViewSupplementaryViewType) -> NSInteger? {
        if self.style == .Plain {
            return nil
        }
        
        var supplementaryViewIndex: NSInteger? = nil
        for (var i = 0; i < self.numberOfSections; i++) {
            if let supplementaryView = ((type == .Header) ? self.headerViewForSection(i) : self.footerViewForSection(i)) {
                if let frame = supplementaryView.superview?.convertRect(supplementaryView.frame, toView: self) {
                    if frame.contains(point) {
                        supplementaryViewIndex = i
                        break
                    }
                }
            }
        }
        
        return supplementaryViewIndex
    }
}

var gestureIsActive = false

protocol BFContextMenuDelegate: class {
    //MARK: - Optional methods
    func contextMenuWillAppear(menu: BFContextMenu)
    func contextMenu(menu: BFContextMenu, didSelectItemAtIndex index: Int, withTag tag: String?)
}

extension BFContextMenuDelegate {
    func contextMenuWillAppear(menu: BFContextMenu) {
        
    }
    
    func contextMenu(menu: BFContextMenu, didSelectItemAtIndex index: Int, withTag tag: String?) {
        
    }
}

protocol BFContextMenuDataSource: class {
    //MARK: - Required methods
    func contextMenu(menu: BFContextMenu, imageForItemAtIndex index: Int, withTag tag: String?, forState selected: Bool) -> UIImage
    func numberOfItemsForMenu(menu: BFContextMenu) -> Int
    
    // MARK: - Optional methods
    func contextMenu(menu: BFContextMenu, tagForItemAtIndex index: Int) -> String?
    func contextMenu(menu: BFContextMenu, hintForItemAtIndex index: Int, withTag tag: String?) -> String
    func angleForMenu(menu: BFContextMenu) -> Double
    func radiusForMenu(menu: BFContextMenu) -> Float
}

extension BFContextMenuDataSource {
    func contextMenu(menu: BFContextMenu, tagForItemAtIndex index: Int) -> String? {
        return nil
    }
    
    func contextMenu(menu: BFContextMenu, hintForItemAtIndex index: Int, withTag tag: String?) -> String {
        return ""
    }
    
    func angleForMenu(menu: BFContextMenu) -> Double {
        return M_PI_2
    }
    
    func radiusForMenu(menu: BFContextMenu) -> Float {
        return 150
    }
}

class BFContextMenu: NSObject, UIGestureRecognizerDelegate {
    
    weak var delegate: BFContextMenuDelegate?
    weak var dataSource: BFContextMenuDataSource?
    
    var angle: Double = M_PI_2
    var radius: Float = 150
    
    var hintTextColor: UIColor = UIColor.whiteColor()
    var hintFont: UIFont = UIFont(name: "HelveticaNeue", size: 14)!
    
    private var _activeView: UIView?
    private var _views = NSHashTable.weakObjectsHashTable()
    private var _longPressRecognizers = NSHashTable.weakObjectsHashTable()

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
        delegate?.contextMenuWillAppear(self)
        if let source = dataSource {
            let itemsCount: Int = source.numberOfItemsForMenu(self)
        
            var items: [PinterestLikeMenuItem]! = []
            for (var i = 0; i < itemsCount; i++) {
                items.append(self.createItem(i, source: source))
            }
            
            let angle = source.angleForMenu(self)
            let radius = source.radiusForMenu(self)
            
            menu = BFPinterestLikeMenu(submenus: items, startPoint: point, highlightView: highlightedView)
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
        })
    }
    
    func createItem(index: Int, source: BFContextMenuDataSource) -> PinterestLikeMenuItem {
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
                show(location, fromView: gesture.view!, highlightedView: gesture.view!)
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
            })
        }
    }
    
    func deviceOrientationDidChange(notification: NSNotification) {
        hide()
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}