//
//  BFPinterestLikeMenu.swift
//  bloomfire
//
//  Created by Evgeniy Gushchin on 21/07/15.
//  Copyright (c) 2015 Bloomfire Inc. All rights reserved.
//

import UIKit
import Foundation

class BFPinterestLikeMenu: PinterestLikeMenu {
    
    private let backStencilView = StencilView()
    private let backView = UIView()
    private var viewToHighlight: UIView?
    
    var backViewColor = UIColor(white: 0.0, alpha: 0.3)
    var backStancilViewColor = UIColor(white: 0.0, alpha: 0.6)
    
    init(submenus: [AnyObject]!, startPoint point: CGPoint, highlightView view: UIView?) {
        super.init(submenus: submenus, startPoint: point)
        viewToHighlight = view
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func addBackView() {
        backView.frame = self.frame
        backStencilView.frame = self.frame
        backView.backgroundColor = backViewColor
        backStencilView.backgroundColor = backStancilViewColor
        if let view = viewToHighlight {
            let windowRect = view.superview!.convertRect(view.frame, toView: nil)
            backStencilView.windowRect = windowRect//getIntersectionsFor(windowRect, inView: view.superview!)
        }
        
        self.insertSubview(backStencilView, atIndex: 0)
        self.insertSubview(backView, atIndex: 1)
    }
    
    private func getIntersectionsFor(rect: CGRect, inView menuView: UIView) -> CGRect {
        var windowRect = rect
        if let superview = menuView.superview, let index = (superview.subviews ).indexOf(menuView) {
            let maxIndex = superview.subviews.count - 1
            if index < maxIndex {
                for index in (index + 1)...maxIndex {
                    let subview = superview.subviews[index] 
                    if !subview.hidden && subview.alpha > 0 {
                        windowRect = stencilRectForIntersectView(subview , windowRect: rect)
                    }
                }
            }
            windowRect = getIntersectionsFor(windowRect, inView: superview)
        }
        
        return windowRect
    }
    
    
    private func stencilRectForIntersectView(intersectView: UIView, windowRect: CGRect) -> CGRect {
        
        var newWindowRect = nonNegativeYRectFrom(windowRect)
        
        // I didn't find good way to skip intersections with some views
//        if intersectView is PanView {
//            return newWindowRect
//        }
        
        var rect = intersectView.convertRect(intersectView.frame, toView: nil)
        if let superview = intersectView.superview {
            rect = superview.convertRect(intersectView.frame, toView: nil)
        }
        
        var intersection = CGRectIntersection(newWindowRect, rect)
        if CGRectIsNull(intersection) {
            return newWindowRect
        }
        
        intersection = nonNegativeYRectFrom(intersection)
        
        var newHeight = newWindowRect.height - intersection.height
        var newY = newWindowRect.origin.y
        if newY < 0 {
            newHeight += newY
        }
        if intersection.origin.y == 0 {
            newY =  intersection.height
        }
        else if intersection.origin.y == newWindowRect.origin.y && intersection.height > 0 {
            newY =  intersection.height
        }
        else if intersection.origin.y > newWindowRect.origin.y{
            newHeight = intersection.origin.y - newWindowRect.origin.y
        }
        
        newWindowRect  = CGRectMake(newWindowRect.origin.x, newY, newWindowRect.width, newHeight)
        return newWindowRect
    }
    
    private func nonNegativeYRectFrom(rect: CGRect) -> CGRect {
        var newRect = CGRectMake(rect.origin.x, rect.origin.y, rect.width, rect.height)
        if rect.origin.y < 0 {
            newRect = CGRectMake(rect.origin.x, 0, rect.width, rect.height + rect.origin.y)
        }
        return newRect
    }
    
    override func show() {
        addBackView()
        super.show()
    }
}
