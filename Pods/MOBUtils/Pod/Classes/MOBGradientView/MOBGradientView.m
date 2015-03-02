//
//  MOBGradientView.m
//  MOBUtils
//
//  Created by Alex Ruperez on 11/06/14.
//  Copyright (c) 2014 Mobusi. All rights reserved.
//

#import "MOBGradientView.h"

@implementation MOBGradientView

- (UIColor *)gradientColor
{
    return self.backgroundColor;
}

- (void)setGradientColor:(UIColor *)gradientColor
{
    self.backgroundColor = gradientColor;
    
    CAGradientLayer *l = [CAGradientLayer layer];
    l.frame = self.bounds;
    l.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:0 green:0 blue:0 alpha:0] CGColor], (id)[[UIColor colorWithRed:0 green:0 blue:0 alpha:1] CGColor], nil];
    l.startPoint = CGPointMake(0.5f, 0.0f);
    l.endPoint = CGPointMake(0.5f, 1.0f);
    
    self.layer.mask = l;
}

- (void)setGradientColor:(UIColor *)gradientColor startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint
{
    self.backgroundColor = gradientColor;
    
    CAGradientLayer *l = [CAGradientLayer layer];
    l.frame = self.bounds;
    l.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:0 green:0 blue:0 alpha:0] CGColor], (id)[[UIColor colorWithRed:0 green:0 blue:0 alpha:1] CGColor], nil];
    l.startPoint = startPoint;
    l.endPoint = endPoint;
    
    self.layer.mask = l;
}

@end
