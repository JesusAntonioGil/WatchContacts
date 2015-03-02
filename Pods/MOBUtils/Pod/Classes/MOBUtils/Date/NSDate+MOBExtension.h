//
//  NSDate+MOBExtension.h
//  utils
//
//  Created by Alex Ruperez on 16/09/2013.
//  Copyright (c) 2013 Mobusi. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDate (MOBExtension)

+ (NSDate *)dateFromString:(NSString *)dateString format:(NSString *)format;
+ (NSDate *)dateFromString:(NSString *)dateString format:(NSString *)format locale:(NSLocale *)locale;
+ (NSDate *)randomDate;
+ (NSTimeInterval)timeIntervalSince1970;
+ (NSDate *)today;
+ (NSDate *)yesterday;
+ (NSDate *)afterYesterday;
+ (NSDate *)tomorrow;

- (NSInteger)numberOfDaysFromNow;

- (NSDate *)dateByAddingDays:(NSInteger)days;

- (NSString *)stringWithFormat:(NSString *)dateFormat;
- (NSString *)stringWithFormat:(NSString *)dateFormat locale:(NSLocale *)locale;
- (BOOL)isToday;
- (BOOL)isYesterday;

- (BOOL)compareToSecondsWithDate:(NSDate *)date;

@end
