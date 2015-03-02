//
//  MOBCalendarComponents.m
//  Calendar
//
//  Created by Alex Ruperez on 12/05/14.
//  Copyright (c) 2014 Mobusi Mobile Services. All rights reserved.
//

#import "MOBCalendarComponents.h"

#import "NSDate+MOBExtension.h"

@implementation MOBCalendarComponents

#pragma mark - Class Methods

+ (NSUInteger)weeksOfMonth:(NSInteger)month year:(NSInteger)year
{
    NSCalendar *gregorian = [self calendar];
    
    NSDateComponents *dateComponent = [[NSDateComponents alloc]init];
    
    [dateComponent setDay:0];
    [dateComponent setMonth:month+1];
    [dateComponent setYear:year];
    
    NSDate *date =[gregorian dateFromComponents:dateComponent];
    
    NSDateComponents* components = [gregorian components:NSWeekOfMonthCalendarUnit fromDate:date];
    
    return [components weekOfMonth];
}

+ (NSUInteger)dayOfWeek:(NSDate *)date
{
    NSCalendar *gregorian = [self calendar];
    
    NSDateComponents *components = [gregorian components:NSWeekdayCalendarUnit fromDate:date];
    
    NSInteger weekday = [components weekday];

    if (weekday == 1)
    {
        weekday = 7;
    }
    else
    {
        weekday--;
    }
    
    return weekday;
}

+ (NSUInteger)firsDayOfMonth:(NSInteger)month year:(NSInteger)year
{
    NSDateComponents *dateComponent = [[NSDateComponents alloc]init];
    
    [dateComponent setDay:1];
    [dateComponent setMonth:month];
    [dateComponent setYear:year];
    
    NSCalendar *gregorian = [self calendar];
    
    NSDate *date =[gregorian dateFromComponents:dateComponent];
    
    NSDateComponents* components = [gregorian components:NSWeekdayCalendarUnit fromDate:date];
    
    NSInteger weekday = [components weekday];
    
    if (weekday == 1)
    {
        weekday = 7;
    }
    else
    {
        weekday--;
    }
    
    return weekday;
}

+ (NSString *)monthName:(NSInteger)month
{
    NSString *monthDate = [NSString stringWithFormat:@"%ld", (long)month];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MM";
    NSDate *date = [dateFormatter dateFromString:monthDate];

    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"es_ES"];
    dateFormatter.dateFormat=@"MMM";
    
    return [[[dateFormatter stringFromDate:date] capitalizedString] uppercaseString];
}

+ (NSUInteger)weekOfMonth:(NSDate *)date
{
    NSCalendar *gregorian = [self calendar];
    
    NSDateComponents *components = [gregorian components:(NSWeekOfMonthCalendarUnit) fromDate:date];
    
    return [components weekOfMonth];
}

+ (NSString *)dayNumber:(NSDate *)date
{
    NSCalendar *gregorian = [self calendar];
    
    NSDateComponents *components = [gregorian components:(NSDayCalendarUnit|NSMonthCalendarUnit) fromDate:date];
    
    NSString *dayStr = [NSString stringWithFormat:@"%ld", (long)[components day]];
    
    return dayStr;
}

+ (NSUInteger)daysOfMonth:(NSInteger)month year:(NSInteger)year
{
    NSDateComponents *dateComponent = [[NSDateComponents alloc] init];
    
    [dateComponent setDay:0];
    [dateComponent setMonth:month+1];
    [dateComponent setYear:year];
    
    NSCalendar *gregorian = [self calendar];
    
    NSDate *date =[gregorian dateFromComponents:dateComponent];
    
    NSDateComponents* components = [gregorian components:NSDayCalendarUnit fromDate:date];
    
    return [components day];
}

+ (BOOL)isToday:(NSDate *)date
{
    NSCalendar *calendar = [self calendar];
    NSDateComponents *componentsDate = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
    NSDateComponents *componentsToday = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
    
    if (componentsDate.day == componentsToday.day &&
        componentsDate.month == componentsToday.month &&
        componentsDate.year == componentsToday.year)
    {
        return true;
    }
    else
    {
        return false;
    }
}

+ (BOOL)compareDay:(NSDate *)firstDate secondDate:(NSDate *)secondDate
{
    NSCalendar *calendar = [self calendar];
    NSDateComponents *componentsFirstDate = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:firstDate];
    NSDateComponents *componentsSecondDate = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:secondDate];
    
    if (componentsFirstDate.day == componentsSecondDate.day &&
        componentsFirstDate.month == componentsSecondDate.month &&
        componentsFirstDate.year == componentsSecondDate.year)
    {
        return true;
    }
    else
    {
        return false;
    }
}

+ (BOOL)isPastDay:(NSDate *)date compareDate:(NSDate *)compareDate
{
    NSCalendar *calendar = [self calendar];
    NSDateComponents *componentsDate = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
    NSDateComponents *componentsCompareDate = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:compareDate];
    
    if (componentsCompareDate.year >= componentsDate.year
        && (componentsCompareDate.year >= componentsDate.year && componentsCompareDate.month >= componentsDate.month)
        && (componentsCompareDate.year >= componentsDate.year && componentsCompareDate.month >= componentsDate.month && componentsCompareDate.day > componentsDate.day))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (NSUInteger)currentMonth
{
    NSCalendar *gregorian = [self calendar];
    
    NSDateComponents *components = [gregorian components:NSMonthCalendarUnit fromDate:[NSDate date]];
    
    return [components month];
}

+ (NSUInteger)numberOfMonths:(NSDate *)toDate from:(NSDate *)fromDate
{
    NSCalendar *calendar = [self calendar];
    NSDateComponents *componentsTo = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit fromDate:toDate];
    NSDateComponents *componentsFrom = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit fromDate:fromDate];
    
    if (componentsTo.year == componentsFrom.year)
    {
        return (componentsTo.month - componentsFrom.month + 1);
    }
    else if (componentsTo.year >= componentsFrom.year)
    {
        return (12 - componentsFrom.month) + 1 + componentsTo.month;
    }
    else
    {
        return 0;
    }
}

+ (NSUInteger)currentYear
{
    NSCalendar *gregorian = [self calendar];
    
    NSDateComponents *components = [gregorian components:NSYearCalendarUnit fromDate:[NSDate date]];
    
    return [components year];
}

#pragma mark - Private Methods

+ (NSCalendar *)calendar
{
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorian setFirstWeekday:2];
    
    return gregorian;
}

@end
