//
//  NSLocale+currentLanguage.m
//  MOBUtils
//
//  Created by Alex Ruperez on 10/04/14.
//  Copyright (c) 2014 Mobusi. All rights reserved.
//

#import "NSLocale+MOBCurrentLanguageExtension.h"

@implementation NSLocale (MOBCurrentLanguageExtension)

+ (NSString *)currentLanguage
{
    return [self preferredLanguages][0];
}

@end
