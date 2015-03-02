//
//  MOBSideMenu.m
//  SideMenu
//
//  Created by Alex Ruperez on 04/03/14.
//  Copyright (c) 2014 Mobusi. All rights reserved.
//

#import "MOBSideMenu.h"


@interface MOBSideMenu ()

@property (strong, nonatomic) NSLayoutConstraint *contentControllerLeftConstraint;
@property (strong, nonatomic) NSLayoutConstraint *contentControllerRightConstraint;
@property (strong, nonatomic) NSLayoutConstraint *contentControllerHeightConstraint;
@property (strong, nonatomic) NSLayoutConstraint *contentControllerCenterYConstraint;

@property (strong, nonatomic) NSLayoutConstraint *menuControllerLeftConstraint;
@property (strong, nonatomic) NSLayoutConstraint *menuControllerRightConstraint;
@property (strong, nonatomic) NSLayoutConstraint *menuControllerHeightConstraint;
@property (strong, nonatomic) NSLayoutConstraint *menuControllerCenterYConstraint;
@property (strong, nonatomic) NSLayoutConstraint *contentControllerWidthConstraint;

@property (strong, readwrite, nonatomic) UIImageView *backgroundImageView;

@property (nonatomic, getter = isVisible) BOOL visible;

@property (nonatomic) CGFloat lastX;
@property (nonatomic) CGFloat maxContentLeftMargin;

@end

@implementation MOBSideMenu

#pragma mark - Init And Dealloc

- (id)init
{
    self = [super init];
    if (self)
    {
        [self commonInit];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if (self)
    {
        [self commonInit];
    }
    
    return self;
}

- (id)initWithContentViewController:(UIViewController *)contentViewController menuViewController:(UIViewController *)menuViewController
{
    self = [self init];
    if (self)
    {
        _contentController = contentViewController;
        _menuController = menuViewController;
    }
    
    return self;
}

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addBackgroundImageView];
    
    [self configureMenuControllerView];
    [self configureContentControllerView];
    
    [self configureGestureRecognizer];
}

#pragma mark - Custom Accessors

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    _backgroundImage = backgroundImage;
    
    if (self.backgroundImageView)
    {
        self.backgroundImageView.image = backgroundImage;
    }
}

#pragma mark - Public Methods

- (void)setContentController:(UIViewController *)contentController animated:(BOOL)animated
{
    if ([self.contentController isEqual:contentController])
    {
        return;
    }
    
    if (!animated)
    {
        [self setContentController:contentController];
    }
    else
    {
        contentController.view.alpha = 0;
        contentController.view.transform = CGAffineTransformIdentity;
        contentController.view.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentController.view addSubview:contentController.view];
        
        [self setConstraintsToEmbedView:contentController.view insideView:self.contentController.view];
        
        [UIView animateWithDuration:self.animationDuration animations:^{
        
            contentController.view.alpha = 1;
            
        } completion:^(BOOL finished) {
            
            [contentController.view removeFromSuperview];
            [self setContentController:contentController];
        }];
    }
}

- (void)setContentController:(UIViewController *)contentController
{
    if (!_contentController)
    {
        _contentController = contentController;
        
        [self updateViewConstraints];
        
        return;
    }
    
    CGRect frame = [self.contentController.view frame];
    
    //update transforms
    contentController.view.transform = self.contentController.view.transform;
    
    //replace the content controller
    [self mob_hideController:_contentController];
    _contentController = contentController;
    [self mob_displayController:self.contentController];
    
    //update frames and constraints
    [self.contentController.view setFrame:frame];
    [self setContentControllerConstraints];
    
    [self.contentController updateViewConstraints];
    
    
    [self closeMenu];
}

- (void)setMenuController:(UIViewController *)menuController
{
    if (!_menuController)
    {
        _menuController = menuController;
        
        return;
    }
    
    [self mob_hideController:_menuController];
    _menuController = menuController;
    [self mob_displayController:menuController];
    [self setMenuControllerConstraints];
    
    [self.view bringSubviewToFront:self.contentController.view];
}

- (BOOL)menuIsOpen
{
    return self.visible;
}

- (void)openMenu
{
    [self openMenuWithAnimationDuration:self.animationDuration];
}

