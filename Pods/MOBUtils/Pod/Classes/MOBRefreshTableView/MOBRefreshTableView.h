//
//  MOBRefreshTableView.h
//  MOBUtils
//
//  Created by Alex Ruperez on 07/05/14.
//  Copyright (c) 2014 Mobusi. All rights reserved.
//

#import <UIKit/UIKit.h>


@class MOBRefreshTableView;
@protocol MOBRefreshTableViewDelegate <NSObject>

- (void)tableViewDidRefresh:(MOBRefreshTableView *)tableView;

@end

@protocol MOBScrollInfinityViewDelegate <NSObject>

- (void)tableViewDidRequestNextPage:(MOBRefreshTableView *)tableView;

@end


@interface MOBRefreshTableView : UITableView

// pull to refresh
@property (assign, nonatomic) IBOutlet id<MOBRefreshTableViewDelegate> refreshDelegate;
@property (assign, nonatomic, readonly, getter=isRefreshing) BOOL refreshing;

- (void)addDefaultRefreshControl;
- (void)addCustomRefreshControl:(UIRefreshControl *)refreshControl;
- (void)removeRefreshControl;

- (void)beginRefreshing;
- (void)endRefreshing;

// infinity scroll
@property (weak, nonatomic) IBOutlet id<MOBScrollInfinityViewDelegate> scrollInfinityDelegate;

- (void)addDefaultInfinityScroll;
- (void)addCustomInfinityScroll:(UIView *)infinityScrollView activityIndicator:(UIActivityIndicatorView *)activityIndicator;
- (void)removeInfinityScroll;

- (void)endInfinityScroll;

@end
