//
//  PinterestLikeMenuItem.swift
//  TTTapAndHoldMenu
//
//  Created by alysenko on 09/03/16.
//  Copyright © 2016 alysenko. All rights reserved.
//

import Foundation

class PinterestLikeMenuItem : UIView {
    
    var image: UIImage {
        didSet {
            imageView.image = image
        }
    }
    var selectedImage: UIImage {
        didSet {
            imageView.highlightedImage = selectedImage
        }
    }
    
    var selectedBlock: (Void -> Void)
    
    var label: UILabel = UILabel()
    
    var selected: Bool = false {
        didSet {
            imageView.highlighted = selected
        }
    }
    
    var distance: CGFloat = 0
    
    private var imageView: UIImageView = UIImageView()
    
    var imageSize = CGSizeMake(40, 40)
    var selectedImageSize = CGSizeMake(50, 50)
    
    var currentImageSize = CGSizeMake(40, 40) {
        didSet {
            imageView.Size = currentImageSize
        }
    }
    
    init(image: UIImage, imageSize: CGSize, selectedImage: UIImage, selectedImageSize: CGSize, selectedBlock: (Void -> Void)) {
        self.image = image
        self.selectedImage = selectedImage
        
        self.imageSize = imageSize
        self.selectedImageSize = selectedImageSize
        
        self.selectedBlock = selectedBlock
        
        let width = max(imageSize.width, selectedImageSize.width)
        let height = max(imageSize.height, selectedImageSize.height)
        super.init(frame: CGRectMake(0, 0, width, height))
        
        self.addSubview(imageView)
        self.imageView.frame = self.bounds
        
        currentImageSize = imageSize
        imageView.Size = currentImageSize
        
        imageView.image = image
        imageView.highlightedImage = selectedImage
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}