- (void)closeMenu
{
    [self closeMenuWithAnimationDuration:self.animationDuration];
}

- (void)openMenuWithAnimationDuration:(NSTimeInterval)animationDuration
{
    [self notifyDelegateWillShowMenu];
    
    [self.view.window endEditing:YES];
    
    CGFloat constant = self.maxContentLeftMargin;
    
    self.contentControllerLeftConstraint.constant = constant;
//    self.contentControllerRightConstraint.constant = constant;
    
    self.menuControllerLeftConstraint.constant = 0;
    self.menuControllerRightConstraint.constant = 0;
    
    [UIView animateWithDuration:self.animationDuration animations:^{
        
        self.contentController.view.transform = CGAffineTransformMakeScale(self.contentViewScaleValue, self.contentViewScaleValue);
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished){
        
        [self notifyDelegateDidShowMenu];
        
        self.visible = YES;
    }];
    
    [self updateStatusBar];
}

- (void)closeMenuWithAnimationDuration:(NSTimeInterval)animationDuration
{
    [self notifyDelegateWillHideMenu];
    
    self.contentControllerLeftConstraint.constant = 0;
//    self.contentControllerRightConstraint.constant = 0;
    
    self.menuControllerLeftConstraint.constant = CGRectGetWidth(self.view.frame);
    self.menuControllerRightConstraint.constant = CGRectGetWidth(self.view.frame);
    
    [UIView animateWithDuration:self.animationDuration animations:^{
        
        self.contentController.view.transform = CGAffineTransformIdentity;
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished){
        
        [self notifyDelegateDidHideMenu];
    }];
    
    self.visible = NO;
    [self updateStatusBar];
}

#pragma mark - PRIVATE METHODS

- (void)commonInit
{
    _animationDuration = 0.2f;
    _contentViewScaleValue = 0.8f;
    
    _panGestureEnabled = YES;
    _interactivePopGestureRecognizerEnabled = YES;
    
    self.maxContentLeftMargin = 200;
}

- (void)addBackgroundImageView
{
    self.backgroundImageView = ({
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        
        imageView.image = self.backgroundImage;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView;
    });
    
    self.backgroundImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.backgroundImageView];
    
    [self mob_setEmbedView:self.backgroundImageView];
}

- (void)configureMenuControllerView
{
    [self mob_displayController:self.menuController];
    
    [self setMenuControllerConstraints];
}

- (void)configureContentControllerView
{
    [self mob_displayController:self.contentController];
    
    [self setContentControllerConstraints];
}

- (void)notifyDelegateDidRecognizePanGesture:(UIPanGestureRecognizer *)recognizer
{
    if ([self.delegate conformsToProtocol:@protocol(MOBSideMenuDelegate)] && [self.delegate respondsToSelector:@selector(sideMenu:didRecognizePanGesture:)])
    {
        [self.delegate sideMenu:self didRecognizePanGesture:recognizer];
    }
}

- (void)notifyDelegateWillShowMenu
{
    if ([self.delegate conformsToProtocol:@protocol(MOBSideMenuDelegate)] && [self.delegate respondsToSelector:@selector(sideMenu:willShowMenuViewController:)])
    {
        [self.delegate sideMenu:self willShowMenuViewController:self.menuController];
    }
}

- (void)notifyDelegateDidShowMenu
{
    if (!self.visible && [self.delegate conformsToProtocol:@protocol(MOBSideMenuDelegate)] && [self.delegate respondsToSelector:@selector(sideMenu:didShowMenuViewController:)])
    {
        [self.delegate sideMenu:self didShowMenuViewController:self.menuController];
    }
}

- (void)notifyDelegateWillHideMenu
{
    if ([self.delegate conformsToProtocol:@protocol(MOBSideMenuDelegate)] && [self.delegate respondsToSelector:@selector(sideMenu:willHideMenuViewController:)])
    {
        [self.delegate sideMenu:self willHideMenuViewController:self.menuController];
    }
}

- (void)notifyDelegateDidHideMenu
{
    if (!self.visible && [self.delegate conformsToProtocol:@protocol(MOBSideMenuDelegate)] && [self.delegate respondsToSelector:@selector(sideMenu:didHideMenuViewController:)])
    {
        [self.delegate sideMenu:self didHideMenuViewController:self.menuController];
    }
}

