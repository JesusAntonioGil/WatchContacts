//
//  MOBCalendarComponents.h
//  Calendar
//
//  Created by Alex Ruperez on 12/05/14.
//  Copyright (c) 2014 Mobusi Mobile Services. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MOBCalendarComponents : NSObject

+ (NSUInteger)weeksOfMonth:(NSInteger)month year:(NSInteger)year;
+ (NSUInteger)dayOfWeek:(NSDate *)date;
+ (NSUInteger)firsDayOfMonth:(NSInteger)month year:(NSInteger)year;
+ (NSUInteger)weekOfMonth:(NSDate *)date;
+ (NSString *)dayNumber:(NSDate *)date;
+ (NSString *)monthName:(NSInteger)month;
+ (NSUInteger)daysOfMonth:(NSInteger)month year:(NSInteger)year;
+ (BOOL)isToday:(NSDate *)date;

/*! Returns is the first date is exactly equal to second date
 *  @param NSDate firstDate la fecha
 *  @param NSDate secondDate fecha 2
 *  @return BOOL valor de retorno
 */
+ (BOOL)compareDay:(NSDate *)firstDate secondDate:(NSDate *)secondDate;

/*! Returns is the day is past respect to the compare date*/
+ (BOOL)isPastDay:(NSDate *)date compareDate:(NSDate *)compareDate;

/*! Return the number of month from today to a specific date, including the first/current month*/
+ (NSUInteger)numberOfMonths:(NSDate *)date from:(NSDate *)fromDate;

+ (NSUInteger)currentMonth;
+ (NSUInteger)currentYear;
@end
