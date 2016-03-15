//
//  TTTapAndHoldMenuDelegate.swift
//  TTTapAndHoldMenu
//
//  Created by alysenko on 15/03/16.
//  Copyright © 2016 alysenko. All rights reserved.
//

import Foundation

protocol TTTapAndHoldMenuDelegate: class {
    
    // MARK: - Optional methods
    func contextMenuShouldAppear(menu: TTTapAndHoldMenu) -> Bool
    func contextMenuDidAppear(menu:TTTapAndHoldMenu)
    func contextMenu(menu: TTTapAndHoldMenu, didSelectItemAtIndex index: Int, withTag tag: String?)
    func contextMenuDidDisappear(menu:TTTapAndHoldMenu)
}

extension TTTapAndHoldMenuDelegate {
    func contextMenuShouldAppear(menu: TTTapAndHoldMenu) -> Bool {
        return true
    }
    
    func contextMenuDidAppear(menu:TTTapAndHoldMenu) {
        
    }
    
    func contextMenu(menu: TTTapAndHoldMenu, didSelectItemAtIndex index: Int, withTag tag: String?) {
        
    }
    
    func contextMenuDidDisappear(menu:TTTapAndHoldMenu) {
        
    }
}