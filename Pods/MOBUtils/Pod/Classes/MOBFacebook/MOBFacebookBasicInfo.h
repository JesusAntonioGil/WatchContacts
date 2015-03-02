//
//  MOBFacebookBasicInfo.h
//  facebook
//
//  Created by Alex Ruperez on 10/09/14.
//  Copyright (c) 2014 MOB. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MOBFacebookGenderType.h"


@interface MOBFacebookBasicInfo : NSObject

@property (strong, nonatomic) NSString *facebookId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *firstSurname;
@property (strong, nonatomic) NSString *secondSurname;
@property (strong, nonatomic) NSString *email;
@property (assign, nonatomic) MOBFacebookGender gender;
@property (strong, nonatomic) NSDate *birthday;

- (instancetype)initWithJSON:(NSDictionary *)json;

@end
