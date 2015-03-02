//
//  UIView+MOBSubviewsExtension.m
//  utils
//
//  Created by Alex Ruperez on 26/02/14.
//  Copyright (c) 2014 Mobusi. All rights reserved.
//

#import "UIView+MOBSubviewsExtension.h"


@implementation UIView (MOBSubviewsExtension)

- (void)removeSubviews
{
    for (UIView *subview in self.subviews)
    {
        [subview removeFromSuperview];
    }
}

@end
