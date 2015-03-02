//
//  CALCalendarCell.m
//  Calendar
//
//  Created by Alex Ruperez on 13/05/14.
//  Copyright (c) 2014 Mobusi Mobile Services. All rights reserved.
//

#import "MOBCalendarCell.h"

@implementation MOBCalendarCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.userInteractionEnabled = NO;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.userInteractionEnabled = NO;
    
    self.dayButton.userInteractionEnabled = NO;
    
    [self.dayButton clean];
    
    self.topLine.hidden = NO;
}

- (void)setSelected:(BOOL)selected
{
    if (self.dayButton.style != CALDayButtonStyleUnavailable)
    {
        [super setSelected:selected];

        self.dayButton.selected = selected;
    }
}

//- (void)setHighlighted:(BOOL)highlighted
//{
//    [super setSelected:highlighted];
//    
//    self.dayButton.highlighted = highlighted;
//}

#pragma mark - Public Methods

- (void)setTitle:(NSString *)title
{
    [self.dayButton setTitle:title forState:UIControlStateNormal];
//    [self.dayButton setTitle:title forState:UIControlStateHighlighted];
//    [self.dayButton setTitle:title forState:UIControlStateSelected];
}

#pragma mark - Class Methods

+ (instancetype)cellFromCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath
{
    return [collectionView dequeueReusableCellWithReuseIdentifier:@"CalendarCell" forIndexPath:indexPath];
}

+ (CGSize)sizeForItem
{
    return CGSizeMake(45.71428571428571,47);
}

@end
