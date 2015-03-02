//
//  MOBGradientView.h
//  MOBUtils
//
//  Created by Alex Ruperez on 11/06/14.
//  Copyright (c) 2014 Mobusi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MOBGradientView : UIView

@property (strong, nonatomic) UIColor *gradientColor;

- (void)setGradientColor:(UIColor *)gradientColor startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

@end
