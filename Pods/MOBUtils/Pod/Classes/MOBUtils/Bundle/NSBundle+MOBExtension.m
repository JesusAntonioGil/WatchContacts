//
//  NSBundle+MOBExtension.m
//  utils
//
//  Created by Alex Ruperez on 20/11/13.
//  Copyright (c) 2013 Mobusi. All rights reserved.
//

#import "NSBundle+MOBExtension.h"

#import "NSData+MOBJSON.h"


@implementation NSBundle (MOBExtension)

+ (NSString *)version
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

+ (NSString *)build
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
}

+ (NSString *)productName
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
}

- (NSData *)dataFromResource:(NSString *)resource type:(NSString *)type
{
    NSString *path = [self pathForResource:resource ofType:type];
    if (!path) return nil;
    
    NSError *error = nil;
    NSData *data = [NSData dataWithContentsOfFile:path options:kNilOptions error:&error];
    if (error)
    {
        NSLog(@"%@", error);
        return nil;
    }
    
    return data;
}

- (NSDictionary *)JSONFromResource:(NSString *)resource
{
    NSData *data = [self dataFromResource:resource type:@"json"];
    
    return [data toJSON];
}

@end
