//
//  CALMonth.m
//  Calendar
//
//  Created by Alex Ruperez on 12/05/14.
//  Copyright (c) 2014 Mobusi Mobile Services. All rights reserved.
//

#import "MOBCalendarMonth.h"

#import "MOBCalendarComponents.h"
#import "MOBCalendarDay.h"

#import "MOBCalendarDayGeneral.h"


@implementation MOBCalendarMonth

#pragma mark - Init

- (instancetype)initWithMonth:(NSInteger)month year:(NSInteger)year
{
    self = [super init];
    if (self)
	{
        _month = month;
        _year = year;
        
        [self setDays];
    }
    
    return self;
}

- (instancetype)initWithMonth:(NSInteger)month year:(NSInteger)year availableDays:(NSArray *)availableDays
{
    self = [super init];
    if (self)
	{
        _month = month;
        _year = year;
        _availableDays = availableDays;
        
        [self setDays];
    }
    
    return self;
}

#pragma mark - Private Methods

- (void)initialize
{
    [self setDays];
}

- (void)setDays
{
    NSInteger totalDays = [MOBCalendarComponents daysOfMonth:self.month year:self.year];
    
    NSMutableArray *mutableCopy = [[NSMutableArray alloc] init];
    
    for (int i = 1; i <= totalDays; i++)
    {
        MOBCalendarDay *day = [[MOBCalendarDay alloc] initWithDate:i month:self.month year:self.year];
        
        [self setStateDay:day];
        
        [mutableCopy addObject:day];
    }
    
    self.days = mutableCopy;
}

- (void)setStateDay:(MOBCalendarDay *)day
{
    MOBCalendarDayGeneral *scheduleDay = [self scheduleDay:day.date];
    
    if (scheduleDay)
    {
        switch (scheduleDay.state)
        {
            case MOBCalendarDayGeneralStateAvailable:
                day.state = CALDayStateAvailable;
                break;
            case MOBCalendarDayGeneralStateComplete:
                day.state = CALDayStateUnavailable;
                break;
            case MOBCalendarDayGeneralStateClosed:
                day.state = CALDayStateUnavailable;
                break;
            default:
                day.state = CALDayStateUnknown;
                break;
        }
    }
    else
    {
        day.state = CALDayStateUnknown;
    }
}

- (MOBCalendarDayGeneral *)scheduleDay:(NSDate *)date
{
    for (MOBCalendarDayGeneral *day in self.availableDays)
    {
        if ([MOBCalendarComponents compareDay:day.date secondDate:date])
        {
            return day;
        }
    }
    
    return nil;
}

#pragma mark - Public Methods

- (MOBCalendarDay *)day:(NSInteger)dayOfWeek week:(NSInteger)week
{
    for (MOBCalendarDay *day in self.days)
    {
        if (day.dayOfWeek == dayOfWeek && day.week == week)
        {
            return day;
        }
    }
    
    return nil;
}

- (NSInteger)firstDayOfMonth
{
    return [MOBCalendarComponents firsDayOfMonth:self.month year:self.year];
}

- (NSString *)monthTitle
{
    return [MOBCalendarComponents monthName:self.month];
}

@end
