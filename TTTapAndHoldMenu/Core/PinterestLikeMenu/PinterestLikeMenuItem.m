//
//  PininterestLikeMenuItem.m
//  PininterestLikeMenu
//
//  Created by Tu You on 12/21/13.
//  Copyright (c) 2013 Tu You. All rights reserved.
//

#import "PinterestLikeMenuItem.h"



@interface PinterestLikeMenuItem ()

@property (nonatomic, strong) UIImageView *imageView;

@end


@implementation PinterestLikeMenuItem

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithImage:(UIImage *)image selctedImage:(UIImage *)selectedImage selectedBlock:(SelectedBlock)selectedBlock
{
    if (self = [super init])
    {
        self.bounds = CGRectMake(0, 0, kMenuItemLength, kMenuItemLength);
        
        self.imageView = [[UIImageView alloc] initWithImage:image];
        self.imageView.frame = self.bounds;
        self.imageView.image = image;
        self.imageView.highlightedImage = selectedImage;
        
        self.label = [UILabel new];
        
        [self addSubview:self.imageView];
        
        self.selectedBlock = selectedBlock;
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    
    self.imageView.highlighted = selected;
}


@end
