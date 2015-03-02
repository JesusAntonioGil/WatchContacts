//
//  MOBViewPager.h
//  ViewPager
//
//  Created by Alex Ruperez on 20/05/14.
//  Copyright (c) 2014 Mobusi Mobile Services. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol MOBViewPagerDatasource <NSObject>

- (NSUInteger)numberOfElements;
- (NSArray *)arrayOfSegmentsTitles;
- (UIView *)viewForIndex:(NSUInteger)index;

@end


@interface MOBViewPager : UIView

@property (weak, nonatomic) id<MOBViewPagerDatasource> datasource;

@property (strong, nonatomic) UISegmentedControl *segmentedControl;

- (instancetype)initWithDatasource:(id<MOBViewPagerDatasource>)datasource;

@end
