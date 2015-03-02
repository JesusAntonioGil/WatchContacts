//
//  MOBFacebookBasicInfo.m
//  facebook
//
//  Created by Alex Ruperez on 10/09/14.
//  Copyright (c) 2014 MOB. All rights reserved.
//

#import "MOBFacebookBasicInfo.h"

#import "NSDictionary+MOBJSON.h"

@implementation MOBFacebookBasicInfo

- (id)initWithJSON:(NSDictionary *)json
{
    self = [super init];
    if (self)
    {
        self.facebookId = [json stringForKey:@"id"];
        self.name = [json stringForKey:@"first_name"];
        self.firstSurname = [json stringForKey:@"middle_name"];
        self.secondSurname = [json stringForKey:@"last_name"];
        self.email = [json stringForKey:@"email"];
        self.gender = MOBFacebookGenderFromString([json stringForKey:@"gender"]);
        self.birthday = [json dateForKey:@"birthday" format:@"MM/dd/yyyy"];
    }
    return self;
}

@end
