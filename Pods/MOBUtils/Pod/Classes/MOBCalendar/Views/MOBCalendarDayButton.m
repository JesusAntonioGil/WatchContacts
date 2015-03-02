//
//  CALDayButton.m
//  Calendar
//
//  Created by Alex Ruperez on 14/05/14.
//  Copyright (c) 2014 Mobusi Mobile Services. All rights reserved.
//

#import "MOBCalendarDayButton.h"

#import "UIImage+MOBExtension.h"
#import "UIColor+MOBExtension.h"


@implementation MOBCalendarDayButton

#pragma mark - Init

- (void)initWithStyle:(CALDayButtonStyle)style themeColor:(UIColor *)themeColor
{
    [self initialize:style themeColor:themeColor];
}

#pragma mark - Custom Accessors

- (void)setStyle:(CALDayButtonStyle)style
{
    _style = style;
    
    [self initialize:style themeColor:nil];
}

#pragma mark - Public Methods

- (void)clean
{
    self.selected = NO;
    self.hidden = NO;
    [self setTitle:@"" forState:UIControlStateNormal];
}

#pragma mark - Private Methods

- (void)initialize:(CALDayButtonStyle)style themeColor:(UIColor *)themeColor
{
    if (style == CALDayButtonDisabled)
    {
        self.hidden = YES;
        return;
    }
    
    switch (style)
    {
        case CALDayButtonStyleUnavailable:
            [self setBackgroundImage:[UIImage imageNamed:@"day_unavailable"]  forState:UIControlStateNormal];
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            break;
        case CALDayButtonStyleToday:
            [self setBackgroundImage:[UIImage imageNamed:@"day_transparent"] forState:UIControlStateNormal];
            [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            break;
        case CALDayButtonStyleOrdinary:
            [self setBackgroundImage:[UIImage imageNamed:@"day_transparent"] forState:UIControlStateNormal];
            [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            break;
        case CALDayButtonStyleWeekend:
            [self setBackgroundImage:[UIImage imageNamed:@"day_transparent"] forState:UIControlStateNormal];
            [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            break;
        case CALDayButtonStyleUnknown:
                [self setBackgroundImage:[UIImage imageFromMaskImage:[UIImage imageNamed:@"today_ellipse"] withColor:[UIColor colorFromHex:0xefefef]]  forState:UIControlStateNormal];
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    
    [self setBackgroundImage:[UIImage imageFromMaskImage:[UIImage imageNamed:@"today_ellipse"] withColor:themeColor]  forState:UIControlStateSelected];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
}

@end
