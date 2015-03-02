//
//  MOBCalendar.m
//  Calendar
//
//  Created by Alex Ruperez on 12/05/14.
//  Copyright (c) 2014 Mobusi Mobile Services. All rights reserved.
//

#import "MOBCalendar.h"

#import "MOBCalendarMonth.h"
#import "MOBCalendarDay.h"
#import "MOBCalendarComponents.h"
#import "MOBCalendarCell.h"
#import "MOBCalendarMonthCell.h"


static NSInteger const weekConstant = 7;
static NSInteger const dayConstant = 7;


@interface MOBCalendar()
<UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) NSArray *months;
@property (strong, nonatomic) NSDate *date;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end


@implementation MOBCalendar

#pragma mark - Init

- (instancetype)initWithDelegate:(id<MOBCalendarDelegate>)delegate
{
    self = [self init];
    if (self)
    {
        self.delegate = delegate;
    }
    return self;
}

- (instancetype)init
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"MOBCalendar" owner:nil options:nil] firstObject];
    if (self)
    {
        [self initialize];
    }
    return self;
}

#pragma mark - Custom Accessors

- (void)setDays:(NSArray *)availableDays
{
    _days = availableDays;
    
    [self setMonths:self.currentMonth year:self.year numberOfMonths:self.numberOfMonths];
}

#pragma mark - Private Methods

- (void)initialize
{
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MOBCalendarMonthCell class]) bundle:nil] forCellWithReuseIdentifier:@"MonthCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MOBCalendarCell class]) bundle:nil] forCellWithReuseIdentifier:@"CalendarCell"];
}

- (void)setCurrentMonth:(NSInteger)currentMonth year:(NSInteger)year numberOfMonths:(NSInteger)numberOfMonths themeColor:(UIColor *)themeColor
{
    self.currentMonth = currentMonth;
    self.numberOfMonths = numberOfMonths;
    self.year = year;
    self.themeColor = themeColor;
}

- (void)setMonths:(NSInteger)currentMonth year:(NSInteger)year numberOfMonths:(NSInteger)numberOfMonths
{
    NSMutableArray *mutableCopy = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < numberOfMonths; i++)
    {
        NSInteger nextMonth = currentMonth+i;
        
        NSInteger nextYear = year;
        
        if (nextMonth > 12)
        {
            nextMonth -= 12;
            nextYear++;
        }
        
        MOBCalendarMonth *month = [[MOBCalendarMonth alloc] initWithMonth:nextMonth year:nextYear availableDays:self.days];
        
        [mutableCopy addObject:month];
    }
    
    self.months = mutableCopy;
}

- (NSArray *)generateMonths:(NSNumber *)currentMonth numberOfMonths:(NSNumber *)numberOfMonths
{
    NSMutableArray *months;
    
    return months;
}

- (NSInteger)week:(NSInteger)indexPosition
{
    return indexPosition % weekConstant;
}

- (NSInteger)dayOfWeek:(NSInteger)indexPosition
{
    if (indexPosition < dayConstant)
    {
        return 1;
    }
    else if (indexPosition < dayConstant*2)
    {
        return 2;
    }
    else if (indexPosition < dayConstant*3)
    {
        return 3;
    }
    else if (indexPosition < dayConstant*4)
    {
        return 4;
    }
    else if (indexPosition < dayConstant*5)
    {
        return 5;
    }
    else if (indexPosition < dayConstant*6)
    {
        return 6;
    }
    else
    {
        return 7;
    }
}

- (MOBCalendarDay *)day:(NSIndexPath *)indexPath
{
    NSInteger dayOfWeek = [self dayOfWeek:indexPath.row];
    NSInteger week = [self week:indexPath.row];
    
    MOBCalendarMonth *month = [self.months objectAtIndex:indexPath.section];
    
    return [month day:dayOfWeek week:week];
}

