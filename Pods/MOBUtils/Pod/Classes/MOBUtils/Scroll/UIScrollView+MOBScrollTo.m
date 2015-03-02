//
//  UIScrollView+MOBScrollTo.m
//  utils
//
//  Created by Alex Ruperez on 10/09/2013.
//  Copyright (c) 2013 Mobusi. All rights reserved.
//

#import "UIScrollView+MOBScrollTo.h"


@implementation UIScrollView (MOBScrollTo)

- (void)scrollToTop
{
	CGPoint topOffset = CGPointMake(self.contentOffset.x, 0);
	[self setContentOffset:topOffset animated:YES];
}

- (void)scrollToBottom
{
	CGPoint bottomOffset = CGPointMake(self.contentOffset.x, self.contentSize.height - self.bounds.size.height + self.contentInset.bottom);
	[self setContentOffset:bottomOffset animated:YES];
}

@end
