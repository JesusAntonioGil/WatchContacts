//
//  MOBTwitter.m
//  twitter
//
//  Created by Alex Ruperez on 15/09/14.
//  Copyright (c) 2014 Mobusi. All rights reserved.
//

#import "MOBTwitter.h"

#import <Social/Social.h>
#import "NSError+MOBExtension.h"


static NSString * const MOBTwitterErrorDomain = @"com.Mobusi.twitter";


@implementation MOBTwitter

#pragma mark - PUBLIC

- (void)post:(MOBTwitterPost *)post viewController:(UIViewController *)viewController completion:(MOBTwitterPostCompletion)completion
{
    if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        completion(NO, post, [self errorWithCode:MOBTwitterServiceUnavailableError]);
        return;
    }
    
    SLComposeViewController *composeViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    
    if (composeViewController)
    {
        if (![composeViewController setInitialText:post.message])
        {
            completion(NO, post, [self errorWithCode:MOBTwitterMessageDontFitError]);
            return;
        }
        if (![composeViewController addURL:post.URL])
        {
            completion(NO, post, [self errorWithCode:MOBTwitterURLDontFitError]);
            return;
        }
        if (![composeViewController addImage:post.image])
        {
            completion(NO, post, [self errorWithCode:MOBTwitterImageDontFitError]);
            return;
        }
        [composeViewController setCompletionHandler:^(SLComposeViewControllerResult result) {
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    completion(NO, post, [self errorWithCode:MOBTwitterUserCacelledError]);
                    break;
                case SLComposeViewControllerResultDone:
                    completion(YES, post, nil);
                    break;
            }
        }];
        
        [viewController presentViewController:composeViewController animated:YES completion:nil];
    }
}

#pragma mark - PRIVATE

- (NSError *)errorWithCode:(MOBTwitterErrorCode)code
{
    NSString *message = nil;
    switch (code) {
        case MOBTwitterServiceUnavailableError:
            message = @"Service Unavailable";
            break;
        case MOBTwitterImageDontFitError:
            message = @"Image doesn't fit";
            break;
        case MOBTwitterMessageDontFitError:
            message = @"Message doesn't fit";
            break;
        case MOBTwitterURLDontFitError:
            message = @"URL doesn't fit";
            break;
        case MOBTwitterUserCacelledError:
            message = @"User cancelled post";
            break;
    }
    return [NSError errorWithDomain:MOBTwitterErrorDomain code:code message:message];
}

@end
