//
//  NSData+MOBString.m
//  utils
//
//  Created by Alex Ruperez on 10/25/13.
//  Copyright (c) 2013 Mobusi. All rights reserved.
//

#import "NSData+MOBString.h"


@implementation NSData (MOBString)

- (NSString *)toStringWithEncoding:(NSStringEncoding)encoding
{
    return [[NSString alloc] initWithData:self encoding:encoding];
}

- (NSString *)toUTF8String
{
    return [self toStringWithEncoding:NSUTF8StringEncoding];
}

- (NSString *)toASCIIString
{
    return [self toStringWithEncoding:NSASCIIStringEncoding];
}

@end
