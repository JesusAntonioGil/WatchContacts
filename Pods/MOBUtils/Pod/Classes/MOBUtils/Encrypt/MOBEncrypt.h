//
//  MOBEncrypt.h
//  MOBUtils
//
//  Created by Alex Ruperez on 28/04/14.
//  Copyright (c) 2014 Mobusi. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MOBEncrypt : NSObject

+ (NSData *)AES128:(NSData *)data key:(NSString *)key;
+ (NSData *)decryptAES128:(NSData *)data key:(NSString *)key;

+ (NSData *)AES256:(NSData *)data key:(NSString *)key;
+ (NSData *)decryptAES256:(NSData *)data key:(NSString *)key;

@end
