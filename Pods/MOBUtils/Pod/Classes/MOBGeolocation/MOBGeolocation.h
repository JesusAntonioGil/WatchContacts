//
//  MOBGeolocation.h
//  MOBUtils
//
//  Created by Alex Ruperez on 18/03/14.
//  Copyright (c) 2014 Mobusi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreLocation/CoreLocation.h>


typedef void(^MOBGeolocationCompletion)(BOOL success, BOOL authorized, CLLocation *location, NSError *error);


@interface MOBGeolocation : NSObject

- (void)locateCompletion:(MOBGeolocationCompletion)completion;

@end
