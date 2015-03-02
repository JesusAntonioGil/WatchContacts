//
//  MOBAlert.m
//  MOBUtils
//
//  Created by Alex Ruperez on 07/05/14.
//  Copyright (c) 2014 Mobusi. All rights reserved.
//

#import "MOBAlert.h"

#import "MOBLocalization.h"


@interface MOBAlert ()
<UIAlertViewDelegate>

@property (copy, nonatomic) MOBAlertActionBlock actionBlock;
@property (copy, nonatomic) MOBAlertAcceptBlock acceptBlock;

@end


@implementation MOBAlert

+ (instancetype)defaultAlert
{
    static MOBAlert *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.acceptButtonTitle = MOBLocalize(@"alert_accept");
        self.cancelButtonTitle = MOBLocalize(@"alert_cancel");
        self.title = @"";
    }
    return self;
}

#pragma mark - Public

- (void)alert:(NSString *)message
{
    self.actionBlock = nil;
    self.acceptBlock = nil;
    
    [[[UIAlertView alloc] initWithTitle:self.title message:message delegate:self cancelButtonTitle:self.acceptButtonTitle otherButtonTitles:nil] show];
}

- (void)alert:(NSString *)message usingBlock:(MOBAlertActionBlock)completion
{
    self.actionBlock = completion;
    self.acceptBlock = nil;
    
    [[[UIAlertView alloc] initWithTitle:self.title message:message delegate:self cancelButtonTitle:self.acceptButtonTitle otherButtonTitles:nil] show];
}

- (void)prompt:(NSString *)message usingBlock:(MOBAlertAcceptBlock)completion
{
    self.actionBlock = nil;
    self.acceptBlock = completion;
    
    [[[UIAlertView alloc] initWithTitle:self.title message:message delegate:self cancelButtonTitle:self.cancelButtonTitle otherButtonTitles:self.acceptButtonTitle, nil] show];
}

#pragma mark - Private

- (void)showAlertWithMessage:(NSString *)message
{
    [[[UIAlertView alloc] initWithTitle:self.title message:message delegate:self cancelButtonTitle:self.cancelButtonTitle otherButtonTitles:self.acceptButtonTitle, nil] show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.actionBlock)
    {
        self.actionBlock();
    }
    else if (self.acceptBlock)
    {
        self.acceptBlock(buttonIndex != alertView.cancelButtonIndex);
    }
}

@end
