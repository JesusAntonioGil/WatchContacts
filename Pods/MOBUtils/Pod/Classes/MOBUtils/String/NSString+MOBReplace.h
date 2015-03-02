//
//  NSString+MOBReplace.h
//  utils
//
//  Created by Alex Ruperez on 14/01/14.
//  Copyright (c) 2014 Mobusi. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (MOBReplace)

- (NSString *)stringByReplacingCharactersInString:(NSString *)charactersString withString:(NSString *)string;
- (NSArray *)toCharactersArray;

@end