#pragma mark - Gesture Recognizer Management

- (void)configureGestureRecognizer
{
    if (self.panGestureEnabled)
    {
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onGesturePan:)];
        
        panGestureRecognizer.delegate = self;
        [self.view addGestureRecognizer:panGestureRecognizer];
    }
}

- (void)setMenuStateForXPosition:(CGFloat)xPosition
{
    CGFloat progress = xPosition / self.maxContentLeftMargin;
    
	CGFloat factorScale = progress * (1 - self.contentViewScaleValue);
    
	self.contentController.view.transform = CGAffineTransformMakeScale(1 - factorScale, 1 - factorScale);

    self.contentControllerLeftConstraint.constant = xPosition;
//    self.contentControllerRightConstraint.constant = xPosition;
    
    self.menuControllerLeftConstraint.constant = self.maxContentLeftMargin - xPosition;
    self.menuControllerRightConstraint.constant = self.maxContentLeftMargin - xPosition;
	
	[self.view layoutIfNeeded];
}

- (void)onGesturePan:(UIPanGestureRecognizer *)recognizer
{
    [self notifyDelegateDidRecognizePanGesture:recognizer];
    
    if (!self.panGestureEnabled)
    {
        return;
    }
    
	CGPoint translation = [recognizer translationInView:self.view];
	
	if (recognizer.state == UIGestureRecognizerStateBegan)
	{
        if (!self.visible && [self.delegate conformsToProtocol:@protocol(MOBSideMenuDelegate)] && [self.delegate respondsToSelector:@selector(sideMenu:willShowMenuViewController:)])
        {
            [self.delegate sideMenu:self willShowMenuViewController:self.menuController];
        }
        
		self.lastX = self.contentControllerLeftConstraint.constant;
	}
	else if (recognizer.state == UIGestureRecognizerStateChanged)
	{
		CGFloat newXPosition = self.lastX + translation.x;
		
		// Only right panel
		newXPosition = MAX(0, newXPosition);
		[self setMenuStateForXPosition:MIN(newXPosition, self.maxContentLeftMargin)];
	}
	else if (recognizer.state == UIGestureRecognizerStateEnded)
	{
		CGPoint velocity = [recognizer velocityInView:self.view];
		
		BOOL isGoingToLeft = NO;
		
		if (velocity.x < 0)
		{
			isGoingToLeft = YES;
		}
		else if (velocity.x >= 0)
		{
			isGoingToLeft = NO;
		}
        
		//finish animating
        if (!isGoingToLeft)
        {
            [self openMenuWithAnimationDuration:self.animationDuration/2];
        }
        else
        {
            [self closeMenuWithAnimationDuration:self.animationDuration/2];
        }
        
        [self updateStatusBar];
	}
}

#pragma mark - Status bar appearance management

