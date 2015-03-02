//
//  MOBIconSegmentedControl.m
//  MOBSortableSegmenteControl
//
//  Created by Alex Ruperez on 03/06/14.
//  Copyright (c) 2014 Mobusi. All rights reserved.
//

#import "MOBIconSegmentedControl.h"

#import "MOBRightIconButton.h"


#define INTRINSEC_CONTENT_SIZE CGSizeMake(300.f, 40.f)


@interface MOBIconSegmentedControl ()

@property (strong, nonatomic) NSArray *titles;
@property (strong, nonatomic) NSArray *buttons;
@property (strong, nonatomic) UIColor *selectedTextColor;
@property (strong, nonatomic) UIColor *color;

@end


@implementation MOBIconSegmentedControl

#pragma mark - Init

- (instancetype)initWithTitles:(NSArray *)titles
{
    return [self initWithTitles:titles andFont:nil];
}

- (instancetype)initWithTitles:(NSArray *)titles andFont:(UIFont *)font
{
    self = [super init];
    if (self)
    {
        _titles = titles;
        _font = font;
        
        [self initialize];
    }
    return self;
}

#pragma mark - Overriden Methods

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self placeElements];
}

- (CGSize)intrinsicContentSize
{
    return [self controlSizeWithFrame:self.bounds];
}

#pragma mark - Actions

- (void)buttonTapped:(UIButton *)button
{
    NSUInteger buttonIndex = [self.buttons indexOfObject:button];
 
    //unselect all buttons
    [self unselectButtons];
    
    //select the current button
    [button setSelected:YES];
    
    if (self.segmentedControlBlock)
    {
        self.segmentedControlBlock(buttonIndex);
    }
}

#pragma mark - Public Methods

- (void)setTitles:(NSArray *)titles
{
    _titles = titles;
    
    //reload everything again and place
    for (__strong UIView *view in self.subviews)
    {
        [view removeFromSuperview];
        view = nil;
    }
    
    [self initialize];
}

- (void)setImage:(UIImage *)image forItemAtIndex:(NSUInteger)index
{
    UIButton *button = self.buttons[index];
    
    [button setImage:[self newImageFromMaskImage:image inColor:self.selectedTextColor] forState:UIControlStateSelected];
    [button setImage:[self newImageFromMaskImage:image inColor:self.color] forState:UIControlStateNormal];
}

- (void)setSelectedSegmentTextColor:(UIColor *)color
{
    self.selectedTextColor = color;
    for (UIButton *button in self.buttons)
    {
        [button setTitleColor:self.selectedTextColor forState:UIControlStateSelected];
        [self reloadImageColorOfButton:button];
    }
}

- (void)setColor:(UIColor *)color
{
    _color = color;
    
    for (UIButton *button in self.buttons)
    {
        button.tintColor = color;
        [button setTitleColor:color forState:UIControlStateNormal];
        [self reloadImageColorOfButton:button];
    }
}

- (BOOL)selectedSegmentAtIndex:(NSUInteger)index
{
    return [((UIButton *)self.buttons[index]) isSelected];
}

- (void)reloadImageColorOfButton:(UIButton *)button
{
    [button setImage:[self newImageFromMaskImage:[button imageForState:UIControlStateSelected] inColor:self.selectedTextColor] forState:UIControlStateSelected];
    [button setImage:[self newImageFromMaskImage:[button imageForState:UIControlStateNormal] inColor:self.color] forState:UIControlStateNormal];
}

#pragma mark - Private Methods

- (CGSize)controlSizeWithFrame:(CGRect)frame
{
    CGSize intrinsecContentSize = INTRINSEC_CONTENT_SIZE;
    
    if (CGRectGetWidth(frame) > intrinsecContentSize.width)
    {
        intrinsecContentSize.width = CGRectGetWidth(frame);
    }
    
    if (CGRectGetHeight(frame) > intrinsecContentSize.height)
    {
        intrinsecContentSize.height = CGRectGetHeight(frame);
    }
    
    return intrinsecContentSize;
}

