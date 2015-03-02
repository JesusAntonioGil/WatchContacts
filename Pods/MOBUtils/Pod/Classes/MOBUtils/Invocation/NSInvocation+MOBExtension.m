//
//  NSInvocation+MOBExtension.m
//  MOBUtils
//
//  Created by Alex Ruperez on 29/10/14.
//  Copyright (c) 2014 Mobusi. All rights reserved.
//

#import "NSInvocation+MOBExtension.h"


@implementation NSInvocation (MOBExtension)

+ (instancetype)invocationWithTarget:(id)target action:(SEL)action
{
    NSMethodSignature *methodSignature = [target methodSignatureForSelector:action];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
    invocation.target = target;
    invocation.selector = action;
    
    return invocation;
}

+ (instancetype)invocationWithTarget:(id)target action:(SEL)action retain:(BOOL)retain
{
    NSInvocation *invocation = [self invocationWithTarget:target action:action];
    if (retain)
    {
        [invocation retainArguments];
    }
    
    return invocation;
}

@end
