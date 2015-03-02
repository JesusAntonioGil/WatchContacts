//
//  NonSelectableUITextView.m
//  MOBUtils
//
//  Created by Alex Ruperez on 04/11/13.
//
//

#import "NonSelectableUITextView.h"

@implementation NonSelectableUITextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
    
- (BOOL)canBecomeFirstResponder {
    return NO;
}

@end
