//
//  MOBWebViewControllerActivitySafari.m
//
//  Created by Alex Ruperez on 11 Nov, 2013.
//  Copyright 2013 Alex Ruperez. All rights reserved.
//
//  https://github.com/mobusiapps/MOBWebViewController


#import "MOBWebViewControllerActivitySafari.h"

@implementation MOBWebViewControllerActivitySafari

- (NSString *)activityTitle {
	return NSLocalizedStringFromTable(@"Open in Safari", @"MOBWebViewController", nil);
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
	for (id activityItem in activityItems) {
		if ([activityItem isKindOfClass:[NSURL class]] && [[UIApplication sharedApplication] canOpenURL:activityItem]) {
			return YES;
		}
	}
	return NO;
}

- (void)performActivity {
	BOOL completed = [[UIApplication sharedApplication] openURL:self.URLToOpen];
	[self activityDidFinish:completed];
}

@end
