//
//  UIColor+MOBExtension.h
//  utils
//
//  Created by Alex Ruperez on 03/09/2013.
//  Copyright (c) 2013 Mobusi. All rights reserved.
//

#import <UIKit/UIKit.h>


#define MOBColorFromHex(rgbValue) [UIColor colorFromHex:rgbValue]
#define MOBColorToHex(color) [NSString stringWithFormat:@"%06x", color]


@interface UIColor (MOBExtension)

+ (UIColor *)colorFromHex:(NSInteger)hex;
+ (UIColor *)colorFromHex:(NSInteger)hex alpha:(CGFloat)alpha;
+ (UIColor *)colorFromRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue;
+ (UIColor *)randomColor;

+ (UIColor *)colorFromRGBString:(NSString *)rgbString; // 255,255,255,100
- (NSString *)toRGBString;

@end
