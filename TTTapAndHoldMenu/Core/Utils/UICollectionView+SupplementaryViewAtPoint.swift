//
//  UICollectionView+SupplementaryViewAtPoint.swift
//  TTTapAndHoldMenu
//
//  Created by alysenko on 17/03/16.
//  Copyright © 2016 alysenko. All rights reserved.
//

import Foundation



extension UICollectionView {
    func indexPathForSupplemetaryViewOfKind(kind: String, atPoint point: CGPoint) -> NSIndexPath? {
        let indexPaths = indexPathsForVisibleSupplementaryElementsOfKind(kind)
        var result: NSIndexPath? = nil
        for indexPath in indexPaths {
            let supplementaryView = supplementaryViewForElementKind(kind, atIndexPath: indexPath)
            if let frame = supplementaryView.superview?.convertRect(supplementaryView.frame, toView: self) {
                if frame.contains(point) {
                    result = indexPath
                    break
                }
            }
        }
        
        return result
    }
    
    func infoForSupplementaryViewAtPoint(point: CGPoint, kinds: [String]) -> TTMCollectionViewSupplementaryViewInfo? {
        var supplementaryViewIndexPath: NSIndexPath? = nil
        var supplementaryViewKind: String? = nil
        for kind in kinds {
            if let indexPath = self.indexPathForSupplemetaryViewOfKind(kind, atPoint: point) {
                supplementaryViewIndexPath = indexPath
                supplementaryViewKind = kind
                break
            }
        }
        
        if let indexPath = supplementaryViewIndexPath, kind = supplementaryViewKind {
            return TTMCollectionViewSupplementaryViewInfo(collectionView: self, indexPath: indexPath, kind: kind, location: point)
        }
        
        return nil
    }
}