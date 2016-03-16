//
//  TTTapAndHoldMenuOptions.swift
//  TTTapAndHoldMenu
//
//  Created by alysenko on 15/03/16.
//  Copyright © 2016 alysenko. All rights reserved.
//

import Foundation

struct TTMTableViewOptions : OptionSetType {
    let rawValue: Int
    
    static let View = TTMTableViewOptions(rawValue: 1 << 0)
    static let Cells  = TTMTableViewOptions(rawValue: 1 << 1)
    static let SectionHeaders = TTMTableViewOptions(rawValue: 1 << 2)
    static let SectionFooters = TTMTableViewOptions(rawValue: 1 << 3)
    static let Header = TTMTableViewOptions(rawValue: 1 << 4)
    static let Footer = TTMTableViewOptions(rawValue: 1 << 5)
    
    static func All() -> TTMTableViewOptions {
        return [View, Cells, SectionHeaders, SectionFooters, Header, Footer]
    }
    
    static func None() -> TTMTableViewOptions {
        return []
    }
}

struct TTMCollectionViewOptions : OptionSetType {
    let rawValue: Int
    
    static let View = TTMCollectionViewOptions(rawValue: 1 << 0)
    static let Items  = TTMCollectionViewOptions(rawValue: 1 << 1)
    static let SupplementaryViews = TTMCollectionViewOptions(rawValue: 1 << 2)
    
    static func All() -> TTMCollectionViewOptions {
        return [View, Items, SupplementaryViews]
    }
    
    static func None() -> TTMCollectionViewOptions {
        return []
    }
}