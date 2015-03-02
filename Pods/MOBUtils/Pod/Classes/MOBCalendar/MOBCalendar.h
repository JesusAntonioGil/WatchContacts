//
//  MOBCalendar.h
//  Calendar
//
//  Created by Alex Ruperez on 12/05/14.
//  Copyright (c) 2014 Mobusi Mobile Services. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MOBCalendarComponents.h"
#import "MOBCalendarDayGeneral.h"


@class MOBCalendar;
@protocol MOBCalendarDelegate <NSObject>

- (void)calendar:(MOBCalendar *)calendar didSelectDate:(NSDate *)date;

@end


@interface MOBCalendar : UIView

@property (weak, nonatomic) id<MOBCalendarDelegate> delegate;

- (instancetype)initWithDelegate:(id<MOBCalendarDelegate>)delegate;

@property (assign, nonatomic) NSInteger currentMonth;
@property (assign, nonatomic) NSInteger numberOfMonths;
@property (assign, nonatomic) NSInteger year;
@property (strong, nonatomic) UIColor *themeColor;

@property (strong, nonatomic) UIFont *monthFont;
@property (strong, nonatomic) UIFont *yearFont;

@property (strong, nonatomic) NSArray *days;

@property (strong, nonatomic) NSDate *dateSelected;

- (void)setCurrentMonth:(NSInteger)currentMonth year:(NSInteger)year numberOfMonths:(NSInteger)numberOfMonths themeColor:(UIColor *)themeColor;

@end
