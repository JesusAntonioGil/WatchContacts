//
//  MOBURLResponse.h
//  utils
//
//  Created by Alex Ruperez on 13/03/14.
//  Copyright (c) 2014 Mobusi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MOBDebug.h"


@interface MOBURLResponse : NSObject

@property (assign, nonatomic) BOOL success;
@property (strong, nonatomic) NSError *error;
@property (strong, nonatomic) NSData *data;

- MOB_OVERRIDE (instancetype)initWithData:(NSData *)data;
- (instancetype)initWithError:(NSError *)error;
- (instancetype)initWithSuccess:(BOOL)success;

@end