- (void)initialize
{
    [self addButtons];
    
    [self setupButtonsBackgrounds];
    
    [self placeElements];
}

- (void)addButtons
{
    NSMutableArray *buttonsMutableArray = [NSMutableArray array];
    for (NSUInteger index = 0; index < self.titles.count; index++)
    {
        UIButton *button = [MOBRightIconButton buttonWithType:UIButtonTypeCustom];
        button.tintColor = [UIColor whiteColor];
        [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor clearColor];
        button.adjustsImageWhenHighlighted = NO;
        [button setTitle:self.titles[index] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.selected = index==0;
        if (self.font)
        {
            button.titleLabel.font = self.font;
        }
        //place better the button arrow image
        UIEdgeInsets buttonInsets = button.imageEdgeInsets;
        buttonInsets.right = buttonInsets.right + 10;
        button.imageEdgeInsets = buttonInsets;
        
        [buttonsMutableArray addObject:button];
        [self addSubview:button];
    }
    
    self.buttons = [NSArray arrayWithArray:buttonsMutableArray];
}

- (void)setupButtonsBackgrounds
{
    UIImage *leftEmtpy = [[UIImage imageNamed:@"segmented_control_left_empty"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIImage *leftFilled = [[UIImage imageNamed:@"segmented_control_left_filled"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIImage *rightEmtpy = [[UIImage imageNamed:@"segmented_control_right_empty"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIImage *rightFilled = [[UIImage imageNamed:@"segmented_control_right_filled"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIImage *centerEmtpy = [[UIImage imageNamed:@"segmented_control_center_empty"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIImage *centerFilled = [[UIImage imageNamed:@"segmented_control_center_filled"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    for (UIButton *button in self.buttons)
    {
        NSUInteger buttonIndex = [self.buttons indexOfObject:button];
        BOOL lastItem = buttonIndex==self.buttons.count - 1;
        
        if (buttonIndex == 0)
        {
            [button setBackgroundImage:leftEmtpy forState:UIControlStateNormal];
            [button setBackgroundImage:leftFilled forState:UIControlStateSelected];
        }
        else if (lastItem)
        {
            [button setBackgroundImage:rightEmtpy forState:UIControlStateNormal];
            [button setBackgroundImage:rightFilled forState:UIControlStateSelected];
        }
        else
        {
            [button setBackgroundImage:centerEmtpy forState:UIControlStateNormal];
            [button setBackgroundImage:centerFilled forState:UIControlStateSelected];
        }
    }
}

- (void)placeElements
{
    if (self.buttons.count > 0)
    {
        CGFloat buttonWidth = CGRectGetWidth(self.bounds) / self.buttons.count;
        CGRect buttonFrame = CGRectZero;
        
        //same size for all buttons
        buttonFrame.size.width = buttonWidth;
        buttonFrame.size.height = CGRectGetHeight(self.bounds);
        
        for (UIView *view in self.buttons)
        {
            NSUInteger buttonIndex = [self.buttons indexOfObject:view];
            UIView *previousView = nil;
            if (buttonIndex > 0)
            {
                previousView = self.buttons[buttonIndex - 1];
            }
            
            if (previousView)
            {
                buttonFrame.origin.x = CGRectGetMaxX(previousView.frame);
            }
            
            view.frame = buttonFrame;
        }
    }
}

- (void)unselectButtons
{
    for (UIButton *button in self.buttons)
    {
        button.selected = NO;
    }
}

#pragma mark - Helpers

- (UIImage *)newImageFromMaskImage:(UIImage *)mask inColor:(UIColor *)color
{
    if (!mask) return nil;
    if (!color) return mask;
    
    UIImage *image = mask;
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, image.scale);
    CGContextRef c = UIGraphicsGetCurrentContext();
    [image drawInRect:rect];
    CGContextSetFillColorWithColor(c, [color CGColor]);
    CGContextSetBlendMode(c, kCGBlendModeSourceAtop);
    CGContextFillRect(c, rect);
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

@end
