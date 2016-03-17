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
}
