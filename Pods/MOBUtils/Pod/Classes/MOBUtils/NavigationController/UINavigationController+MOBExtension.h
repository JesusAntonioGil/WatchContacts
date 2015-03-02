//
//  UINavigationController+MOBExtension.h
//  MOBUtils
//
//  Created by Alex Ruperez on 01/07/14.
//  Copyright (c) 2014 Mobusi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (MOBExtension)

- (NSArray *)popNumberOfViewControllers:(NSInteger)numberOfViewControllers animated:(BOOL)animated;

@end
