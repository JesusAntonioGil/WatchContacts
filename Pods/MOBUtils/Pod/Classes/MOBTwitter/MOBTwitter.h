//
//  MOBTwitter.h
//  twitter
//
//  Created by Alex Ruperez on 15/09/14.
//  Copyright (c) 2014 Mobusi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MOBTwitterPost.h"


typedef NS_ENUM(NSInteger, MOBTwitterErrorCode) {
    MOBTwitterServiceUnavailableError,
    MOBTwitterMessageDontFitError,
    MOBTwitterURLDontFitError,
    MOBTwitterImageDontFitError,
    MOBTwitterUserCacelledError
};


typedef void(^MOBTwitterPostCompletion)(BOOL success, MOBTwitterPost *post, NSError *error);


@interface MOBTwitter : NSObject

- (void)post:(MOBTwitterPost *)post viewController:(UIViewController *)viewController completion:(MOBTwitterPostCompletion)completion;

@end
