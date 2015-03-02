//
//  MOBImageDownload.h
//  images
//
//  Created by Alex Ruperez on 28/06/14.
//  Copyright (c) 2014 Mobusi. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MOBImagesManagerDelegate;


typedef void(^MOBImagesManagerDelegate)(id<MOBImagesManagerDelegate>delegate);


@interface MOBImageDownload : NSObject

@property (strong, nonatomic) NSURL *URL;
@property (strong, nonatomic) NSString *imageName;
@property (assign, nonatomic, readonly) NSUInteger delegatesCount;
@property (assign, nonatomic) BOOL downloading;
@property (strong, nonatomic) UIImage *image;

- (instancetype)initWithImageName:(NSString *)imageName andURL:(NSURL *)URL;

- (void)addDelegate:(id<MOBImagesManagerDelegate>)delegate;
- (BOOL)hasDelegate:(id<MOBImagesManagerDelegate>)delegate;
- (void)removeDelegate:(id<MOBImagesManagerDelegate>)delegate;

- (void)enumerateDelegates:(MOBImagesManagerDelegate)block;

@end
