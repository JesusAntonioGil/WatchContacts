//
//  CALCalendarCell.h
//  Calendar
//
//  Created by Alex Ruperez on 13/05/14.
//  Copyright (c) 2014 Mobusi Mobile Services. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MOBCalendarDay.h"

#import "MOBCalendarDayButton.h"

@interface MOBCalendarCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *topLine;
//@property (weak, nonatomic) IBOutlet UILabel *dayTitle;
@property (weak, nonatomic) IBOutlet UIImageView *event;

@property (strong, nonatomic) NSString *dayTitle;

@property (weak, nonatomic) IBOutlet UIImageView *dayImage;

@property (weak, nonatomic) IBOutlet MOBCalendarDayButton *dayButton;

- (void)setTitle:(NSString *)title;

+ (instancetype)cellFromCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath;
+ (CGSize)sizeForItem;

@end
