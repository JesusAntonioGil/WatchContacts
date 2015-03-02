//
//  CALDayButton.h
//  Calendar
//
//  Created by Alex Ruperez on 14/05/14.
//  Copyright (c) 2014 Mobusi Mobile Services. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CALDayButtonStyle)
{
    CALDayButtonStyleToday=0,
    CALDayButtonStyleOrdinary,
    CALDayButtonStyleWeekend,
    CALDayButtonStyleUnavailable,
    CALDayButtonStyleUnknown,
    CALDayButtonDisabled
};


typedef void(^CALDayButtonStyleBlock)(BOOL selected);


@interface MOBCalendarDayButton : UIButton

@property (assign, nonatomic) CALDayButtonStyle style;
//@property (copy, nonatomic) CALDayButtonStyleBlock tappedBlock;

- (void)initWithStyle:(CALDayButtonStyle)style themeColor:(UIColor *)themeColor;

- (void)clean;

@end