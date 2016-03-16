//
//  TTMViewInfo.swift
//  TTTapAndHoldMenu
//
//  Created by alysenko on 16/03/16.
//  Copyright © 2016 alysenko. All rights reserved.
//

import Foundation

@objc class TTMViewInfo : NSObject {
    var view: UIView
    var location: CGPoint
    
    init(view: UIView, location: CGPoint) {
        self.view = view
        self.location = location
    }
}

@objc protocol TTMTableViewBasedInfo {
    var tableView: UITableView { get set }
}

@objc protocol TTMIndexPathBasedInfo {
    var indexPath: NSIndexPath { get set }
}

@objc protocol TTMSectionBasedInfo {
    var section: NSInteger { get set }
}

@objc protocol TTMCollectionViewBasedInfo {
    var collectionView: UICollectionView { get set }
}

@objc protocol TTMKindBasedInfo {
    var kind: String { get set }
}


@objc class TTMTableViewInfo : TTMViewInfo, TTMTableViewBasedInfo {
    var tableView: UITableView {
        get {
            return view as! UITableView
        }
        
        set {
            view = newValue
        }
    }
    
    init(tableView: UITableView, location: CGPoint) {
        super.init(view: tableView, location: location)
    }
}

@objc class TTMTableViewCellInfo : TTMTableViewInfo, TTMIndexPathBasedInfo {
    var indexPath: NSIndexPath
    
    init(tableView: UITableView, indexPath: NSIndexPath, location: CGPoint) {
        self.indexPath = indexPath
        
        super.init(tableView: tableView, location: location)
    }
}

@objc class TTMTableViewSectionHeaderInfo : TTMTableViewInfo, TTMSectionBasedInfo {
    var section: NSInteger
    
    init(tableView: UITableView, section: NSInteger, location: CGPoint) {
        self.section = section
        
        super.init(tableView: tableView, location: location)
    }
}

@objc class TTMTableViewSectionFooterInfo : TTMTableViewInfo, TTMSectionBasedInfo {
    var section: NSInteger
    
    init(tableView: UITableView, section: NSInteger, location: CGPoint) {
        self.section = section
        
        super.init(tableView: tableView, location: location)
    }
}

@objc class TTMTableViewHeaderInfo : TTMTableViewInfo {
}

@objc class TTMTableViewFooterInfo : TTMTableViewInfo {
}


@objc class TTMCollectionViewInfo : TTMViewInfo, TTMCollectionViewBasedInfo {
    var collectionView: UICollectionView {
        get {
            return view as! UICollectionView
        }
        
        set {
            view = newValue
        }
    }
    
    init(collectionView: UICollectionView, location: CGPoint) {
        super.init(view: collectionView, location: location)
    }
}

@objc class TTMCollectionViewItemInfo : TTMCollectionViewInfo, TTMIndexPathBasedInfo {
    var indexPath: NSIndexPath
    
    init(collectionView: UICollectionView, indexPath: NSIndexPath, location: CGPoint) {
        self.indexPath = indexPath
        
        super.init(collectionView: collectionView, location: location)
    }
}

@objc class TTMCollectionViewSupplementaryViewInfo : TTMCollectionViewInfo, TTMIndexPathBasedInfo, TTMKindBasedInfo {
    var indexPath: NSIndexPath
    var kind: String
    
    init(collectionView: UICollectionView, indexPath: NSIndexPath, kind: String, location: CGPoint) {
        self.indexPath = indexPath
        self.kind = kind
        
        super.init(collectionView: collectionView, location: location)
    }
}
