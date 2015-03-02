//
//  UIImage+MOBExtension.h
//  utils
//
//  Created by Alex Ruperez on 29/10/13.
//  Copyright (c) 2013 Mobusi. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIImage (MOBExtension)

+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageFromMaskImage:(UIImage *)mask withColor:(UIColor *) color;

- (UIImage *)imageWithSize:(CGSize)size;
- (UIImage *)imageProportionallyWithSize:(CGSize)size;

- (UIImage *)imageCroppedWithSize:(CGSize)size;

- (UIImage *)scaleImageToSize:(CGSize)size;
- (UIImage *)scaleImageProportionallyToSize:(CGSize)newSize;

@end
