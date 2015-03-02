//
//  NSString+MOBJSON.m
//  utils
//
//  Created by Alex Ruperez on 10/17/13.
//  Copyright (c) 2013 Mobusi. All rights reserved.
//

#import "NSString+MOBJSON.h"


@implementation NSString (MOBJSON)

- (id)toJSON
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error = nil;
    NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    if (error)
    {
        NSLog(@"%@", error);
    }
    
    return json;
}

@end
