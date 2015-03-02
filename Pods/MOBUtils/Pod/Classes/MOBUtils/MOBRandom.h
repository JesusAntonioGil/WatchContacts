//
//  MOBRandom.h
//  MOBUtils
//
//  Created by Alex Ruperez on 08/05/14.
//  Copyright (c) 2014 Mobusi. All rights reserved.
//

#ifndef MOBUtils_MOBRandom_h
#define MOBUtils_MOBRandom_h

#import <Foundation/Foundation.h>
#import <stdlib.h>

#define ARC4RANDOM_MAX 0x100000000

static int const MOBASCIIFirstPrintableCharacter = 0x20;
static int const MOBASCIILastPrintableCharacter = 0x7E;
static int const MOBASCIIFirstDigitCharacter = 0x30;
static int const MOBASCIILastDigitCharacter = 0x39;


__unused static BOOL mob_random_bool()
{
    return (arc4random_uniform(2) > 0);
}

__unused static float mob_random_float(float min, float max)
{
    return ((float)arc4random() / ARC4RANDOM_MAX) * (max - min) + min;
}

__unused static int mob_random_int(int min, int max)
{
    return (arc4random() % (max - min + 1)) + min;
}

__unused static NSString* mob_random_string(int length)
{
    NSMutableString *string = [[NSMutableString alloc] init];
    
    for (int i = 0; i < length; i++)
    {
        char character = mob_random_int(MOBASCIIFirstPrintableCharacter,MOBASCIILastPrintableCharacter);
        [string appendFormat:@"%c", character];
    }
    
    return [string copy];
}

__unused static NSString* mob_random_number_string(int length)
{
    NSMutableString *string = [[NSMutableString alloc] init];
    
    for (int i = 0; i < length; i++)
    {
        char character = mob_random_int(MOBASCIIFirstDigitCharacter,MOBASCIILastDigitCharacter);
        [string appendFormat:@"%c", character];
    }
    
    return [string copy];
}

#endif
