//
//  UITableView+SupplemantaryViewAtPoint.swift
//  TTTapAndHoldMenu
//
//  Created by alysenko on 15/03/16.
//  Copyright © 2016 alysenko. All rights reserved.
//

import Foundation

extension UITableView {
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
