//
//  NSFileManager+MOBExtension.m
//  utils
//
//  Created by Alex Ruperez on 19/11/13.
//  Copyright (c) 2013 Mobusi. All rights reserved.
//

#import "NSFileManager+MOBExtension.h"

#import "MOBLogManager.h"


@implementation NSFileManager (MOBExtension)

+ (NSString *)documentsPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    return paths[0];
}

- (BOOL)createDirectoryAtPath:(NSString *)path
{
    NSError *error = nil;
    BOOL result = [self createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:&error];
    
    if (error)
    {
        MOBLog(@"%s: %@", __PRETTY_FUNCTION__, error);
    }
    
    return result;
}

@end
