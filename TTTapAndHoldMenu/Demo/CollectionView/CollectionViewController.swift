//
//  CollectionViewController.swift
//  TTTapAndHoldMenu
//
//  Created by alysenko on 17/03/16.
//  Copyright © 2016 alysenko. All rights reserved.
//

import Foundation

class CollectionViewController : BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = UIColor.whiteColor()
        
        contextMenu.attachToView(collectionView)
        contextMenu.collectionViewSupplementaryViewKinds = [UICollectionElementKindSectionHeader];
    }
    
    // MARK: - UICollectionView data source methods
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return users.count
        }
        else {
            return anotherUsers.count
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewItem", forIndexPath: indexPath) as? CollectionViewItem
        
        cell?.backgroundColor = UIColor(red: 0.85, green: 0.85, blue: 0.95, alpha: 1.0)
        cell?.selectedBackgroundView = nil
        
        let source = (indexPath.section == 0) ? users : anotherUsers
        let user = source[indexPath.row]

        cell?.title.text = "\(user.name) \(user.surname)"
        
        return cell!
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let sectionHeader = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "CollectionViewSectionHeader", forIndexPath: indexPath) as? CollectionViewSectionHeader
        sectionHeader?.title.text = (indexPath.section == 0) ? "Users" : "Another Users"
        sectionHeader?.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        
        return sectionHeader!
    }
    
    // MARK: - UICollectionView delegate methods
    
    // MARK: - update view when data source changed
    
    override func reloadView() {
        collectionView.reloadData()
    }
}