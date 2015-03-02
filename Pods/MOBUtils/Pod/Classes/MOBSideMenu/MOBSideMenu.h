//
//  MOBSideMenu.h
//  SideMenu
//
//  Created by Alex Ruperez on 04/03/14.
//  Copyright (c) 2014 Mobusi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIViewController+MOBSideMenu.h"


#define IS_IOS7_OR_GREATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

@protocol MOBSideMenuDelegate;


@interface MOBSideMenu : UIViewController<UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIImage *backgroundImage;
@property (nonatomic) NSTimeInterval animationDuration;
@property (nonatomic) CGFloat contentViewScaleValue;
@property (nonatomic) BOOL panGestureEnabled;
@property (nonatomic) BOOL interactivePopGestureRecognizerEnabled;
@property (nonatomic) BOOL panFromEdge;

@property (strong, nonatomic) UIViewController *menuController;
@property (strong, nonatomic) UIViewController *contentController;

@property (weak, nonatomic) id<MOBSideMenuDelegate> delegate;

- (id)initWithContentViewController:(UIViewController *)contentViewController menuViewController:(UIViewController *)menuViewController;
- (void)setContentController:(UIViewController *)contentController animated:(BOOL)animated;

- (BOOL)menuIsOpen;
- (void)openMenu;
- (void)closeMenu;

@end

@protocol MOBSideMenuDelegate <NSObject>

@optional
- (void)sideMenu:(MOBSideMenu *)sideMenu didRecognizePanGesture:(UIPanGestureRecognizer *)recognizer;
- (void)sideMenu:(MOBSideMenu *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController;
- (void)sideMenu:(MOBSideMenu *)sideMenu didShowMenuViewController:(UIViewController *)menuViewController;
- (void)sideMenu:(MOBSideMenu *)sideMenu willHideMenuViewController:(UIViewController *)menuViewController;
- (void)sideMenu:(MOBSideMenu *)sideMenu didHideMenuViewController:(UIViewController *)menuViewController;

@end
