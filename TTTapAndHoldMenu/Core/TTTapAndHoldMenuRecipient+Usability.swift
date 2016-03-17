//
//  TTTTapAndHoldMenuRecipient+Usability.swift
//  TTTapAndHoldMenu
//
//  Created by alysenko on 16/03/16.
//  Copyright © 2016 alysenko. All rights reserved.
//

import Foundation

extension TTTapAndHoldMenuRecipient {
    
    var isTableViewHeader: Bool {
        switch (self) {
        case .TableViewHeader(_):
            return true
        default:
            return false
        }
    }
    
    var isTableViewFooter: Bool {
        switch (self) {
        case .TableViewFooter(_):
            return true
        default:
            return false
        }
    }
    
    var isTableViewSectionHeader: Bool {
        switch (self) {
        case .TableViewSectionHeader(_):
            return true
        default:
            return false
        }
    }
    
    var isTableViewSectionFooter: Bool {
        switch (self) {
        case .TableViewSectionFooter(_):
            return true
        default:
            return false
        }
    }
    
    var isCollectionViewSupplementaryView: Bool {
        switch (self) {
        case .CollectionViewSupplementaryView(_):
            return true
        default:
            return false
        }
    }
}

extension TTTapAndHoldMenuRecipient {
    var info: TTMViewInfo? {
        switch (self) {
        case .View(let info):
            return info
        case .TableViewCell(let info):
            return info
        case .TableViewSectionHeader(let info):
            return info
        case .TableViewSectionFooter(let info):
            return info
        case .TableViewHeader(let info):
            return info
        case .TableViewFooter(let info):
            return info
        case .CollectionViewItem(let info):
            return info
        case .CollectionViewSupplementaryView(let info):
            return info
        default:
            return nil
        }
    }
    
    var tableView: UITableView? {
        return (info as? TTMTableViewBasedInfo)?.tableView
    }
    
    var collectionView: UICollectionView? {
        return (info as? TTMCollectionViewBasedInfo)?.collectionView
    }
    
    var indexPath: NSIndexPath? {
        return (info as? TTMIndexPathBasedInfo)?.indexPath
    }
    
    var section: NSInteger? {
        return (info as? TTMSectionBasedInfo)?.section
    }
    
    var collectionViewSupplementaryViewKind: String? {
        return (info as? TTMKindBasedInfo)?.kind
    }
}