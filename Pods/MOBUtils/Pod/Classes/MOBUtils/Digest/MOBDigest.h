//
//  MOBDigest.h
//  MOBUtils
//
//  Created by Alex Ruperez on 10/04/14.
//  Copyright (c) 2014 Mobusi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MOBDigest : NSObject

+ (NSString *)MD5:(id)data; // NSString or NSData
+ (NSString *)SHA1:(id)data; // NSString or NSData
+ (NSString *)SHA256:(id)data; // NSString or NSData
+ (NSString *)SHA512:(id)data; // NSString or NSData

@end
