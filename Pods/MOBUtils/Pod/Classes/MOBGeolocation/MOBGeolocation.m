//
//  MOBGeolocation.m
//  MOBUtils
//
//  Created by Alex Ruperez on 18/03/14.
//  Copyright (c) 2014 Mobusi. All rights reserved.
//

#import "MOBGeolocation.h"


@interface MOBGeolocation ()
<CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (copy, nonatomic) MOBGeolocationCompletion completion;

@end


@implementation MOBGeolocation

- (id)init
{
	self = [super init];
	if (self != nil)
	{
		self.locationManager = [[CLLocationManager alloc] init];
		self.locationManager.delegate = self;
	}
	return self;
}

#pragma mark - Public

- (void)locateCompletion:(MOBGeolocationCompletion)completion
{
    self.completion = completion;
    [self start];
}

#pragma mark - Private

- (void)updateLocation:(CLLocation *)location
{
    if (self.completion)
    {
        self.completion(YES, YES, location, nil);
    }
    
    [self stop];
}

- (void)start
{
    if ([CLLocationManager locationServicesEnabled])
    {
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
        {
            [self.locationManager requestWhenInUseAuthorization];
        }
        
        [self.locationManager startUpdatingLocation];
    }
}

- (void)stop
{
    self.completion = nil;
    [self.locationManager stopUpdatingLocation];
}

#pragma mark - Private

- (BOOL)isAuthorizedStatus:(CLAuthorizationStatus)status
{
    return (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorized);
}

#pragma mark - CLLocationManager Delegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if ([self isAuthorizedStatus:status])
    {
        [self.locationManager startUpdatingLocation];
    }
    else if (self.completion)
    {
        self.completion(NO, NO, nil, nil);
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
	[self updateLocation:newLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
	[self updateLocation:[locations lastObject]];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if (self.completion)
    {
        BOOL authorized = [self isAuthorizedStatus:CLLocationManager.authorizationStatus];
        if (self.locationManager.location)
        {
            self.completion(YES, authorized, self.locationManager.location, error);
        }
        else
        {
            self.completion(NO, authorized, nil, error);
        }
    }
    
    [self stop];
}

@end
