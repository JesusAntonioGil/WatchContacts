//
//  CALDay.m
//  Calendar
//
//  Created by Alex Ruperez on 12/05/14.
//  Copyright (c) 2014 Mobusi Mobile Services. All rights reserved.
//

#import "MOBCalendarDay.h"

#import "MOBCalendarComponents.h"


@interface MOBCalendarDay ()

@property (assign, nonatomic, readonly) BOOL isWeekend;
@property (assign, nonatomic, readonly) BOOL isToday;

@end

@implementation MOBCalendarDay

- (instancetype)initWithDate:(NSInteger)day month:(NSInteger)month year:(NSInteger)year
{
    self = [super init];
    if (self)
	{
        _day = day;
        _month = month;
        _year = year;
        
        [self initialize];
    }
    
    return self;
}

- (MOBCalendarDayType)type
{
    if (self.isWeekend)
    {
        return CALDayTypeWeekend;
    }
    else if (self.isToday)
    {
        return CALDayTypeToday;
    }
    else
    {
        return CALDayTypeOrdinary;
    }
}

- (BOOL)isWeekend
{
    return self.dayOfWeek > 5;
}

- (BOOL)isToday
{
    return [MOBCalendarComponents isToday:self.date];
}

#pragma mark - Private Methods

- (void)initialize
{
    [self setDate];
    
    self.week = [MOBCalendarComponents weekOfMonth:self.date];
    self.dayTitle = [MOBCalendarComponents dayNumber:self.date];
    self.dayOfWeek = [MOBCalendarComponents dayOfWeek:self.date];
}

- (void)setDate
{
    NSDateComponents *dateComponent = [[NSDateComponents alloc]init];
    
    [dateComponent setDay:self.day];
    [dateComponent setMonth:self.month];
    [dateComponent setYear:self.year];
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    
    self.date = [gregorian dateFromComponents:dateComponent];
}

@end
