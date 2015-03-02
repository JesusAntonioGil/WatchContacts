//
//  MOBFacebookGenderType.h
//  facebook
//
//  Created by Alex Ruperez on 10/09/14.
//  Copyright (c) 2014 MOB. All rights reserved.
//

#ifndef facebook_MOBFacebookGenderType_h
#define facebook_MOBFacebookGenderType_h


typedef NS_ENUM(char, MOBFacebookGender)
{
    MOBFacebookGenderUnknown,
    MOBFacebookGenderMale,
    MOBFacebookGenderFemale
};

__unused static MOBFacebookGender MOBFacebookGenderFromString(NSString *genderString)
{
    MOBFacebookGender gender = MOBFacebookGenderUnknown;
    
    if ([genderString isEqualToString:@"male"])
    {
        gender = MOBFacebookGenderMale;
    }
    else if ([genderString isEqualToString:@"female"])
    {
        gender = MOBFacebookGenderFemale;
    }
    
    return gender;
}


#endif
