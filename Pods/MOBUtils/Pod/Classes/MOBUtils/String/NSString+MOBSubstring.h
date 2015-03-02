//
//  NSString+MOBSubstring.h
//  utils
//
//  Created by Alex Ruperez on 06/09/2013.
//  Copyright (c) 2013 Mobusi. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (MOBSubstring)

- (BOOL)isEmpty;

- (BOOL)contains:(NSString *)substring;
- (BOOL)containsSubtring:(NSString *)substring;
- (BOOL)insensitiveContains:(NSString *)substring;
- (BOOL)insensitiveHasPrefix:(NSString *)prefix;

@end
