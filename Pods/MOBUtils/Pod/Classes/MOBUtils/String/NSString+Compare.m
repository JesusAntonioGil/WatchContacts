//
//  NSString+Compare.m
//  ClubAmerica
//
//  Created by Alex Ruperez on 20/08/13.
//  Copyright (c) 2013 Mobusi. All rights reserved.
//

#import "NSString+Compare.h"

@implementation NSString (Compare)

-(NSComparisonResult)compareNumberStringsDesc:(NSString *)str {
    NSNumber * me = [NSNumber numberWithInt:[self intValue]];
    NSNumber * you = [NSNumber numberWithInt:[str intValue]];
    
    return [you compare:me];
}

-(NSComparisonResult)compareNumberStringsAsc:(NSString *)str {
    NSNumber * me = [NSNumber numberWithInt:[str intValue]];
    NSNumber * you = [NSNumber numberWithInt:[self intValue]];
    
    return [you compare:me];
}

@end
