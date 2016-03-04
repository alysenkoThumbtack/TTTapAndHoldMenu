//
//  BFContextMenu.swift
//  bloomfire
//
//  Created by alysenko on 04/02/15.
//  Copyright (c) 2015 Bloomfire Inc. All rights reserved.
//

import Foundation

var gestureIsActive = false

@objc protocol BFContextMenuDelegate {
    optional func contextMenuWillAppear(menu: BFContextMenu)
    optional func contextMenu(menu: BFContextMenu, didSelectItemAtIndex index: Int, withTag tag: String?)
}

@objc protocol BFContextMenuDataSource {
    func contextMenu(menu: BFContextMenu, imageForItemAtIndex index: Int, withTag tag: String?, forState selected: Bool) -> UIImage
    func numberOfItemsForMenu(menu: BFContextMenu) -> Int
    
    optional func contextMenu(menu: BFContextMenu, tagForItemAtIndex index: Int) -> String?
    optional func contextMenu(menu: BFContextMenu, hintForItemAtIndex index: Int, withTag tag: String?) -> String
    optional func angleForMenu(menu: BFContextMenu) -> Double
    optional func radiusForMenu(menu: BFContextMenu) -> Float
}

@objc class BFContextMenu: NSObject, UIGestureRecognizerDelegate {
    
    weak var delegate: BFContextMenuDelegate?
    weak var dataSource: BFContextMenuDataSource?
    
    var angle: Double = M_PI_2
    var radius: Float = 150
    
    var hintTextColor: UIColor = UIColor.whiteColor()
    var hintFont: UIFont = UIFont(name: "HelveticaNeue", size: 14)!
    
    var longPressRecognizer: UILongPressGestureRecognizer?
    var view: UIView? {
        willSet {
            if newValue == nil {
                if let gesture = longPressRecognizer {
                    let selector: Selector = "popMenu:"
                    gesture.removeTarget(self, action: selector)
                    
                    self.view?.removeGestureRecognizer(gesture)
                }
            }
        }
        
        didSet {
            if view == nil {
                return
            }
            
            let selector: Selector = "popMenu:"
            
            longPressRecognizer = UILongPressGestureRecognizer(target:self, action: selector)
            longPressRecognizer?.delegate = self
            view!.addGestureRecognizer(longPressRecognizer!)
        }
    }
    
    deinit {
        view = nil
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    private var menu: BFPinterestLikeMenu?
    
    private func show(point:CGPoint) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "deviceOrientationDidChange:", name: UIDeviceOrientationDidChangeNotification, object: nil)
        delegate?.contextMenuWillAppear?(self)
        if let source = dataSource {
            let itemsCount: Int = source.numberOfItemsForMenu(self)
        
            var items: [PinterestLikeMenuItem]! = []
            for (var i = 0; i < itemsCount; i++) {
                items.append(self.createItem(i, source: source))
            }
            
            var dynamicAngle: Double?
            var dynamicRadius: Float?
            if let source = self.dataSource {
                dynamicAngle = source.angleForMenu?(self)
                dynamicRadius = source.radiusForMenu?(self)
            }
            
            menu = BFPinterestLikeMenu(submenus: items, startPoint: point, highlightView: view)
            
            if let angle = dynamicAngle {
                menu!.maxAngle = Float(angle)
            }
            else {
                menu!.maxAngle = Float(self.angle)
            }
            
            if let radius = dynamicRadius {
                menu!.distance = radius
            }
            else {
                menu!.distance = self.radius
            }
            
            menu!.maxDistance = menu!.distance + 20
            
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
        
        let tag: String? = source.contextMenu?(self, tagForItemAtIndex: index)
        let defaultImage: UIImage = source.contextMenu(self, imageForItemAtIndex: index, withTag: tag, forState: false)
        let selectedImage: UIImage = source.contextMenu(self, imageForItemAtIndex: index, withTag: tag, forState: true)
        
        var hint: String? = source.contextMenu?(self, hintForItemAtIndex: index, withTag: tag)
        
        if hint == nil {
            hint = ""
        }
        
        let item: PinterestLikeMenuItem = PinterestLikeMenuItem(image: defaultImage, selctedImage: selectedImage) { () -> Void in
            if let menuDelegate = self.delegate {
                menuDelegate.contextMenu?(self, didSelectItemAtIndex: index, withTag: tag)
            }
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
        let location: CGPoint = gesture.locationInView(view!.window!)
        if gesture.state == UIGestureRecognizerState.Began {
            if !gestureIsActive {
                show(location)
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