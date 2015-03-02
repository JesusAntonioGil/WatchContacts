//
//  NSObject+MOBExtension.m
//  utils
//
//  Created by Alex Ruperez on 14/03/14.
//  Copyright (c) 2014 Mobusi. All rights reserved.
//

#import "NSObject+MOBExtension.h"

#import "MOBDebug.h"


@implementation NSObject (MOBExtension)

- (void)performSelectorWithName:(NSString *)selectorName
{
    if (selectorName)
    {
        SEL selector = NSSelectorFromString(selectorName);
        
        if (selector && [self respondsToSelector:selector])
        {
            MOBSuppressPerformSelectorLeakWarning(
              [self performSelector:selector];
            );
        }
    }
}

@end
