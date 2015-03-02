//
//  UIScreen+MOBExtension.m
//  utils
//
//  Created by Alex Ruperez on 04/09/2013.
//  Copyright (c) 2013 Mobusi. All rights reserved.
//

#import "UIScreen+MOBExtension.h"


@implementation UIScreen (MOBExtension)

+ (BOOL)isRetina
{
	return [[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2;
}

+ (BOOL)isWidescreen
{
	return ([UIScreen mainScreen].bounds.size.height == 568);
}

@end
