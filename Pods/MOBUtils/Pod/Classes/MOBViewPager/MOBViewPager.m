//
//  MOBViewPager.m
//  ViewPager
//
//  Created by Alex Ruperez on 20/05/14.
//  Copyright (c) 2014 Mobusi Mobile Services. All rights reserved.
//

#import "MOBViewPager.h"


@interface MOBViewPager()
<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *scrollContentView;

@property (assign, nonatomic) NSUInteger numberOfElements;
@property (strong, nonatomic) NSArray *views;

@end


@implementation MOBViewPager

#pragma mark - Init

- (instancetype)initWithDatasource:(id<MOBViewPagerDatasource>)datasource
{
    self = [super init];
    if (self)
    {
        _datasource = datasource;
        
        [self initialize];
    }
    
    return self;
}

#pragma mark - Custom Accessors

- (void)setDatasource:(id<MOBViewPagerDatasource>)datasource
{
    _datasource = datasource;
    
    [self initialize];
}

#pragma mark - Private Methods

- (void)initialize
{
    [self initializeScrollView];
    [self initializeSegmentedControl];
    [self initializeViews];
}

- (void)initializeScrollView
{
    self.scrollView = [[UIScrollView alloc] init];

    self.scrollView.delegate = self;
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.numberOfElements = [self.datasource numberOfElements];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    
    [self addSubview:self.scrollView];
    
    [self addScrollViewConstraints:self.scrollView];
}

- (void)initializeSegmentedControl
{
    NSArray *items = [self.datasource arrayOfSegmentsTitles];
    
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:items];
    self.segmentedControl.translatesAutoresizingMaskIntoConstraints = NO;
    [self.segmentedControl setSelectedSegmentIndex:0];
    [self.segmentedControl addTarget:self action:@selector(updateScrollView:) forControlEvents:UIControlEventValueChanged];
    
    [self addSubview:self.segmentedControl];
    
    [self addSegmentedControlConstraints:self.segmentedControl];
}

- (void)initializeViews
{
    NSMutableArray *mutableViews = [NSMutableArray array];

    for (NSInteger i = 0; i < self.numberOfElements; i++)
    {
        UIView *view = [self.datasource viewForIndex:i];
        view.translatesAutoresizingMaskIntoConstraints = NO;
        
        [mutableViews addObject:view];
        [self.scrollView addSubview:view];
        
        UIView *previousView = nil;
        if (i > 0)
        {
            previousView = mutableViews[i - 1];
        }
        
        BOOL isLastElement = [mutableViews indexOfObject:view] == self.numberOfElements - 1;
        [self addViewConstraints:view previousView:previousView isLastElement:isLastElement];
    }
    
    self.views = mutableViews;
}

#pragma mark - Constraints Management

- (void)addScrollViewConstraints:(UIScrollView *)scrollView
{
    NSMutableArray *constraints = [NSMutableArray array];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(scrollView)]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scrollView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(scrollView)]];
    
    [scrollView.superview addConstraints:constraints];
}

- (void)addSegmentedControlConstraints:(UISegmentedControl *)segmentedControl
{
    NSMutableArray *constraints = [NSMutableArray array];

    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[segmentedControl]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(segmentedControl)]];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:segmentedControl attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    [segmentedControl.superview addConstraints:constraints];
}

- (void)addViewConstraints:(UIView *)view previousView:(UIView *)previousView isLastElement:(BOOL)isLastElement
{
    [view addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:CGRectGetWidth(self.bounds)]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:CGRectGetHeight(self.bounds)]];
    [view.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics: 0 views:NSDictionaryOfVariableBindings(view)]];
    
    if (!previousView)
    {
        [view.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]" options:0 metrics: 0 views:NSDictionaryOfVariableBindings(view)]];
    }
    else if (isLastElement)
    {
        [view.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[previousView][view]|" options:0 metrics: 0 views:NSDictionaryOfVariableBindings(view, previousView)]];
    }
    else
    {
        [view.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[previousView][view]" options:0 metrics: 0 views:NSDictionaryOfVariableBindings(view, previousView)]];
    }
}

#pragma mark - DELEGATES

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	CGFloat pageWidth = scrollView.frame.size.width;
	NSInteger page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    [self.segmentedControl setSelectedSegmentIndex:page];
}

- (void)updateScrollView:(UISegmentedControl *)segmentedControl
{
    CGFloat pageWidth = self.scrollView.frame.size.width;
    NSInteger page = [segmentedControl selectedSegmentIndex];
    
    [self.scrollView setContentOffset:CGPointMake(pageWidth * page, 0.0f) animated:YES];
}

@end
