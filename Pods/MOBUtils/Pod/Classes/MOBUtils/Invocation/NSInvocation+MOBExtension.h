//
//  NSInvocation+MOBExtension.h
//  MOBUtils
//
//  Created by Alex Ruperez on 29/10/14.
//  Copyright (c) 2014 Mobusi. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSInvocation (MOBExtension)

+ (instancetype)invocationWithTarget:(id)target action:(SEL)action;
+ (instancetype)invocationWithTarget:(id)target action:(SEL)action retain:(BOOL)retain;

@end
