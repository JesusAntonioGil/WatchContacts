//
//  MOBFacebook.m
//  facebook
//
//  Created by Alex Ruperez on 10/09/14.
//  Copyright (c) 2014 MOB. All rights reserved.
//

#import "MOBFacebook.h"

#import <FacebookSDK/FacebookSDK.h>

#import "MOBLogManager.h"
#import "NSArray+MOBExtension.h"


@interface MOBFacebook ()

@property (strong, nonatomic) NSArray *readPermissions;
@property (strong, nonatomic) NSArray *publishPermissions;

@property (copy, nonatomic) MOBFacebookLoginCompletion loginCompletion;
@property (copy, nonatomic) MOBFacebookBasicInfoCompletion basicInfoCompletion;
@property (copy, nonatomic) MOBFacebookFacebookIdCompletion facebookIdCompletion;
@property (copy, nonatomic) MOBFacebookPostCompletion postCompletion;

@end


@implementation MOBFacebook

- (instancetype)init
{
	self = [super init];
	if (self != nil)
	{
        self.readPermissions = @[@"public_profile", @"email", @"user_birthday"];
        self.publishPermissions = @[@"publish_actions"];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAppDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
	}
	return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - NOTIFICATIONS

- (void)notificationAppDidBecomeActive:(NSNotification *)notification
{
	[FBAppCall handleDidBecomeActive];
}

#pragma mark - PUBLIC (Class Methods)

+ (BOOL)handleURL:(NSURL *)URL sourceApplication:(NSString *)sourceApplication
{
    return [FBAppCall handleOpenURL:URL sourceApplication:sourceApplication];
}

#pragma mark - PUBLIC (Instance Methods)

- (BOOL)isLogged
{
    return (FBSession.activeSession.state == FBSessionStateOpen
            || FBSession.activeSession.state == FBSessionStateOpenTokenExtended);
}

- (void)login:(MOBFacebookLoginCompletion)completion
{
    if (![self isLogged])
    {
        self.loginCompletion = completion;
        
        __weak typeof(self) this = self;
        [FBSession openActiveSessionWithReadPermissions:self.readPermissions
                                           allowLoginUI:YES
                                      completionHandler:^(FBSession *session, FBSessionState state, NSError *error)
         {
             [this stateChanged:session state:state error:error];
         }];
    }
    else
    {
        completion(YES, nil);
    }
}

- (void)retrieveBasicInfo:(MOBFacebookBasicInfoCompletion)completion
{
    if (![self isLogged])
    {
        __weak typeof(self) this = self;
        [self login:^(BOOL success, NSError *error) {
            if (success)
            {
                this.basicInfoCompletion = completion;
                [this requestBasicInfo];
            }
            else
            {
                completion(NO, nil, error);
            }
        }];
    }
    else
    {
        self.basicInfoCompletion = completion;
        [self requestBasicInfo];
    }
}

- (void)retrieveFacebookId:(MOBFacebookFacebookIdCompletion)completion
{
    if (![self isLogged])
    {
        __weak typeof(self) this = self;
        [self login:^(BOOL success, NSError *error) {
            if (success)
            {
                this.facebookIdCompletion = completion;
                [this requestFacebookId];
            }
            else
            {
                completion(NO, nil, error);
            }
        }];
    }
    else
    {
        self.facebookIdCompletion = completion;
        [self requestFacebookId];
    }
}

- (void)requestPublishPermissions:(void(^)(BOOL success, NSError *error))completion
{
    [[FBSession activeSession] requestNewPublishPermissions:self.publishPermissions
                                            defaultAudience:FBSessionDefaultAudienceFriends
                                          completionHandler:^(FBSession *session, NSError *error)
     {
         if (error)
         {
             MOBLogNSError(error);
             completion(NO, error);
         }
         else
         {
             completion(YES, nil);
         }
     }];
}

- (void)post:(MOBFacebookPost *)post completion:(MOBFacebookPostCompletion)completion
{
    if ([self isLogged] && [self hasPublishPermissions])
    {
        MOBLog(@"PERMISSIONS: %@", FBSession.activeSession.permissions);
        self.postCompletion = completion;
        [self doPost:post];
    }
    else if ([self isLogged])
    {
        __weak typeof(self) this = self;
        [self requestPublishPermissions:^(BOOL success, NSError *error) {
            MOBLog(@"PERMISSIONS: %@", FBSession.activeSession.permissions);
            if (success)
            {
                this.postCompletion = completion;
                [this doPost:post];
            }
            else
            {
                completion(NO, post, error);
            }
        }];
    }
    else
    {
        __weak typeof(self) this = self;
        [self loginForPublish:^(BOOL success, NSError *error) {
            MOBLog(@"PERMISSIONS: %@", FBSession.activeSession.permissions);
            if (success)
            {
                [this post:post completion:completion];
            }
            else
            {
                completion(NO, post, error);
            }
        }];
    }
}

#pragma mark - PRIVATE (Helpers)

- (BOOL)hasPublishPermissions
{
    return [FBSession.activeSession.permissions containsArray:self.publishPermissions];
}

- (BOOL)hasReadPermissions
{
    return [FBSession.activeSession.permissions containsArray:self.readPermissions];
}

- (NSString *)facebookAppId
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"FacebookAppID"];
}

