//
//  TTTapAndHoldMenuInfo.swift
//  TTTapAndHoldMenu
//
//  Created by alysenko on 15/03/16.
//  Copyright © 2016 alysenko. All rights reserved.
//

import Foundation


enum TTTapAndHoldMenuRecipient {
    case None
    
    case TableViewCell(info: TTMTableViewCellInfo)
    case TableViewSectionHeader(info: TTMTableViewSectionHeaderInfo)
    case TableViewSectionFooter(info: TTMTableViewSectionFooterInfo)
    case TableViewFooter(info: TTMTableViewFooterInfo)
    case TableViewHeader(info: TTMTableViewHeaderInfo)
    
    case CollectionViewItem(info: TTMCollectionViewItemInfo)
    case CollectionViewSupplementaryView(info: TTMCollectionViewSupplementaryViewInfo)
    
    case View(info: TTMViewInfo)
    
    var tableView: UITableView? {
        switch (self) {
        case .TableViewCell(let info):
            return info.tableView
        case .TableViewSectionHeader(let info):
            return info.tableView
        case .TableViewSectionFooter(let info):
            return info.tableView
        default:
            return nil
        }
    }
    
    var collectionView: UICollectionView? {
        switch (self) {
        case .CollectionViewItem(let info):
            return info.collectionView
        case .CollectionViewSupplementaryView(let info):
            return info.collectionView
        default:
            return nil
        }
    }
    
    var indexPath: NSIndexPath? {
        switch (self) {
        case .TableViewCell(let info):
            return info.indexPath
        case .CollectionViewItem(let info):
            return info.indexPath
        case .CollectionViewSupplementaryView(let info):
            return info.indexPath
        default:
            return nil
        }
    }
    
    var section: NSInteger? {
        switch (self) {
        case .TableViewSectionHeader(let info):
            return info.section
        case .TableViewSectionFooter(let info):
            return info.section
        default:
            return nil
        }
    }
    
    var collectionViewSupplementaryViewKind: NSString? {
        switch (self) {
        case .CollectionViewSupplementaryView(let info):
            return info.kind
        default:
            return nil
        }
    }
}
