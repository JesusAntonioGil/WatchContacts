//
//  MOBWeakCollection.h
//  MOBUtils
//
//  Created by Alex Ruperez on 21/10/14.
//  Copyright (c) 2014 Mobusi. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MOBWeakCollection : NSObject

@property (assign, nonatomic, readonly) NSInteger typesCount;

- (NSInteger)countForType:(NSString *)type;

- (void)addObject:(id)object forType:(NSString *)type;
- (void)removeObject:(id)object forType:(NSString *)type;

- (void)enumerateType:(NSString *)type withBlock:(void(^)(id object))block;

@end
