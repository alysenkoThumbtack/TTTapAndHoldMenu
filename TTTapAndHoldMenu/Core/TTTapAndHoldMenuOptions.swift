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
    
    static func All() -> TTMTableViewOptions {
        return [View, Cells, SectionHeaders, SectionFooters]
    }
    
    static func None() -> TTMTableViewOptions {
        return []
    }
}