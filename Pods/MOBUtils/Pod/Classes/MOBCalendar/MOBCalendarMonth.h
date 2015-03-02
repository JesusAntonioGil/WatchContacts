//
//  CALMonth.h
//  Calendar
//
//  Created by Alex Ruperez on 12/05/14.
//  Copyright (c) 2014 Mobusi Mobile Services. All rights reserved.
//

#import <Foundation/Foundation.h>


@class MOBCalendarDay;


@interface MOBCalendarMonth : NSObject

@property (assign, nonatomic) NSInteger month;
@property (assign, nonatomic) NSInteger year;

@property (strong, nonatomic) NSArray *days;
@property (assign, nonatomic) NSInteger weeks;
@property (strong, nonatomic, readonly) NSString *monthTitle;
@property (assign, nonatomic, readonly) NSInteger firstDayOfMonth;

@property (strong, nonatomic) NSArray *availableDays;

- (instancetype)initWithMonth:(NSInteger)month year:(NSInteger)year;
- (instancetype)initWithMonth:(NSInteger)month year:(NSInteger)year availableDays:(NSArray *)availableDays;

- (MOBCalendarDay *)day:(NSInteger)dayOfWeek week:(NSInteger)week;

@end
