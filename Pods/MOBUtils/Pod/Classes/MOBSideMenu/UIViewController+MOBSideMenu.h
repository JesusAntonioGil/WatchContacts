//
//  UIViewController+MOBSideMenu.h
//  SideMenu
//
//  Created by Alex Ruperez on 04/03/14.
//  Copyright (c) 2014 Mobusi. All rights reserved.
//

#import <UIKit/UIKit.h>


@class MOBSideMenu;


@interface UIViewController (MOBSideMenu)

@property (strong, readonly, nonatomic) MOBSideMenu *sideMenuViewController;

- (void)mob_displayController:(UIViewController *)controller;
- (void)mob_hideController:(UIViewController *)controller;
- (void)mob_setEmbedView:(UIView *)aView;

@end
