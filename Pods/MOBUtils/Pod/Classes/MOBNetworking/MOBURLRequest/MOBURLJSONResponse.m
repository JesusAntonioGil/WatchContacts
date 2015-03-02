//
//  MOBURLJSONResponse.m
//  utils
//
//  Created by Alex Ruperez on 14/03/14.
//  Copyright (c) 2014 Mobusi. All rights reserved.
//

#import "MOBURLJSONResponse.h"


@implementation MOBURLJSONResponse

- (instancetype)initWithData:(NSData *)data
{
    self = [super initWithData:data];
    if (self)
    {
        if (data)
        {
            NSError *error = nil;
            self.json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            if (!self.json)
            {
                self.success = NO;
                self.error = error;
            }
        }
    }
    return self;
}
@end
