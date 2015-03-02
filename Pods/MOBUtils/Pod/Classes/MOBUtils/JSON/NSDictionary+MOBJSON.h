//
//  NSDictionary+MOBJSON.h
//  utils
//
//  Created by Alex Ruperez on 10/17/13.
//  Copyright (c) 2013 Mobusi. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDictionary (MOBJSON)

- (NSString *)toJSONString;
- (NSData *)toData;

- (NSInteger)integerForKey:(NSString *)key;
- (int)intForKey:(NSString *)key;
- (float)floatForKey:(NSString *)key;
- (NSUInteger)unsignedIntegerForKey:(NSString *)key;
- (BOOL)boolForKey:(NSString *)key;
- (NSArray *)arrayForKey:(NSString *)key;
- (NSString *)stringForKey:(NSString *)key;
- (NSString *)stringTrimForKey:(NSString *)key;
- (NSDictionary *)dictionaryForKey:(NSString *)key;
- (NSTimeInterval)timeIntervalForKey:(NSString *)key;
- (NSDate *)dateForKey:(NSString *)key format:(NSString *)format;
- (NSDate *)dateForKey:(NSString *)key format:(NSString *)format locale:(NSLocale *)locale;
- (NSURL *)URLForKey:(NSString *)key;

@end
