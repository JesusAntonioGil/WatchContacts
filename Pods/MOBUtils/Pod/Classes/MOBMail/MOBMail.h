//
//  MOBMail.h
//  MOBUtils
//
//  Created by Alex Ruperez on 10/09/14.
//  Copyright (c) 2014 Mobusi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MessageUI/MFMailComposeViewController.h>


@class MOBMail;
@protocol MOBMailDelegate <NSObject>

@optional
- (void)mobMailDidSend:(MOBMail *)mail;
- (void)mobMailDidSaveDraft:(MOBMail *)mail;
- (void)mobMailDidCancel:(MOBMail *)mail;
- (void)mobMail:(MOBMail *)mail didFailWithError:(NSError *)error;

@end

@interface MOBMail : MFMailComposeViewController

@property (weak, nonatomic) id<MOBMailDelegate> delegate;
@property (retain, nonatomic) NSString *body;
@property (assign, nonatomic) BOOL isHTML;

- (instancetype)initWithSubject:(NSString *)subject body:(NSString *)body recipient:(NSString *)recipient;

- (void)addToRecipient:(NSString *)recipient;
- (void)addCcRecipient:(NSString *)recipient;
- (void)addBccRecipient:(NSString *)recipient;
- (void)addImage:(UIImage *)image filename:(NSString *)filename;

@end
