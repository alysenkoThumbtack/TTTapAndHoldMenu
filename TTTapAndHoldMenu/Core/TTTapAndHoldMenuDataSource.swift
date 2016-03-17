//
//  TTTapAndHoldMenuDataSource.swift
//  TTTapAndHoldMenu
//
//  Created by alysenko on 15/03/16.
//  Copyright © 2016 alysenko. All rights reserved.
//

import Foundation

protocol TTTapAndHoldMenuDataSource: class {
    //MARK: - Required methods
    func contextMenu(menu: TTTapAndHoldMenu, imageForItemAtIndex index: Int, withTag tag: String?, forState selected: Bool) -> UIImage
    func numberOfItemsForMenu(menu: TTTapAndHoldMenu) -> Int
    
    // MARK: - Optional methods
    func contextMenu(menu: TTTapAndHoldMenu, tagForItemAtIndex index: Int) -> String?
    
    func contextMenu(menu: TTTapAndHoldMenu, hintForItemAtIndex index: Int, withTag tag: String?) -> String
    
    func contextMenu(menu: TTTapAndHoldMenu, imageSizeForItemAtIndex: Int, withTag tag: String?, forState selected: Bool) -> CGSize
    
    func angleForMenu(menu: TTTapAndHoldMenu) -> Double
    func radiusForMenu(menu: TTTapAndHoldMenu) -> Float
    
    func backViewColor(menu: TTTapAndHoldMenu) -> UIColor
    func backStancilViewColor(menu: TTTapAndHoldMenu) -> UIColor
    
    func hintTextColor(menu: TTTapAndHoldMenu) -> UIColor
    func hintFont(menu: TTTapAndHoldMenu) -> UIFont
    
    func highlightedRect(menu: TTTapAndHoldMenu, defaultHightlightedRect rect: CGRect) -> CGRect
}

extension TTTapAndHoldMenuDataSource {
    func contextMenu(menu: TTTapAndHoldMenu, tagForItemAtIndex index: Int) -> String? {
        return nil
    }
    
    func contextMenu(menu: TTTapAndHoldMenu, hintForItemAtIndex index: Int, withTag tag: String?) -> String {
        return ""
    }
    
    func contextMenu(menu: TTTapAndHoldMenu, imageSizeForItemAtIndex: Int, withTag tag: String?, forState selected: Bool) -> CGSize {
        return (selected) ? menu.selectedImageSize : menu.imageSize
    }
    
    func angleForMenu(menu: TTTapAndHoldMenu) -> Double {
        return menu.angle
    }
    
    func radiusForMenu(menu: TTTapAndHoldMenu) -> Float {
        return menu.radius
    }
    
    func backViewColor(menu: TTTapAndHoldMenu) -> UIColor {
        return menu.backViewColor
    }
    
    func backStancilViewColor(menu: TTTapAndHoldMenu) -> UIColor {
        return menu.backStancilViewColor
    }
    
    func hintTextColor(menu: TTTapAndHoldMenu) -> UIColor {
        return menu.hintTextColor
    }
    
    func hintFont(menu: TTTapAndHoldMenu) -> UIFont {
        return menu.hintFont
    }
    
    func highlightedRect(menu: TTTapAndHoldMenu, defaultHightlightedRect rect: CGRect) -> CGRect {
        return rect
    }
}