- (void)updateStatusBar
{
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
    {
        [UIView animateWithDuration:0.3f animations:^{
       
            [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
        }];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    UIStatusBarStyle statusBarStyle = UIStatusBarStyleDefault;
    
    if (IS_IOS7_OR_GREATER)
    {
        if (self.contentController.view.frame.origin.y > 10)
        {
            statusBarStyle = self.menuController.preferredStatusBarStyle;
        }
        else
        {
            statusBarStyle = self.contentController.preferredStatusBarStyle;
        }
    }
    
    return statusBarStyle;
}

- (BOOL)prefersStatusBarHidden
{
    BOOL statusBarHidden = NO;
    
    if (IS_IOS7_OR_GREATER)
    {
        if (self.contentController.view.frame.origin.y > 10)
        {
            statusBarHidden = self.menuController.prefersStatusBarHidden;
        }
        else
        {
            statusBarHidden = self.contentController.prefersStatusBarHidden;
        }
    }
    
    return statusBarHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    UIStatusBarAnimation statusBarAnimation = UIStatusBarAnimationNone;
    
    if (IS_IOS7_OR_GREATER)
    {
        if (self.contentController.view.frame.origin.y > 10)
        {
            statusBarAnimation = self.menuController.preferredStatusBarUpdateAnimation;
        }
        else
        {
            statusBarAnimation = self.contentController.preferredStatusBarUpdateAnimation;
        }
    }
    
    return statusBarAnimation;
}

#pragma mark - Constraints Management

- (void)setConstraintsToEmbedView:(UIView *)aView insideView:(UIView *)view
{
    NSMutableArray *constraints = [NSMutableArray array];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[aView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(aView)]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[aView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(aView)]];
    
    [view addConstraints:constraints];
}

- (void)setEmbedViewControllerConstraint:(UIViewController *)aViewController
{
    UIView *viewControllerView = aViewController.view;
    
    [self setConstraintsToEmbedView:viewControllerView insideView:viewControllerView.superview];
}

- (void)setContentControllerConstraints
{
    UIView *contentControllerView = self.contentController.view;
    UIView *contentSuperview = self.contentController.view.superview;
    
    self.contentControllerLeftConstraint = [NSLayoutConstraint constraintWithItem:contentControllerView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:contentSuperview attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0];
    
    self.contentControllerRightConstraint = [NSLayoutConstraint constraintWithItem:contentControllerView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:contentSuperview attribute:NSLayoutAttributeRight multiplier:1.0f constant:0];
    
    self.contentControllerCenterYConstraint = [NSLayoutConstraint constraintWithItem:contentControllerView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:contentSuperview attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.f];
    
    self.contentControllerHeightConstraint = [NSLayoutConstraint constraintWithItem:contentControllerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0f constant:CGRectGetHeight(contentControllerView.frame)];
    
    self.contentControllerWidthConstraint = [NSLayoutConstraint constraintWithItem:contentControllerView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0f constant:CGRectGetWidth(contentControllerView.frame)];
    
    NSMutableArray *constraintsArray = [NSMutableArray array];
    
    [constraintsArray addObject:self.contentControllerLeftConstraint];
//    [constraintsArray addObject:self.contentControllerRightConstraint];
    [constraintsArray addObject:self.contentControllerCenterYConstraint];
    [constraintsArray addObject:self.contentControllerHeightConstraint];
    [constraintsArray addObject:self.contentControllerWidthConstraint];
    
    [contentControllerView.superview addConstraints:constraintsArray];
}

- (void)setMenuControllerConstraints
{
    UIView *menuControllerView = self.menuController.view;
    UIView *menuSuperview = self.menuController.view.superview;
    
    self.menuControllerLeftConstraint = [NSLayoutConstraint constraintWithItem:menuControllerView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:menuSuperview attribute:NSLayoutAttributeLeft multiplier:1.0f constant:CGRectGetWidth(menuSuperview.frame)];
    
    self.menuControllerRightConstraint = [NSLayoutConstraint constraintWithItem:menuControllerView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:menuSuperview attribute:NSLayoutAttributeRight multiplier:1.0f constant:CGRectGetWidth(menuSuperview.frame) + CGRectGetMaxX(menuControllerView.frame)];
    
    self.menuControllerCenterYConstraint = [NSLayoutConstraint constraintWithItem:menuControllerView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:menuSuperview attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.f];
    
    self.menuControllerHeightConstraint = [NSLayoutConstraint constraintWithItem:menuControllerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0f constant:CGRectGetHeight(menuControllerView.frame)];
    
    NSMutableArray *constraintsArray = [NSMutableArray array];
    
    [constraintsArray addObject:self.menuControllerLeftConstraint];
    [constraintsArray addObject:self.menuControllerRightConstraint];
    [constraintsArray addObject:self.menuControllerCenterYConstraint];
    [constraintsArray addObject:self.menuControllerHeightConstraint];
    
    [menuControllerView.superview addConstraints:constraintsArray];
}

#pragma mark - DELEGATES

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (IS_IOS7_OR_GREATER)
    {
       if (self.interactivePopGestureRecognizerEnabled && [self.contentController isKindOfClass:[UINavigationController class]])
       {
           UINavigationController *navigationController = (UINavigationController *)self.contentController;
           
           if (navigationController.viewControllers.count > 1 && navigationController.interactivePopGestureRecognizer.enabled)
           {
               return NO;
           }
       }
    }
    
    if (self.panFromEdge && [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && !self.visible)
    {
        CGPoint point = [touch locationInView:gestureRecognizer.view];
        
        if (point.x < 30)
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    
    return YES;
}

@end
