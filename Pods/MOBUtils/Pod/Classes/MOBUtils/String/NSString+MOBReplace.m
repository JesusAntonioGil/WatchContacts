//
//  NSString+MOBReplace.m
//  utils
//
//  Created by Alex Ruperez on 14/01/14.
//  Copyright (c) 2014 Mobusi. All rights reserved.
//

#import "NSString+MOBReplace.h"

@implementation NSString (MOBReplace)

- (NSString *)stringByReplacingCharactersInString:(NSString *)charactersString withString:(NSString *)string
{
    NSString *result = [self copy];
    
    NSArray *charactersArray = [charactersString toCharactersArray];
    for (NSString *character in charactersArray)
    {
        result = [result stringByReplacingOccurrencesOfString:character withString:string];
    }
    
    return result;
}

- (NSArray *)toCharactersArray
{
    NSMutableArray *characters = [NSMutableArray array];
    
    for (int i = 0; i < self.length; i++)
    {
        NSString *character = [self substringWithRange:NSMakeRange(i, 1)];
        [characters addObject:character];
    }
    
    return characters;
}

@end
