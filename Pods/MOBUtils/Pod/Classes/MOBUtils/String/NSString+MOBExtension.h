//
//  NSString+MOBExtension.h
//  MOBUtils
//
//  Created by Alex Ruperez on 28/05/14.
//  Copyright (c) 2014 Mobusi. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (MOBExtension)

- (NSString *)stringByCapitalizingFirstLetter;
- (NSString *)stringByAddingPrefix:(NSString *)prefix toLength:(NSInteger)length;
- (NSString *)stringByRepeatingTimes:(NSInteger)times;

@end
