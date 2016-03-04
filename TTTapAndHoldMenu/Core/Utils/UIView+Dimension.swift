//
//  UIView+Dimension.swift
//  channelB
//
//  Created by Egor Z on 15/09/15.
//  Copyright (c) 2015 Thumbtack. All rights reserved.
//

import UIKit

extension UIView {
    
    var Width: CGFloat {
        get {
            return self.frame.size.width
        }
        set {
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
    }

    var Height: CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
    }
    
    var X: CGFloat {
        get {
            return self.center.x - self.Width/2
        }
        set {
            self.center = CGPointMake(newValue + self.Width/2, self.center.y)
        }
    }
    
    var Y: CGFloat {
        get {
            return self.center.y - self.Height/2
        }
        set {
            self.center = CGPointMake(self.center.x, newValue + self.Height/2)
        }
    }
    
    var RightX: CGFloat {
        get {
            return self.X + self.Width;
        }
        set {
            self.X = newValue - self.Width;
        }
    }
    
    var BottomY: CGFloat {
        get {
            return self.Y + self.Height;
        }
        set {
            self.Y = newValue - self.Height;
        }
    }
    
    var CenterX: CGFloat {
        get {
            return self.center.x;
        }
        set {
            var center = self.center;
            center.x = newValue;
            self.center = center;
        }
    }
    
    var CenterY: CGFloat {
        get {
            return self.center.y;
        }
        set {
            var center = self.center;
            center.y = newValue;
            self.center = center;
        }
    }
    
    var CenterInBounds: CGPoint {
        get {
            return CGPointMake(self.Width / 2, self.Height / 2);
        }
        set {
            self.center = CGPointMake(self.frame.origin.x + newValue.x, self.frame.origin.y + newValue.y);
        }
    }
    
    var Size: CGSize {
        get {
            return self.frame.size;
        }
        set {
            var frame = self.frame;
            frame.size = newValue;
            self.frame = frame;
        }
    }
    
    var Origin: CGPoint {
        get {
            return CGPointMake(self.center.x - self.Width/2, self.center.y - self.Height/2);
        }
        set {
            self.center = CGPointMake(newValue.x + self.Width/2, newValue.y + self.Height/2);
        }
    }
    
    var TopLeft: CGPoint {
        get {
            return self.Origin;
        }
        set {
            self.Origin = newValue;
        }
    }
    
    var TopRight: CGPoint {
        get {
            return CGPointMake(self.X + self.Width, self.Y);
        }
        set {
            self.Y = newValue.y;
            self.X = newValue.x - self.Width;
        }
    }
    
    var BottomLeft: CGPoint {
        get {
            return CGPointMake(self.X, self.Y + self.Height);
        }
        set {
            self.Y = newValue.y - self.Height;
            self.X = newValue.x;
        }
    }
    
    var BottomRight: CGPoint {
        get {
            return CGPointMake(self.X + self.Width, self.Y + self.Height);
        }
        set {
            self.X = newValue.x - self.Width;
            self.Y = newValue.y - self.Height;
        }
    }

}
