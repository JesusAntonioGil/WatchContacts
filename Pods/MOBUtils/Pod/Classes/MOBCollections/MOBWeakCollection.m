//
//  MOBWeakCollection.m
//  MOBUtils
//
//  Created by Alex Ruperez on 21/10/14.
//  Copyright (c) 2014 Mobusi. All rights reserved.
//

#import "MOBWeakCollection.h"

#import "MOBWeakObject.h"


@interface MOBWeakCollection ()

@property (strong, nonatomic) NSMutableDictionary *weakObjects;

@end


@implementation MOBWeakCollection

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.weakObjects = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#pragma mark - ACCESSORS

- (NSInteger)typesCount
{
    return self.weakObjects.count;
}

#pragma mark - PUBLIC

- (NSInteger)countForType:(NSString *)type
{
    if (type.length == 0) return 0;
    
    NSArray *weakObjects = [self weakObjectsForType:type];
    
    return weakObjects.count;
}

- (void)addObject:(id)object forType:(NSString *)type;
{
    if (!object || type.length == 0) return;
    
    NSMutableArray *weakObjects = [self weakObjectsForType:type];
    
    MOBWeakObject *weakObject = [[MOBWeakObject alloc] initWithObject:object];
    [weakObjects addObject:weakObject];
}

- (void)removeObject:(id)object forType:(NSString *)type
{
    if (!object || type.length == 0) return;
    
    NSMutableArray *weakObjects = [self weakObjectsForType:type];
    
    MOBWeakObject *weakObjectToRemove = nil;
    for (MOBWeakObject *weakObject in weakObjects)
    {
        if ([weakObject.object isEqual:object])
        {
            weakObjectToRemove = weakObject;
            break;
        }
    }
    
    if (weakObjectToRemove)
    {
        [weakObjects removeObject:weakObjectToRemove];
    }
    
    if (weakObjects.count == 0)
    {
        [self.weakObjects removeObjectForKey:type];
    }
}

- (void)enumerateType:(NSString *)type withBlock:(void(^)(id object))block
{
    if (type.length == 0 || !block) return;
    
    NSMutableArray *weakObjectsToRemove = [[NSMutableArray alloc] init];
    
    NSMutableArray *weakObjects = [self weakObjectsForType:type];
    for (MOBWeakObject *weakObject in weakObjects)
    {
        if (weakObject.object)
        {
            block(weakObject.object);
        }
        else
        {
            [weakObjectsToRemove addObject:weakObject];
        }
    }
    
    if (weakObjectsToRemove.count > 0)
    {
        [weakObjects removeObjectsInArray:weakObjectsToRemove];
    }
}

#pragma mark - PRIVATE

- (NSMutableArray *)weakObjectsForType:(NSString *)type
{
    NSMutableArray *weakObjects = self.weakObjects[type];
    
    if (!weakObjects)
    {
        weakObjects = [[NSMutableArray alloc] init];
        self.weakObjects[type] = weakObjects;
    }
    
    return weakObjects;
}

@end
