//
//  NSArray+MOBExtension.h
//  MOBUtils
//
//  Created by Alex Ruperez on 17/06/14.
//  Copyright (c) 2014 Mobusi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (MOBExtension)

+ (NSArray *)arrayWithArrays:(NSArray *)firstArray, ... NS_REQUIRES_NIL_TERMINATION;

- (BOOL)containsArray:(NSArray *)array;
- (NSArray *)filteredArrayWithBlock:(BOOL(^)(id obj))block;
- (NSArray *)transformArrayWithBlock:(id(^)(id obj))block;

- (id)randomObject;

@end
