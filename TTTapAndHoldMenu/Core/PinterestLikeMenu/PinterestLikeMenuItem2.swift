//
//  PinterestLikeMenuItem2.swift
//  TTTapAndHoldMenu
//
//  Created by alysenko on 09/03/16.
//  Copyright © 2016 alysenko. All rights reserved.
//

import Foundation

class PinterestLikeMenuItem2 : UIView {
    
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
    
    private let defaultSize = CGSizeMake(40, 40)
    
    init(image: UIImage, selectedImage: UIImage, selectedBlock: (Void -> Void)) {
        self.image = image
        self.selectedImage = selectedImage
        self.selectedBlock = selectedBlock
        
        super.init(frame: CGRectMake(0, 0, defaultSize.width, defaultSize.height))
        
        self.addSubview(imageView)
        self.imageView.frame = self.bounds
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}