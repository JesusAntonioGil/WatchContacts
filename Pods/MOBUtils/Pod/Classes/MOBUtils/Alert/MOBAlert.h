//
//  MOBAlert.h
//  MOBUtils
//
//  Created by Alex Ruperez on 07/05/14.
//  Copyright (c) 2014 Mobusi. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^MOBAlertActionBlock)(void);
typedef void(^MOBAlertAcceptBlock)(BOOL accepted);


@interface MOBAlert : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *acceptButtonTitle;
@property (strong, nonatomic) NSString *cancelButtonTitle;

+ (instancetype)defaultAlert;

- (void)alert:(NSString *)message;
- (void)alert:(NSString *)message usingBlock:(MOBAlertActionBlock)completion;
- (void)prompt:(NSString *)message usingBlock:(MOBAlertAcceptBlock)completion;

@end
