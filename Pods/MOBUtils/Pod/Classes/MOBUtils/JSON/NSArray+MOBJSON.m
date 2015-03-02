//
//  NSArray+MOBJSON.m
//  utils
//
//  Created by Alex Ruperez on 10/17/13.
//  Copyright (c) 2013 Mobusi. All rights reserved.
//

#import "NSArray+MOBJSON.h"


@implementation NSArray (MOBJSON)

- (NSString *)toJSONString
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:&error];
    if (error)
    {
        NSLog(@"%@", error);
        return @"";
    }
    else
    {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

- (NSData *)toData
{
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:&error];
    
    if (error)
    {
        NSLog(@"%@", error);
        return nil;
    }
    
    return data;
}

@end
