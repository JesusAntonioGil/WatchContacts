//
//  NSError+MOBExtension.h
//  MOBUtils
//
//  Created by Alex Ruperez on 09/04/14.
//  Copyright (c) 2014 Mobusi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (MOBExtension)

+ (instancetype)errorWithMessage:(NSString *)message;
+ (instancetype)errorWithCode:(NSInteger)code message:(NSString *)message;
+ (instancetype)errorWithDomain:(NSString *)domain code:(NSInteger)code message:(NSString *)message;

@end
