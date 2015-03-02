//
//  UIViewController+MOBSideMenu.m
//  SideMenu
//
//  Created by Alex Ruperez on 04/03/14.
//  Copyright (c) 2014 Mobusi. All rights reserved.
//

#import "UIViewController+MOBSideMenu.h"

#import "MOBSideMenu.h"

@implementation UIViewController (MOBSideMenu)

- (void)mob_displayController:(UIViewController *)controller
{
    [self addChildViewController:controller];
    controller.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:controller.view];
    [controller didMoveToParentViewController:self];
}

- (void)mob_hideController:(UIViewController *)controller
{
    [controller willMoveToParentViewController:nil];
    [controller.view removeFromSuperview];
    [controller removeFromParentViewController];
}

- (void)mob_setEmbedView:(UIView *)aView
{
    NSMutableArray *constraints = [NSMutableArray array];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[aView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(aView)]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[aView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(aView)]];
    
    [self.view addConstraints:constraints];
}

- (MOBSideMenu *)sideMenuViewController
{
    UIViewController *iter = self.parentViewController;

    while (iter)
    {
        if ([iter isKindOfClass:[MOBSideMenu class]])
        {
            return (MOBSideMenu *)iter;
        }
        else if (iter.parentViewController && iter.parentViewController != iter)
        {
            iter = iter.parentViewController;
        }
        else
        {
            iter = nil;
        }
    }
    
    return nil;
}

@end
