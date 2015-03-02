//
//  CALMonthCell.m
//  Calendar
//
//  Created by Alex Ruperez on 13/05/14.
//  Copyright (c) 2014 Mobusi Mobile Services. All rights reserved.
//

#import "MOBCalendarMonthCell.h"

@implementation MOBCalendarMonthCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.userInteractionEnabled = NO;
    
    self.monthTitle.text = @"";
    self.yearTitle.text = @"";
}

#pragma mark - Class Methods

+ (instancetype)cellFromCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath
{
    return [collectionView dequeueReusableCellWithReuseIdentifier:@"MonthCell" forIndexPath:indexPath];
}

+ (CGSize)sizeForItem
{
    return CGSizeMake(45.71428571428571,45);
}

@end
