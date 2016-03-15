//
//  TTTapAndHoldMenuInfo.swift
//  TTTapAndHoldMenu
//
//  Created by alysenko on 15/03/16.
//  Copyright © 2016 alysenko. All rights reserved.
//

import Foundation

enum TTTapAndHoldMenuInfo {
    case Empty
    
    case TableViewCell(tableView: UITableView, indexPath: NSIndexPath)
    case TableViewSectionHeader(tableView: UITableView, section: NSInteger)
    case TableViewSectionFooter(tableView: UITableView, section: NSInteger)
    
    case CollectionViewItem(collectionView: UICollectionView, indexPath: NSIndexPath)
    case CollectionViewSupplementaryView(collectionView: UICollectionView, kind: String, indexPath: NSIndexPath)
    
    case View(view: UIView)
    
    var tableView: UITableView? {
        switch (self) {
        case .TableViewCell(let tableView, _):
            return tableView
        case .TableViewSectionHeader(let tableView, _):
            return tableView
        case .TableViewSectionFooter(let tableView, _):
            return tableView
        default:
            return nil
        }
    }
    
    var collectionView: UICollectionView? {
        switch (self) {
        case .CollectionViewItem(let collectionView, _):
            return collectionView
        case .CollectionViewSupplementaryView(let collectionView, _, _):
            return collectionView
        default:
            return nil
        }
    }
    
    var indexPath: NSIndexPath? {
        switch (self) {
        case .TableViewCell(_, let indexPath):
            return indexPath
        case .CollectionViewItem(_, let indexPath):
            return indexPath
        case .CollectionViewSupplementaryView(_, _, let indexPath):
            return indexPath
        default:
            return nil
        }
    }
    
    var section: NSInteger? {
        switch (self) {
        case .TableViewSectionHeader(_, let section):
            return section
        case .TableViewSectionFooter(_, let section):
            return section
        default:
            return nil
        }
    }
    
    var collectionViewSupplementaryViewKind: NSString? {
        switch (self) {
        case .CollectionViewSupplementaryView(_, let kind, _):
            return kind
        default:
            return nil
        }
    }
}
