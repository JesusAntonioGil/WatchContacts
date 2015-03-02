//
//  MOBLocalization.h
//  utils
//
//  Created by Alex Ruperez on 06/09/2013.
//  Copyright (c) 2013 Mobusi. All rights reserved.
//

#ifndef utils_MOBLocalization_h
#define utils_MOBLocalization_h

#import <Foundation/Foundation.h>


#define MOBLocalize(key) NSLocalizedString(key, nil)
#define MOBLocalizeFormat(format, ...) [NSString stringWithFormat:MOBLocalize(format), __VA_ARGS__]
#define MOBLocalizeParams(localizationKey, dictionary) MOBLocalizeParamsFunction(localizationKey, dictionary)


__unused static void MOBShowNonLocalizedStrings(BOOL show)
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (show)
    {
        [defaults setBool:YES forKey:@"NSShowNonLocalizedStrings"];
    }
    else
    {
        [defaults removeObjectForKey:@"NSShowNonLocalizedStrings"];
    }
    [defaults synchronize];
}


__unused static NSString* MOBLocalizeParamsFunction(NSString *localizationKey, NSDictionary *dictionary)
{
    NSMutableString *result = [[NSMutableString alloc] initWithString:MOBLocalize(localizationKey)];
    
    [dictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, __unused BOOL *stop){
        NSString *target = [NSString stringWithFormat:@"{%@}", key];
        NSString *replacement = [NSString stringWithFormat:@"%@", obj];
        [result replaceOccurrencesOfString:target withString:replacement options:kNilOptions range:NSMakeRange(0, result.length)];
    }];
    
    return [result copy];
}


#endif
