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

@objc class TTMTableViewInfo : TTMViewInfo {
    var tableView: UITableView {
        return view as! UITableView
    }
    
    init(tableView: UITableView, location: CGPoint) {
        super.init(view: tableView, location: location)
    }
}

@objc class TTMTableViewCellInfo : TTMTableViewInfo {
    var indexPath: NSIndexPath
    
    init(tableView: UITableView, indexPath: NSIndexPath, location: CGPoint) {
        self.indexPath = indexPath
        
        super.init(tableView: tableView, location: location)
    }
}

@objc class TTMTableViewSectionHeaderInfo : TTMTableViewInfo {
    var section: NSInteger
    
    init(tableView: UITableView, section: NSInteger, location: CGPoint) {
        self.section = section
        
        super.init(tableView: tableView, location: location)
    }
}

@objc class TTMTableViewSectionFooterInfo : TTMTableViewInfo {
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


@objc class TTMCollectionViewInfo : TTMViewInfo {
    var collectionView: UICollectionView {
        return view as! UICollectionView
    }
    
    init(collectionView: UICollectionView, location: CGPoint) {
        super.init(view: collectionView, location: location)
    }
}

@objc class TTMCollectionViewItemInfo : TTMCollectionViewInfo {
    var indexPath: NSIndexPath
    
    init(collectionView: UICollectionView, indexPath: NSIndexPath, location: CGPoint) {
        self.indexPath = indexPath
        
        super.init(collectionView: collectionView, location: location)
    }
}

@objc class TTMCollectionViewSupplementaryViewInfo : TTMCollectionViewInfo {
    var indexPath: NSIndexPath
    var kind: NSString
    
    init(collectionView: UICollectionView, indexPath: NSIndexPath, kind: NSString, location: CGPoint) {
        self.indexPath = indexPath
        self.kind = kind
        
        super.init(collectionView: collectionView, location: location)
    }
}
