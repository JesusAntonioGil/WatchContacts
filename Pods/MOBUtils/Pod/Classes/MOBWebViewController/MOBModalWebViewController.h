//
//  MOBModalWebViewController.h
//
//  Created by Alex Ruperez on 13.08.11.
//  Copyright 2011 Home. All rights reserved.
//
//  https://github.com/mobusiapps/MOBWebViewController

#import <UIKit/UIKit.h>

@interface MOBModalWebViewController : UINavigationController

- (instancetype)initWithAddress:(NSString*)urlString;
- (instancetype)initWithURL:(NSURL *)URL;
- (instancetype)initWithURLRequest:(NSURLRequest *)request;

@property (nonatomic, strong) UIColor *barsTintColor;

@end
