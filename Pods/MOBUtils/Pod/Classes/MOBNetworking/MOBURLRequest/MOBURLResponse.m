//
//  MOBURLResponse.m
//  utils
//
//  Created by Alex Ruperez on 13/03/14.
//  Copyright (c) 2014 Mobusi. All rights reserved.
//

#import "MOBURLResponse.h"

@implementation MOBURLResponse

- (instancetype)initWithData:(NSData *)data
{
    self = [super init];
    if (self)
    {
        self.success = YES;
        self.data = data;
    }
    return self;
}

- (instancetype)initWithError:(NSError *)error
{
    self = [super init];
    if (self)
    {
        self.success = NO;
        self.error = error;
    }
    return self;
}

- (instancetype)initWithSuccess:(BOOL)success
{
    self = [super init];
    if (self)
    {
        self.success = success;
    }
    return self;
}

@end
