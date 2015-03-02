//
//  MOBRightIconButton.m
//  MOBUtils
//
//  Created by Alex Ruperez on 17/03/14.
//  Copyright (c) 2014 Mobusi. All rights reserved.
//

#import "MOBRightIconButton.h"


NSUInteger const sideInset = 5.f;
NSUInteger const topInset = 2.f;


@implementation MOBRightIconButton

#pragma mark - Init

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initialize];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        [self initialize];
    }
    
    return self;
}

#pragma mark - Overriden Methods

- (CGSize)intrinsicContentSize
{
    CGSize size = [super intrinsicContentSize];
    
    size = CGSizeMake(size.width + self.titleEdgeInsets.left + self.titleEdgeInsets.right + self.imageEdgeInsets.right, size.height + self.titleEdgeInsets.top + self.titleEdgeInsets.bottom);
    
    return size;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGRect frame = [super imageRectForContentRect:contentRect];
    
    frame.origin.x = CGRectGetMaxX(contentRect) - CGRectGetWidth(frame) - self.imageEdgeInsets.right + self.imageEdgeInsets.left;
    
    return frame;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGRect frame = [super titleRectForContentRect:contentRect];
    
    frame.origin.x = CGRectGetMinX(frame) - CGRectGetWidth([self imageRectForContentRect:contentRect]);
    
    return frame;
}

#pragma mark - Private Methods

- (void)initialize
{
    self.imageEdgeInsets = UIEdgeInsetsMake(topInset, sideInset, 0, sideInset);
}

@end