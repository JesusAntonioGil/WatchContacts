//
//  MOBWeakObject.m
//  MOBUtils
//
//  Created by Alex Ruperez on 21/10/14.
//  Copyright (c) 2014 Mobusi. All rights reserved.
//

#import "MOBWeakObject.h"


@implementation MOBWeakObject

- (instancetype)initWithObject:(id)object
{
    self = [super init];
    if (self)
    {
        self.object = object;
    }
    return self;
}

@end
