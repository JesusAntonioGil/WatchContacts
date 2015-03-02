//
//  NSDictionary+MOBExtension.h
//  MOBUtils
//
//  Created by Alex Ruperez on 08/04/14.
//  Copyright (c) 2014 Mobusi. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDictionary (MOBExtension)

- (BOOL)containsDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)dictionaryForKeys:(id)firstKey, ... NS_REQUIRES_NIL_TERMINATION;
- (NSDictionary *)dictionaryForKeysArray:(NSArray *)keys;

- (NSDictionary *)dictionaryAddingEntriesFromDictionary:(NSDictionary *)dictionary;

@end
