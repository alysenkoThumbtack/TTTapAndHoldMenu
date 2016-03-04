//
//  PininterestLikeMenu.m
//  PininterestLikeMenu
//
//  Created by Tu You on 12/21/13.
//  Copyright (c) 2013 Tu You. All rights reserved.
//

#import "PinterestLikeMenu.h"
#import "TTTapAndHoldMenu-Swift.h"

#define kMaxAngle        M_PI_2
#define kMaxLength       (170)
#define kLength          (150)
#define kBounceLength    (8)
#define kPulseLength     (60)

static CGFloat distanceBetweenXAndY(CGPoint pointX, CGPoint pointY)
{
    CGFloat distance = 0;
    CGFloat offsetX = pointX.x - pointY.x;
    CGFloat offsetY = pointX.y - pointY.y;
    distance = sqrtf(pow(offsetX, 2) + pow(offsetY, 2));
    return distance;
}

@interface PinterestLikeMenu ()

@property (nonatomic, strong) NSArray *submenus;
@property (nonatomic, strong) UIImageView *startImageView;

@end

@implementation PinterestLikeMenu {
    UIView *parentView;
    UIView *backView;
}

- (id)initWithSubmenus:(NSArray *)submenus
{
    return [self initWithSubmenus:submenus startPoint:CGPointZero];
}

- (id)initWithSubmenus:(NSArray *)submenus startPoint:(CGPoint)point
{
    if (self = [super init])
    {
        self.frame = [UIApplication sharedApplication].keyWindow.frame;
        
//        self.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
        
        self.submenus = submenus;
        
        [self initialize];
        
        self.startPoint = point;
    }
    return self;
}

- (id)initWithSubmenus:(NSArray *)submenus startPoint:(CGPoint)point inView:(UIView *)view
{
    if (self = [super init])
    {
        parentView = view;
        self.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
       
        self.submenus = submenus;
        
        [self initialize];
        
        self.startPoint = point;
    }
    return self;
}

- (void)initialize {
    
//    [self addBackView];
    
    self.distance = kLength;
    self.maxDistance = kMaxLength;
    self.maxAngle = kMaxAngle;
    
    self.startImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kMenuItemLength, kMenuItemLength)];
    self.startImageView.image = [UIImage imageNamed:@"center"];
    
    for (int i = 0; i < self.submenus.count; i++)
    {
        ((UIView *)(self.submenus[i])).center = self.startPoint;
        
        [self addSubview:self.submenus[i]];
        
        UILabel* label = ((PinterestLikeMenuItem*)(self.submenus[i])).label;
        [self addSubview:label];
    }
    
    [self addSubview:self.startImageView];
}

//- (void) addBackView {
//    self.backgroundColor = [UIColor clearColor];
//    backView = [[UIView alloc]initWithFrame:self.frame];
//    backView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
//    [self addSubview:backView];
//}

- (void)setStartPoint:(CGPoint)point
{
    point.x = point.x < kMenuItemLength / 2 ? kMenuItemLength / 2 : point.x;
    point.x = point.x > (self.frame.size.width - kMenuItemLength / 2) ? (self.frame.size.width - kMenuItemLength / 2) : point.x;
    
    _startPoint = point;
    
    _startImageView.center = point;
    
    for (int i = 0; i < self.submenus.count; i++)
    {
        ((UIView *)(self.submenus[i])).center = self.startPoint;
    }
}

- (void)show
{
    if (parentView) {
        [parentView addSubview:self];
    }
    else {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:self];
    }
    self.alpha = 1;
    [self appear];
}

- (void)updataLocation:(CGPoint)touchedPoint
{
    int closestIndex = 0;
    float minDistance = CGFLOAT_MAX;
    
    // find the cloest menu item
    for (int i = 0; i < self.submenus.count; i++)
    {
        CGPoint floatingPoint = [self floatingPointWithIndex:i];
        
        CGFloat distance = distanceBetweenXAndY(touchedPoint, floatingPoint);
        
        if (distance < minDistance)
        {
            minDistance = distance;
            closestIndex = i;
        }
    }
    
    for (int i = 0; i < self.submenus.count; i++)
    {
        PinterestLikeMenuItem *menuItem = self.submenus[i];
        
        // the cloest point
        if (i == closestIndex)
        {
            CGPoint floatingPoint = [self floatingPointWithIndex:i];
            CGFloat currentDistance = distanceBetweenXAndY(touchedPoint, floatingPoint);
            currentDistance = currentDistance > self.maxDistance ? self.maxDistance : currentDistance;
            float step = (currentDistance / self.maxDistance) * (self.maxDistance - self.distance);
            
            [UIView animateWithDuration:0.1 animations:^{
                [self moveWithIndex:i offsetOfFloatingPoint:step];
            }];
            
            CGFloat distance = distanceBetweenXAndY(touchedPoint, floatingPoint);
            
            // if close enough, highlight the point
            if (distance < kPulseLength)
            {
                menuItem.selected = YES;
                [self showHint:menuItem];
            }
            else
            {
                menuItem.selected = NO;
                [self hideHint:menuItem];
            }
        }
        else
        {
            // back to init state
            [UIView animateWithDuration:0.20 animations:^{
                [self setThePostion:i];
            } completion:^(BOOL finished) {
                menuItem.selected = NO;
                [self hideHint:menuItem];
            }];
        }
    }

}

