//
//  CALDay.h
//  Calendar
//
//  Created by Alex Ruperez on 12/05/14.
//  Copyright (c) 2014 Mobusi Mobile Services. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, MOBCalendarDayType)
{
    CALDayTypeOrdinary=0,
    CALDayTypeWeekend,
    CALDayTypeToday,
    CALDAyTypeMonthTitle,
    CALDayTypeEmpty,
    CALDayTypePast
};

typedef NS_ENUM(NSUInteger, MOBCalendarDayState)
{
    CALDayStateAvailable=0,
    CALDayStateUnavailable,
    CALDayStateUnknown
};


@interface MOBCalendarDay : NSObject

@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) NSString *dayTitle;

@property (assign, nonatomic) NSInteger week;
@property (assign, nonatomic) NSInteger dayOfWeek;

@property (assign, nonatomic) NSInteger day;
@property (assign, nonatomic) NSInteger month;
@property (assign, nonatomic) NSInteger year;

@property (assign, nonatomic, readonly) MOBCalendarDayType type;

@property (assign, nonatomic) MOBCalendarDayState state;

- (instancetype)initWithDate:(NSInteger)day month:(NSInteger)month year:(NSInteger)year;

@end
