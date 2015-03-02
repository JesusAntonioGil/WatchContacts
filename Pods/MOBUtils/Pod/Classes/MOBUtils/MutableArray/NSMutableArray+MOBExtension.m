//
//  NSMutableArray+MOBExtension.m
//  MOBUtils
//
//  Created by Alex Ruperez on 16/09/14.
//  Copyright (c) 2014 Mobusi. All rights reserved.
//

#import "NSMutableArray+MOBExtension.h"

@implementation NSMutableArray (MOBExtension)

- (BOOL)addObjectSafe:(id)object
{
    if (!object) return NO;
    
    [self addObject:object];
    
    return YES;
}

@end
