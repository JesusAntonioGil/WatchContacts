//
//  UIView+MOBExtension.m
//  utils
//
//  Created by Alex Ruperez on 02/09/2013.
//  Copyright (c) 2013 Mobusi. All rights reserved.
//

#import "UIView+MOBNibExtension.h"


@implementation UIView (MOBExtension)

+ (id)loadFromNib
{
	return [self loadFromNibWithOwner:nil];
}

+ (id)loadFromNibWithOwner:(id)owner
{
	return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:owner options:nil][0];
}

@end
