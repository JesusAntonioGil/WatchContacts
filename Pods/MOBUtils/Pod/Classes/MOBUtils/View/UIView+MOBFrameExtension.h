//
//  UIView+MOBFrameExtension.h
//  utils
//
//  Created by Alex Ruperez on 02/09/2013.
//  Copyright (c) 2013 Mobusi. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIView (MOBFrameExtension)

- (CGFloat)width;
- (void)setWidth:(CGFloat)width;
- (CGFloat)height;
- (void)setHeight:(CGFloat)height;

- (CGFloat)x;
- (void)setX:(CGFloat)x;
- (CGFloat)y;
- (void)setY:(CGFloat)y;

- (CGSize)size;
- (void)setSize:(CGSize)size;
- (CGPoint)origin;
- (void)setOrigin:(CGPoint)origin;

- (CGFloat)maxX;
- (CGFloat)maxY;

@end
