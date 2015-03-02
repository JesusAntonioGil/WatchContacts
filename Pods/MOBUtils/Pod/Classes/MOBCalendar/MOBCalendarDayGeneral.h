//
//  MOBCalendarDayGeneral.h
//  MOBUtils
//
//  Created by Alex Ruperez on 10/07/14.
//  Copyright (c) 2014 Mobusi. All rights reserved.
//

#import <Foundation/Foundation.h>

//Enum for Club Vips app

typedef NS_ENUM(NSUInteger, MOBCalendarDayGeneralState)
{
    MOBCalendarDayGeneralStateUnknown = -1,
    MOBCalendarDayGeneralStateComplete = 0,
    MOBCalendarDayGeneralStateAvailable = 1,
    MOBCalendarDayGeneralStateClosed = 2
};


@interface MOBCalendarDayGeneral : NSObject

@property (strong, nonatomic) NSDate *date;
@property (assign, nonatomic) MOBCalendarDayGeneralState state;

@end
