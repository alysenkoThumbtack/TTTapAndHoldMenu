//
//  StencilView.swift
//  bloomfire
//
//  Created by Evgeniy Gushchin on 22/07/15.
//  Copyright (c) 2015 Bloomfire Inc. All rights reserved.
//

import UIKit

class StencilView: UIView {
    
    var windowRect = CGRectZero
    
    override func drawRect(rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, self.backgroundColor?.CGColor)
        CGContextFillRect(context, self.bounds)
        
        CGContextSetBlendMode(context, CGBlendMode.Clear);
        CGContextFillRect(context, windowRect);
        
    }
}