- (void) showHint:(PinterestLikeMenuItem*)item {
    CGPoint pos = item.center;
    CGFloat dx = pos.x - self.startPoint.x;
    CGFloat dy = pos.y - self.startPoint.y;

    CGFloat abs = sqrtf(dx * dx + dy * dy);
    dx /= abs;
    dy /= abs;
    
    CGFloat hintDistance = 40;
    
    CGFloat hx = pos.x + hintDistance * dx;
    CGFloat hy = pos.y + hintDistance * dy;
    
    
    item.label.Origin = CGPointMake(hx, hy);
    
    if (dx < 0) {
        item.label.RightX = item.label.X;
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        item.label.hidden = false;
        item.label.alpha = 1.0;
    }];
}

- (void) hideHint:(PinterestLikeMenuItem*)item {
    [UIView animateWithDuration:0.5
                     animations:^{
        item.label.alpha = 0.0;
    } completion:^(BOOL finished) {
        item.label.hidden = true;
    }];
}

- (void)finished:(BOOL)handleSelection completionBlock:(void (^)())completion
{
    for (int i = 0; i < self.submenus.count; i++)
    {
        PinterestLikeMenuItem *menuItem = self.submenus[i];
        if (handleSelection)
        {
            if (menuItem.selected)
            {
                if (menuItem.selectedBlock)
                {
                    menuItem.selectedBlock();
                }
                break;
            }
        }
    }
    [self disappear:completion];
}

- (void)moveWithIndex:(int)index offsetOfFloatingPoint:(float)offset
{
    UIView *menuItem = (UIView *)self.submenus[index];
    CGPoint floating = [self floatingPointWithIndex:index];
    float radian = [self radianWithIndex:index];
    radian = radian - M_PI;
    float x = floating.x + offset * cos(radian);
    float y = floating.y + offset * sin(radian);
    menuItem.center = CGPointMake(x, y);
}

- (void)setThePostion:(int)index
{
    float radian = [self radianWithIndex:index];
    float x = self.distance * cos(radian);
    float y = self.distance * sin(radian);
    UIView *view = self.submenus[index];
    view.center = CGPointMake(_startPoint.x + x, _startPoint.y + y);
}

- (CGPoint)floatingPointWithIndex:(int)index
{
    float radian = [self radianWithIndex:index];
    float x = self.maxDistance * cos(radian);
    float y = self.maxDistance * sin(radian);
    CGPoint point = CGPointMake(_startPoint.x + x, _startPoint.y + y);
    return point;
}

//- (float)radianWithIndex:(int)index
//{
//    NSUInteger count = self.submenus.count;
//    
//    // from 3/2 -> 2/2  0 -> 320 (20 -> 300)
//    
//    float startRadian = M_PI_2 * 3 - ((self.startPoint.x - 20) / (self.frame.size.width - 20 * 2)) * M_PI_2;
//    float step = kMaxAngle / (count - 1);
//    float radian = startRadian + index * step;
//
//    return radian;
//}

- (float)radianWithIndex:(int)index
{
    NSUInteger count = self.submenus.count;
    
    CGFloat dx = (self.Width / 2 - self.startPoint.x) * 2 - self.startPoint.x + (self.Width - self.startPoint.x);
    CGFloat dy = (self.Height / 2 - self.startPoint.y) * 2 - self.startPoint.y + (self.Height - self.startPoint.y);

    CGFloat l = sqrtf(dx * dx + dy * dy);
    
    float startRadian = 0;
    if (l == 0) {
        startRadian = M_PI_2 - self.maxAngle / 2;
    }
    else {
        startRadian = atan2(dy, dx) - self.maxAngle / 2;
    }
    
    float step = 0;
    if (count - 1 > 0) {
        step = self.maxAngle / (count - 1);
    }
    
    float radian = startRadian + index * step;
    
    return radian;
}

- (void)appear
{
    for (int i = 0; i < self.submenus.count; i++)
    {
        [self pulseTheMenuAtIndex:i];
    }
}

- (void)disappear:(void (^)())completion
{
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        completion();
    }];
}

- (void)pulseTheMenuAtIndex:(int)index
{
    UIView *view = (UIView *)self.submenus[index];
    [UIView animateWithDuration:0.25
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         float radian = [self radianWithIndex:index];
                         float y =  (self.distance + kBounceLength) * sin(radian);
                         float x = (self.distance + kBounceLength) * cos(radian);
                         view.center = CGPointMake(_startPoint.x + x, _startPoint.y + y);
                         
                     } completion:^(BOOL finished) {
                         
                         [UIView animateWithDuration:0.15
                                          animations:^{
                                              
                             float radian = [self radianWithIndex:index];
                             float y = self.distance * sin(radian);
                             float x =  self.distance * cos(radian);
                             view.center = CGPointMake(_startPoint.x + x, _startPoint.y + y);
                                              
                         } completion:^(BOOL finished) {
                             
                         }];
                     }];
}

@end
