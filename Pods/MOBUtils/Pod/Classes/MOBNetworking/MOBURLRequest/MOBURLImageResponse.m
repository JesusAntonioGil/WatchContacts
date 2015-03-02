//
//  MOBURLImageResponse.m
//  utils
//
//  Created by Alex Ruperez on 14/03/14.
//  Copyright (c) 2014 Mobusi. All rights reserved.
//

#import "MOBURLImageResponse.h"


@implementation MOBURLImageResponse

- (instancetype)initWithData:(NSData *)data
{
    self = [super initWithData:data];
    if (self)
    {
        self.image = [UIImage imageWithData:data scale:[UIScreen mainScreen].scale];
    }
    return self;
}

@end
