//
//  UIView+MOBTransformExtension.m
//  utils
//
//  Created by Alex Ruperez on 13/09/2013.
//  Copyright (c) 2013 Mobusi. All rights reserved.
//

#import "UIView+MOBTransformExtension.h"


@implementation UIView (MOBTransformExtension)

- (void)rotateDegrees:(NSInteger)degrees
{
	CGFloat radians = (degrees * M_PI) / 180.0f;
	self.transform = CGAffineTransformMakeRotation(radians);
}

- (void)scale:(CGFloat)scale
{
    self.transform = CGAffineTransformMakeScale(scale, scale);
}

@end
