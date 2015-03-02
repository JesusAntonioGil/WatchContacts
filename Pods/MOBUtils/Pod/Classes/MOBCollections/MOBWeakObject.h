//
//  MOBWeakObject.h
//  MOBUtils
//
//  Created by Alex Ruperez on 21/10/14.
//  Copyright (c) 2014 Mobusi. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MOBWeakObject : NSObject

@property (weak, nonatomic) id object;

- (instancetype)initWithObject:(id)object;

@end