- (MOBCalendarDayType)dayType:(NSIndexPath *)indexPath
{
    NSInteger week = [self week:indexPath.row];
    
    if (week == 0)
    {
        return CALDAyTypeMonthTitle;
    }
    else
    {
        MOBCalendarDay *day = [self day:indexPath];
        
        if (day)
        {
            return day.type;
        }
        else
        {
            return CALDayTypeEmpty;
        }
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self.months count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 49;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MOBCalendarDay *day = [self day:indexPath];
    
    /*
     OrdinaryDay, WeekendDay, TodayDay, AvailableDay
     */
    
    MOBCalendarDayType type = [self dayType:indexPath];
    
    if (type == CALDAyTypeMonthTitle)
    {
        MOBCalendarMonthCell *cell = [MOBCalendarMonthCell cellFromCollectionView:collectionView forIndexPath:indexPath];
        
        [self configureMonthCell:cell forItemAtIndexPath:indexPath];
        
        return cell;
    }
    else
    {
        MOBCalendarCell *cell = [MOBCalendarCell cellFromCollectionView:collectionView forIndexPath:indexPath];
        
        [self configureCell:cell forItemAtIndexPath:indexPath day:day];
        
        return cell;
    }
}

- (void)configureCell:(MOBCalendarCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath day:(MOBCalendarDay *)day
{
    if (day)
    {
        if (day.state == CALDayStateAvailable)
        {
            switch (day.type)
            {
                case CALDayTypeToday:
                    [cell.dayButton initWithStyle:CALDayButtonStyleToday themeColor:self.themeColor];
                    break;
                case CALDayTypeOrdinary:
                    [cell.dayButton initWithStyle:CALDayButtonStyleOrdinary themeColor:self.themeColor];
                    break;
                case CALDayTypeWeekend:
                    [cell.dayButton initWithStyle:CALDayButtonStyleWeekend themeColor:self.themeColor];
                    break;
                default:
                    break;
            }
            
            cell.userInteractionEnabled = YES;
            
            if (self.dateSelected && [MOBCalendarComponents compareDay:self.dateSelected secondDate:day.date])
            {
                [cell setSelected:YES];
            }
        }
        else
        {
            if (day.state == CALDayStateUnknown)
            {
                [cell.dayButton initWithStyle:CALDayButtonStyleUnknown themeColor:self.themeColor];
            }
            else
            {
                [cell.dayButton initWithStyle:CALDayButtonStyleUnavailable themeColor:self.themeColor];
            }
            
            cell.userInteractionEnabled = NO;
        }
        
        [cell setTitle:day.dayTitle];
    }
    else
    {
        cell.dayButton.style = CALDayButtonDisabled;
    }
}

- (void)configureMonthCell:(MOBCalendarMonthCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.monthFont)
    {
        cell.monthTitle.font = self.monthFont;
    }
    if (self.yearFont)
    {
        cell.yearTitle.font = self.yearFont;
    }
    cell.monthTitle.textColor = self.themeColor;
    cell.yearTitle.textColor = self.themeColor;
    
    MOBCalendarMonth *month = [self.months objectAtIndex:indexPath.section];
    
    NSInteger dayOfWeek = [self dayOfWeek:indexPath.row];
    
    if ([month firstDayOfMonth] == dayOfWeek)
    {
        cell.monthTitle.text = month.monthTitle;
        cell.yearTitle.text = [NSString stringWithFormat:@"%d", (int)month.year];
    }
    else
    {
//        cell.topLine.hidden = YES;
        cell.monthTitle.text = @"";
        cell.yearTitle.text = @"";
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark - UICollectionViewDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MOBCalendarDayType type = [self dayType:indexPath];
    
    if (type == CALDAyTypeMonthTitle)
    {
        return [MOBCalendarMonthCell sizeForItem];
    }
    else
    {
        return [MOBCalendarCell sizeForItem];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MOBCalendarDay *day = [self day:indexPath];
    
    self.dateSelected = day.date;
    
    [self.delegate calendar:self didSelectDate:day.date];
}

@end
