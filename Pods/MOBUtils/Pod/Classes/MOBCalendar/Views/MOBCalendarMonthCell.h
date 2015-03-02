//
//  CALMonthCell.h
//  Calendar
//
//  Created by Alex Ruperez on 13/05/14.
//  Copyright (c) 2014 Mobusi Mobile Services. All rights reserved.
//

#import "MOBCalendarCell.h"


@interface MOBCalendarMonthCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *topLine;
@property (weak, nonatomic) IBOutlet UILabel *monthTitle;
@property (weak, nonatomic) IBOutlet UILabel *yearTitle;

@property (weak, nonatomic) IBOutlet UIImageView *event;

+ (instancetype)cellFromCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath;
+ (CGSize)sizeForItem;

@end
