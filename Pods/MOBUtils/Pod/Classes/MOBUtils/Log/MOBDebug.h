//
//  MOBDebug.h
//  utils
//
//  Created by Alex Ruperez on 12/09/2013.
//  Copyright (c) 2013 Mobusi. All rights reserved.
//

#ifndef utils_MOBDebug_h
#define utils_MOBDebug_h

#import "MOBLogManager.h"

#define MOB_OVERRIDE
#define MOB_ABSTRACT
#define MOB_CONVENIENCE

#define MOBThrowException(message) [NSException raise:NSInternalInconsistencyException format:message];
#define MOBThrowAbstractMethodException() [NSException raise:NSInternalInconsistencyException format:@"%s is an abstract method and should be overriden", __PRETTY_FUNCTION__]
#define MOBThrowInitException(selector) [NSException raise:NSInternalInconsistencyException format:@"Use %@ instead of %s", NSStringFromSelector(selector), __PRETTY_FUNCTION__]; return nil

#define MOBSuppressPerformSelectorLeakWarning(code) \
    do { \
        _Pragma("clang diagnostic push") \
        _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
        code; \
        _Pragma("clang diagnostic pop") \
    } while (0)

__unused static void MOBUncaughtExceptionHandler(NSException *exception)
{
	MOBLogException(exception);
}

#endif
