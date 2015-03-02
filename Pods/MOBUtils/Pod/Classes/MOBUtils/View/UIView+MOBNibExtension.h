//
//  UIView+MOBNibExtension.h
//  utils
//
//  Created by Alex Ruperez on 02/09/2013.
//  Copyright (c) 2013 Mobusi. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIView (MOBNibExtension)

+ (id)loadFromNib;
+ (id)loadFromNibWithOwner:(id)owner;

@end
