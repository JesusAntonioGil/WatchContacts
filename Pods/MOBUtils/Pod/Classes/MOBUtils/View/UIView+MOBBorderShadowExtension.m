//
//  UIView+MOBBorderShadowExtension.m
//  utils
//
//  Created by Alex Ruperez on 02/09/2013.
//  Copyright (c) 2013 Mobusi. All rights reserved.
//

#import "UIView+MOBBorderShadowExtension.h"

#import <QuartzCore/QuartzCore.h>


@implementation UIView (MOBBorderShadowExtension)

- (void)setBorderWidth:(CGFloat)borderWidth color:(UIColor *)color
{
	self.layer.borderWidth = borderWidth;
	self.layer.borderColor = color.CGColor;
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
	self.layer.masksToBounds = YES;
	self.layer.cornerRadius = cornerRadius;
}

@end
