//
//  UIImage+MOBExtension.m
//  utils
//
//  Created by Alex Ruperez on 29/10/13.
//  Copyright (c) 2013 Mobusi. All rights reserved.
//

#import "UIImage+MOBExtension.h"

#import <QuartzCore/QuartzCore.h>


@implementation UIImage (MOBExtension)

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)imageFromMaskImage:(UIImage *)mask withColor:(UIColor *) color
{
    if (!mask) return nil;
    if (!color) return mask;
    
    UIImage *image = mask;
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, image.scale);
    CGContextRef c = UIGraphicsGetCurrentContext();
    [image drawInRect:rect];
    CGContextSetFillColorWithColor(c, [color CGColor]);
    CGContextSetBlendMode(c, kCGBlendModeSourceAtop);
    CGContextFillRect(c, rect);
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

- (UIImage *)imageWithSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0,0,size.width,size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage *)imageProportionallyWithSize:(CGSize)size
{
    CGFloat widthRatio = size.width / self.size.width;
    CGFloat heightRatio = size.height / self.size.height;
    
    CGSize newSize;
    if (widthRatio < heightRatio)
    {
        newSize = CGSizeMake(self.size.width * heightRatio, self.size.height * heightRatio);
    }
    else
    {
        newSize = CGSizeMake(self.size.width * widthRatio, self.size.height * widthRatio);
    }
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [self drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage *)imageCroppedWithSize:(CGSize)cropSize
{
    CGFloat x = (self.size.width - cropSize.width) / 2.0;
    CGFloat y = (self.size.height - cropSize.height) / 2.0;
    CGRect cropRect = CGRectMake(x, y, cropSize.width, cropSize.height);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], cropRect);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    
    return croppedImage;
}

- (UIImage *)scaleImageToSize:(CGSize)size
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, size.width, size.height, 8, 0, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    CGContextClearRect(context, CGRectMake(0, 0, size.width, size.height));
    
    if (self.imageOrientation == UIImageOrientationRight) {
        CGContextRotateCTM(context, -M_PI_2);
        CGContextTranslateCTM(context, -size.height, 0.0f);
        CGContextDrawImage(context, CGRectMake(0, 0, size.height, size.width), self.CGImage);
    } else {
        CGContextDrawImage(context, CGRectMake(0, 0, size.width, size.height), self.CGImage);
    }
    
    CGImageRef scaledImage = CGBitmapContextCreateImage(context);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
    UIImage *image = [UIImage imageWithCGImage:scaledImage];
    CGImageRelease(scaledImage);
    
    return image;
}

- (CGSize)estimateNewSize:(CGSize)newSize forImage:(UIImage *)image
{
    if (image.size.width > image.size.height) {
        newSize = CGSizeMake((image.size.width/image.size.height) * newSize.height, newSize.height);
    } else {
        newSize = CGSizeMake(newSize.width, (image.size.height/image.size.width) * newSize.width);
    }
    
    return newSize;
}

- (UIImage *)scaleImageProportionallyToSize:(CGSize)newSize
{
    return [self scaleImageToSize:[self estimateNewSize:newSize forImage:self]];
}

@end
