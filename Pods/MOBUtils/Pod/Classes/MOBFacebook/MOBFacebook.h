//
//  MOBFacebook.h
//  facebook
//
//  Created by Alex Ruperez on 10/09/14.
//  Copyright (c) 2014 MOB. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MOBFacebookBasicInfo.h"
#import "MOBFacebookPost.h"


typedef void(^MOBFacebookLoginCompletion)(BOOL success, NSError *error);
typedef void(^MOBFacebookBasicInfoCompletion)(BOOL success, MOBFacebookBasicInfo *basicInfo, NSError *error);
typedef void(^MOBFacebookFacebookIdCompletion)(BOOL success, NSString *facebookId, NSError *error);
typedef void(^MOBFacebookPostCompletion)(BOOL success, MOBFacebookPost *post, NSError *error);


@interface MOBFacebook : NSObject

+ (BOOL)handleURL:(NSURL *)URL sourceApplication:(NSString *)sourceApplication;

- (BOOL)isLogged;

- (void)login:(MOBFacebookLoginCompletion)completion;
- (void)retrieveBasicInfo:(MOBFacebookBasicInfoCompletion)completion;
- (void)retrieveFacebookId:(MOBFacebookFacebookIdCompletion)completion;
- (void)post:(MOBFacebookPost *)post completion:(MOBFacebookPostCompletion)completion;

@end
