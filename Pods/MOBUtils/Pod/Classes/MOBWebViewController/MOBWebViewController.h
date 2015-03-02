//
//  MOBWebViewController.h
//
//  Created by Alex Ruperez on 08.11.10.
//  Copyright 2010 Alex Ruperez. All rights reserved.
//
//  https://github.com/mobusiapps/MOBWebViewController

@interface MOBWebViewController : UIViewController

- (instancetype)initWithAddress:(NSString*)urlString;
- (instancetype)initWithURL:(NSURL*)URL;
- (instancetype)initWithURLRequest:(NSURLRequest *)request;

@end
