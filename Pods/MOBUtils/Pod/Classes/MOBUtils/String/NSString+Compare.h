//
//  NSString+Compare.h
//  ClubAmerica
//
//  Created by Alex Ruperez on 20/08/13.
//  Copyright (c) 2013 Mobusi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Compare)

-(NSComparisonResult)compareNumberStringsDesc:(NSString *)str;

-(NSComparisonResult)compareNumberStringsAsc:(NSString *)str;

@end
