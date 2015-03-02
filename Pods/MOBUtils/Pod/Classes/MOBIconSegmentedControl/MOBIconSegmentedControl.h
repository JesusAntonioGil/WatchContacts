//
//  MOBIconSegmentedControl.h
//  MOBSortableSegmenteControl
//
//  Created by Alex Ruperez on 03/06/14.
//  Copyright (c) 2014 Mobusi. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^SegmentedControlBlock)(NSUInteger index);


@interface MOBIconSegmentedControl : UIView

@property (copy, nonatomic) SegmentedControlBlock segmentedControlBlock;
@property (strong, nonatomic) UIFont *font;

- (instancetype)initWithTitles:(NSArray *)titles;
- (instancetype)initWithTitles:(NSArray *)titles andFont:(UIFont *)font;

- (void)setTitles:(NSArray *)titles;
- (void)setImage:(UIImage *)image forItemAtIndex:(NSUInteger)index;
- (void)setSelectedSegmentTextColor:(UIColor *)color;
- (void)setColor:(UIColor *)color;

- (BOOL)selectedSegmentAtIndex:(NSUInteger)index;

@end
