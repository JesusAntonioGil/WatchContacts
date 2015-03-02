//
//  MOBURLNameGenerator.m
//  images
//
//  Created by Alex Ruperez on 28/06/14.
//  Copyright (c) 2014 Mobusi. All rights reserved.
//

#import "MOBURLNameGenerator.h"
#import "MOBDigest.h"

@implementation MOBURLNameGenerator

-  (NSString *)generateNameFromURL:(NSURL *)URL
{
    NSString *url = [URL absoluteString];
    
    if (url.length == 0) return nil;
    
    return [MOBDigest MD5:url];
}

@end
