//
//  MOBLogManager.h
//  utils
//
//  Created by Alex Ruperez on 17/03/14.
//  Copyright (c) 2014 Mobusi. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MOBLogMessage(message) [MOBLogManager logMessage:message]
#define MOBLog(format, ...) [MOBLogManager log:format, ##__VA_ARGS__]
#define MOBLogInfo(format, ...) [MOBLogManager info:format, ##__VA_ARGS__]
#define MOBLogWarn(format, ...) [MOBLogManager warn:format, ##__VA_ARGS__]
#define MOBLogNSError(error) [MOBLogManager logError:error]
#define MOBLogError(format, ...) [MOBLogManager error:format, ##__VA_ARGS__]
#define MOBLogException(exception) [MOBLogManager logException:exception]

#define MOBLogFunction() [MOBLogManager log:@"%s", __PRETTY_FUNCTION__]
#define MOBLogLine() [MOBLogManager log:@"=============================================================================================="]
#define MOBLogTitle(title) [MOBLogManager log:@"--- %@ ------------------------", title]
#define MOBLogDataAsString(name, data) [MOBLogManager log:@"%@: %@", name, [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]]
#define MOBLogBool(name, value) [MOBLogManager log:@"%@: %@", name, value ? @"YES" : @"NO"]


@interface MOBLogManager : NSObject

@property (strong, nonatomic) NSString *appName;
@property (assign, nonatomic) BOOL logEnabled;

+ (instancetype)shared;

+ (void)logMessage:(NSString *)message;
+ (void)log:(NSString *)format, ...;
+ (void)info:(NSString *)format, ...;
+ (void)warn:(NSString *)format, ...;
+ (void)error:(NSString *)format, ...;
+ (void)logError:(NSError *)error;
+ (void)logException:(NSException *)exception;

@end