#pragma mark - PRIVATE

- (void)stateChanged:(FBSession *)session state:(FBSessionState)state error:(NSError *)error
{
    if (!error && state == FBSessionStateOpen)
    {
        if (self.loginCompletion)
        {
            self.loginCompletion(YES, error);
        }
    }
    else if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed)
    {
        if (self.loginCompletion)
        {
            self.loginCompletion(NO, error);
        }
    }
    self.loginCompletion = nil;
    
    if (error)
    {
        [self logError:error];
        [FBSession.activeSession closeAndClearTokenInformation];
    }
}

- (void)requestBasicInfo
{
    __weak typeof(self) this = self;
    [FBRequestConnection startWithGraphPath:@"me?fields=id,first_name,middle_name,last_name,gender,birthday,email" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (error)
        {
            MOBLogNSError(error);
            if (this.basicInfoCompletion)
            {
                this.basicInfoCompletion(NO, nil, error);
            }
        }
        else
        {
            MOBLog(@"%@", result);
            MOBFacebookBasicInfo *basicInfo = [[MOBFacebookBasicInfo alloc] initWithJSON:result];
            if (this.basicInfoCompletion)
            {
                this.basicInfoCompletion(YES, basicInfo, error);
            }
        }
        
        this.basicInfoCompletion = nil;
    }];
}

- (void)requestFacebookId
{
    __weak typeof(self) this = self;
    [FBRequestConnection startWithGraphPath:@"me?fields=id" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (error)
        {
            MOBLogNSError(error);
            if (this.facebookIdCompletion)
            {
                this.facebookIdCompletion(NO, nil, error);
            }
        }
        else
        {
            MOBLog(@"%@", result);
            MOBFacebookBasicInfo *basicInfo = [[MOBFacebookBasicInfo alloc] initWithJSON:result];
            if (this.facebookIdCompletion)
            {
                this.facebookIdCompletion(YES, basicInfo.facebookId, error);
            }
        }
        
        this.facebookIdCompletion = nil;
    }];
}

- (void)doPost:(MOBFacebookPost *)post
{
	__weak typeof(self) this = self;
	[FBRequestConnection startWithGraphPath:@"me/feed"
								 parameters:[post parameters]
								 HTTPMethod:@"POST"
						  completionHandler:^(FBRequestConnection *connection, id result, NSError *error)
	 {
		 if (error)
		 {
             MOBLogNSError(error);
             this.postCompletion(NO, post, error);
		 }
		 else
		 {
             this.postCompletion(YES, post, nil);
		 }
         
         this.postCompletion = nil;
	 }];
}

- (void)logError:(NSError *)error
{
    NSString *errorText = nil;
    if ([FBErrorUtility shouldNotifyUserForError:error] == YES)
    {
        errorText = [FBErrorUtility userMessageForError:error];
    }
    else
    {
        if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled)
        {
            errorText = @"User cancelled login";
        }
        else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession)
        {
            errorText = @"Your current session is no longer valid. Please log in again.";
        }
        else
        {
            NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
            
            errorText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
        }
    }
    
    MOBLogError(errorText);
}

- (void)loginForPublish:(MOBFacebookLoginCompletion)completion
{
    self.loginCompletion = completion;
    
    __weak typeof(self) this = self;
    [FBSession openActiveSessionWithPublishPermissions:self.publishPermissions
                                       defaultAudience:FBSessionDefaultAudienceFriends
                                          allowLoginUI:YES
                                     completionHandler:^(FBSession *session, FBSessionState state, NSError *error)
     {
         [this stateChanged:session state:state error:error];
     }];
}

@end
