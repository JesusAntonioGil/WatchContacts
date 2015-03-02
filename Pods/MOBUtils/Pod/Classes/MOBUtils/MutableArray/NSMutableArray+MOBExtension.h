//
//  NSMutableArray+MOBExtension.h
//  MOBUtils
//
//  Created by Alex Ruperez on 16/09/14.
//  Copyright (c) 2014 Mobusi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (MOBExtension)

// returns NO if the object can not be added
- (BOOL)addObjectSafe:(id)object;

@end
