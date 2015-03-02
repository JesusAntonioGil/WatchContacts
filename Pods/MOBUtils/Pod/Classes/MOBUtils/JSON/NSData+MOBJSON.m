//
//  NSData+MOBJSON.m
//  utils
//
//  Created by Alex Ruperez on 10/25/13.
//  Copyright (c) 2013 Mobusi. All rights reserved.
//

#import "NSData+MOBJSON.h"


@implementation NSData (MOBJSON)

- (id)toJSON
{
    NSError *error = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:self options:kNilOptions error:&error];
    if (error)
    {
        NSLog(@"%@", error);
        return nil;
    }
    else
    {
        return json;
    }
}

@end
