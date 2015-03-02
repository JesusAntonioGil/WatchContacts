//
//  MOBConsole.h
//  MOBConsole
//
//  Created by Alejandro Rupérez on 12/03/14.
//  Copyright (c) 2014 Alejandro Rupérez. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    MOBConsoleLogLevelNone = 0,
    MOBConsoleLogLevelCrash,
    MOBConsoleLogLevelError,
    MOBConsoleLogLevelWarning,
    MOBConsoleLogLevelInfo
}
MOBConsoleLogLevel;


@protocol MOBConsoleDelegate <NSObject>

- (void)mobConsoleDidEnterCommand:(NSString *)command;

@end


@interface MOBConsole : UIViewController

// enabled/disable console features
@property (assign, nonatomic) BOOL enabled; // DEBUG
@property (assign, nonatomic) BOOL saveLogToUserDefaults; // NO
@property (assign, nonatomic) BOOL saveLogToFile; // NO (Remember 'Application supports iTunes file sharing')
@property (assign, nonatomic) NSUInteger maxLogItems; // 1000
@property (assign, nonatomic) MOBConsoleLogLevel logLevel; // MOBConsoleLogLevelInfo
@property (weak, nonatomic) id<MOBConsoleDelegate> delegate;

// console activation
@property (assign, nonatomic) NSUInteger defaultSimulatorTouchesToShow; // 2
@property (assign, nonatomic) NSUInteger defaultDeviceTouchesToShow; // 3

// branding and feedback
@property (copy, nonatomic) NSString *infoString; // MOBConsole
@property (copy, nonatomic) NSString *inputPlaceholderString; // Enter command...
@property (copy, nonatomic) NSString *logSubmissionEmail; // nil (Format 'email1,email2...')

// styling
@property (strong, nonatomic) UIColor *backgroundColor; // black
@property (strong, nonatomic) UIColor *textColor; // green
@property (assign, nonatomic) UIScrollViewIndicatorStyle indicatorStyle; // white

+ (MOBConsole *)sharedConsole;

+ (void)logMessage:(NSString *)message;
+ (void)log:(NSString *)format, ...;
+ (void)info:(NSString *)format, ...;
+ (void)warn:(NSString *)format, ...;
+ (void)error:(NSString *)format, ...;
+ (void)crash:(NSString *)format, ...;
+ (void)logToFile:(NSString *)fileName log:(NSString *)format, ...; // Remember 'Application supports iTunes file sharing'

+ (void)clear;

+ (void)show;
+ (void)hide;

@end
