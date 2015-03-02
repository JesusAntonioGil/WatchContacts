//
//  NSArray+MOBExtension.m
//  MOBUtils
//
//  Created by Alex Ruperez on 17/06/14.
//  Copyright (c) 2014 Mobusi. All rights reserved.
//

#import "NSArray+MOBExtension.h"

#import "MOBRandom.h"


@implementation NSArray (MOBExtension)

+ (NSArray *)arrayWithArrays:(NSArray *)firstArray, ...
{
    NSMutableArray *resultArray = [NSMutableArray array];
    
    va_list args;
    va_start(args, firstArray);
    for (NSArray *array = firstArray; array != nil; array = va_arg(args, NSArray*))
    {
        [resultArray addObjectsFromArray:array];
    }
    va_end(args);
    
    return [resultArray copy];
}

- (BOOL)containsArray:(NSArray *)array
{
    for (id element in array)
    {
        if (![self containsObject:element]) return NO;
    }
    
    return YES;
}

- (NSArray *)filteredArrayWithBlock:(BOOL(^)(id obj))block
{
    if (!block) return self;
    
    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:self.count];
    
    for (id obj in self)
    {
        if (block(obj))
        {
            [result addObject:obj];
        }
    }
    
    return [result copy];
}

- (NSArray *)transformArrayWithBlock:(id(^)(id obj))block
{
    if (!block) return self;
    
    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:self.count];
    
    for (id obj in self)
    {
        id transObj = block(obj);
        if (transObj)
        {
            [result addObject:transObj];
        }
    }
    
    return [result copy];
}

- (id)randomObject
{
    int index = mob_random_int(0, (int)self.count - 1);
    
    return self[index];
}

@end
