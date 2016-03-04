//
//  PinterestLikeMenu.h
//  PinterestLikeMenu
//
//  Created by Tu You on 12/21/13.
//  Copyright (c) 2013 Tu You. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PinterestLikeMenuItem.h"

@interface PinterestLikeMenu : UIView

@property (nonatomic, assign) CGPoint startPoint;

@property (nonatomic, assign) float distance;
@property (nonatomic, assign) float maxDistance;
@property (nonatomic, assign) float maxAngle;


- (void)initialize;

- (id)initWithSubmenus:(NSArray *)submenus;
- (id)initWithSubmenus:(NSArray *)submenus startPoint:(CGPoint)point;
- (id)initWithSubmenus:(NSArray *)submenus startPoint:(CGPoint)point inView:(UIView *)view;

- (void)show;
- (void)updataLocation:(CGPoint)location;
- (void)finished:(BOOL)handleSelection completionBlock:(void (^)())completion;

@end
