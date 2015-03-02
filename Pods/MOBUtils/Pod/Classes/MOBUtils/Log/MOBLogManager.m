//
//  MOBLogManager.m
//  utils
//
//  Created by Alex Ruperez on 17/03/14.
//  Copyright (c) 2014 Mobusi. All rights reserved.
//

#import "MOBLogManager.h"

#import "MOBConsole.h"
#import "NSBundle+MOBExtension.h"

@interface MOBLogManager ()
<MOBConsoleDelegate>

@end


@implementation MOBLogManager

+ (instancetype)shared
{
	static MOBLogManager *instance = nil;
	
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
		instance = [[MOBLogManager alloc] init];
    });
	
	return instance;
}

+ (void)load
{
    [MOBLogManager performSelectorOnMainThread:@selector(shared) withObject:nil waitUntilDone:NO];
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
		self.appName = [NSBundle productName];
#ifdef DEBUG
		self.logEnabled = YES;
#else
        self.logEnabled = NO;
#endif
        
        [MOBConsole sharedConsole].delegate = self;
    }
    return self;
}

#pragma mark - Public

+ (void)logMessage:(NSString *)message
{
    if ([MOBLogManager shared].logEnabled)
    {
        [MOBLogManager logString:message withHeader:YES];
        [MOBConsole logMessage:message];
    }
}

+ (void)log:(NSString *)format, ...
{
	va_list ap;
	va_start(ap, format);
	NSString *output = [[NSString alloc] initWithFormat:format arguments:ap];
	va_end(ap);
	
	if ([MOBLogManager shared].logEnabled)
	{
		[MOBLogManager logString:output withHeader:YES];
        [MOBConsole log:output];
	}
}

+ (void)info:(NSString *)format, ...
{
	va_list ap;
	va_start(ap, format);
	NSString *output = [[NSString alloc] initWithFormat:format arguments:ap];
	va_end(ap);
    
	if ([MOBLogManager shared].logEnabled)
	{
		NSString *caller = [MOBLogManager caller];
		NSString *log = [NSString stringWithFormat:@"ℹ️ℹ️ℹ️ INFO: %@\nℹ️ℹ️ℹ️ ⤷ FROM CALLER: %@", output, caller];
		
		[MOBLogManager logString:log withHeader:NO];
        [MOBConsole info:log];
	}
}

+ (void)warn:(NSString *)format, ...
{
	va_list ap;
	va_start(ap, format);
	NSString *output = [[NSString alloc] initWithFormat:format arguments:ap];
	va_end(ap);
	
	if ([MOBLogManager shared].logEnabled)
	{
		NSString *caller = [MOBLogManager caller];
		NSString *log = [NSString stringWithFormat:@"🚸🚸🚸 WARNING: %@\n🚸🚸🚸 ⤷ FROM CALLER: %@\n", output, caller];
		
        [MOBLogManager logString:@"" withHeader:NO];
		[MOBLogManager logString:log withHeader:NO];
        [MOBLogManager logString:@"" withHeader:NO];
        [MOBConsole warn:log];
	}
}

+ (void)error:(NSString *)format, ...
{
	va_list ap;
	va_start(ap, format);
	NSString *output = [[NSString alloc] initWithFormat:format arguments:ap];
	va_end(ap);
	
	if ([MOBLogManager shared].logEnabled)
	{
		NSString *caller = [MOBLogManager caller];
		NSString *log = [NSString stringWithFormat:@"❌❌❌ ERROR: %@\n❌❌❌ ⤷ FROM CALLER: %@\n", output, caller];
		
        [MOBLogManager logString:@"" withHeader:NO];
		[MOBLogManager logString:log withHeader:NO];
        [MOBLogManager logString:@"" withHeader:NO];
        [MOBConsole error:log];
	}
}

+ (void)logError:(NSError *)error
{
	if ([MOBLogManager shared].logEnabled)
	{
		NSString *caller = [MOBLogManager caller];
		NSString *log = [NSString stringWithFormat:@"❌❌❌ ERROR: %@\n❌❌❌ ⤷ FROM CALLER: %@\n❌❌❌ ⤷ USER INFO:\n%@", error.localizedDescription, caller, error.userInfo];
        
        [MOBLogManager logString:@"" withHeader:NO];
		[MOBLogManager logString:log withHeader:NO];
        [MOBLogManager logString:@"" withHeader:NO];
        [MOBConsole error:log];
	}
}

+ (void)logException:(NSException *)exception
{
	if ([MOBLogManager shared].logEnabled)
	{
		NSString *caller = [MOBLogManager caller];
		NSString *log = [NSString stringWithFormat:@"‼️‼️‼️ EXCEPTION: %@\n‼️‼️‼️ ⤷ FROM CALLER: %@\n‼️‼️‼️ ⤷ STACK:\n%@", exception.name, caller, [exception callStackSymbols]];
        
        [MOBLogManager logString:@"" withHeader:NO];
		[MOBLogManager logString:log withHeader:NO];
        [MOBLogManager logString:@"" withHeader:NO];
        [MOBConsole error:log];
	}
}

#pragma mark - Private

+ (NSString *)caller
{
	NSArray *syms = [NSThread  callStackSymbols];
	NSString *aux = @"";
	NSString *caller = [syms objectAtIndex:2];
	
	if (([caller rangeOfString:@"["].location != NSNotFound) && ([caller rangeOfString:@"]"].location != NSNotFound))
	{
		NSInteger index = [caller rangeOfString:@"["].location;
		if (index > 0)
		{
			aux = [caller substringToIndex:index];
			caller = [caller stringByReplacingOccurrencesOfString:aux withString:@""];
		}
		
		index = [caller rangeOfString:@"]"].location;
		if (index > 0)
		{
			aux = [caller substringFromIndex:index];
			caller = [caller stringByReplacingOccurrencesOfString:aux withString:@"]"];
		}
	}
	
	return caller;
}

+ (NSString *)currentTime
{
	NSDateFormatter *formater = [[NSDateFormatter alloc] init];
	formater.dateFormat = @"<HH:mm:ss:SSS>";
	
	NSDate *now = [NSDate date];
	return [formater stringFromDate:now];
}

+ (void)logString:(NSString *)log withHeader:(BOOL)withHeader
{
	NSString *finalOutput;
	
	if (withHeader)
	{
		finalOutput = [NSString stringWithFormat:@"* %@ %@ -> %@\n", [MOBLogManager currentTime], [MOBLogManager shared].appName, log];
	}
	else
	{
		finalOutput = [NSString stringWithFormat:@"%@\n", log];
	}
	
	@try
	{
		[[NSFileHandle fileHandleWithStandardOutput] writeData: [finalOutput dataUsingEncoding: NSUTF8StringEncoding]];
	}
	@catch (NSException *exception)
	{
		MOBLog(@"%@", finalOutput);
	}
}

#pragma mark - MOBConsole Delegate

- (void)mobConsoleDidEnterCommand:(NSString *)command
{
	if ([command isEqualToString:@"version"])
	{
		[MOBConsole info:@"%@ version %@", self.appName, [NSBundle version]];
	}
	else
	{
		[MOBConsole error:@"Unrecognised command, try 'version' instead..."];
	}
}

@end
