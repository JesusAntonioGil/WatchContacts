//
//  MOBModalWebViewController.m
//
//  Created by Alex Ruperez on 13.08.11.
//  Copyright 2011 Home. All rights reserved.
//
//  https://github.com/mobusiapps/MOBWebViewController

#import "MOBModalWebViewController.h"
#import "MOBWebViewController.h"

@interface MOBModalWebViewController ()

@property (nonatomic, strong) MOBWebViewController *webViewController;

@end

@interface MOBWebViewController (DoneButton)

- (void)doneButtonTapped:(id)sender;

@end


@implementation MOBModalWebViewController

#pragma mark - Initialization


- (instancetype)initWithAddress:(NSString*)urlString {
    return [self initWithURL:[NSURL URLWithString:urlString]];
}

- (instancetype)initWithURL:(NSURL *)URL {
    return [self initWithURLRequest:[NSURLRequest requestWithURL:URL]];
}

- (instancetype)initWithURLRequest:(NSURLRequest *)request {
    self.webViewController = [[MOBWebViewController alloc] initWithURLRequest:request];
    if (self = [super initWithRootViewController:self.webViewController]) {
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                    target:self.webViewController
                                                                                    action:@selector(doneButtonTapped:)];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            self.webViewController.navigationItem.leftBarButtonItem = doneButton;
        else
            self.webViewController.navigationItem.rightBarButtonItem = doneButton;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    
    self.webViewController.title = self.title;
    self.navigationBar.tintColor = self.barsTintColor;
}

@end
