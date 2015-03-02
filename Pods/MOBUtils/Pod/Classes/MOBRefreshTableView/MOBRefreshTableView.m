//
//  MOBRefreshTableView.m
//  MOBUtils
//
//  Created by Alex Ruperez on 07/05/14.
//  Copyright (c) 2014 Mobusi. All rights reserved.
//

#import "MOBRefreshTableView.h"

#import "UIView+MOBFrameExtension.h"


@interface MOBRefreshTableView ()

@property (strong, nonatomic, readwrite) UIRefreshControl *refreshControl;

@property (strong, nonatomic) UIView *infinityScrollView;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;

@end


@implementation MOBRefreshTableView

#pragma mark - PULL TO REFRESH

#pragma mark - Custom Accessors

- (BOOL)isRefreshing
{
    return self.refreshControl.isRefreshing;
}

#pragma mark - Actions

- (void)refresh
{
    [self.refreshDelegate tableViewDidRefresh:self];
}

#pragma mark - Public

- (void)addDefaultRefreshControl
{
    [self addCustomRefreshControl:[[UIRefreshControl alloc] init]];
}

- (void)addCustomRefreshControl:(UIRefreshControl *)refreshControl
{
    self.refreshControl = refreshControl;
    
    [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    
    [self addSubview:self.refreshControl];
    [self sendSubviewToBack:self.refreshControl];
}

- (void)removeRefreshControl
{
    [self.refreshControl removeFromSuperview];
    self.refreshControl = nil;
}

- (void)beginRefreshing
{
    [self.refreshControl beginRefreshing];
}

- (void)endRefreshing
{
    [self.refreshControl endRefreshing];
}

#pragma mark - INFINITY SCROLL

#pragma mark - Public

- (void)addDefaultInfinityScroll
{
    UIView *infinityScrollView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 60.0f)];
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    spinner.color = [UIColor blackColor];
    spinner.hidesWhenStopped = NO;
    spinner.center = infinityScrollView.center;
    [infinityScrollView addSubview:spinner];
    
    [self addCustomInfinityScroll:infinityScrollView activityIndicator:spinner];
}

- (void)addCustomInfinityScroll:(UIView *)infinityScrollView activityIndicator:(UIActivityIndicatorView *)activityIndicator
{
    self.infinityScrollView = infinityScrollView;
    self.activityIndicator = activityIndicator;
    
    [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeInfinityScroll
{
    [self.infinityScrollView removeFromSuperview];
    self.infinityScrollView = nil;
    self.activityIndicator = nil;
    
    [self removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)endInfinityScroll
{
    [self.infinityScrollView removeFromSuperview];
    [self.activityIndicator stopAnimating];
    
    UIEdgeInsets insets = self.contentInset;
    insets.bottom -= self.infinityScrollView.height;
    self.contentInset = insets;
}

#pragma mark - Private

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"])
    {
        CGPoint contentOffset = [[change valueForKey:NSKeyValueChangeNewKey] CGPointValue];
        CGFloat y = self.contentSize.height - self.bounds.size.height;
        if (y > 0 && contentOffset.y >= y)
        {
            if (self.infinityScrollView.superview == nil)
            {
                self.infinityScrollView.center = self.center;
                self.infinityScrollView.y = self.contentSize.height;
                [self addSubview:self.infinityScrollView];
            }
            
            if (contentOffset.y >= (y + self.infinityScrollView.height) && !self.activityIndicator.isAnimating)
            {
                [self.activityIndicator startAnimating];
                
                UIEdgeInsets insets = self.contentInset;
                insets.bottom += self.infinityScrollView.height;
                self.contentInset = insets;
                
                [self.scrollInfinityDelegate tableViewDidRequestNextPage:self];
            }
        }
    }
}

@end
