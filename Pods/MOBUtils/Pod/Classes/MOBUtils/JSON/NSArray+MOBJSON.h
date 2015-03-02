//
//  NSArray+MOBJSON.h
//  utils
//
//  Created by Alex Ruperez on 10/17/13.
//  Copyright (c) 2013 Mobusi. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSArray (MOBJSON)

- (NSString *)toJSONString;
- (NSData *)toData;

@end
