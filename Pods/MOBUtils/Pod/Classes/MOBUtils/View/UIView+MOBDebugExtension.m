//
//  UIView+MOBDebug.m
//  utils
//
//  Created by Alex Ruperez on 13/03/14.
//  Copyright (c) 2014 Mobusi. All rights reserved.
//

#import "UIView+MOBDebugExtension.h"

@implementation UIView (MOBDebugExtension)

- (NSString *)subtreeDescription
{
	return [self subtreeDescriptionWithIndent:@""];
}

- (NSString *)subtreeDescriptionWithIndent:(NSString *)indent
{
	NSMutableString * desc = [NSMutableString string];
	[desc appendFormat:@"%@%@\n", indent, [self description]];
	NSString * subindent = [indent stringByAppendingString:@"    "];
	for (UIView * v in [self subviews]) {
		[desc appendFormat:@"%@", [v subtreeDescriptionWithIndent:subindent]];
	}
	return desc;
}

@end
