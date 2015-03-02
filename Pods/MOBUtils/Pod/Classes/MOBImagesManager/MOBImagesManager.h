//
//  MOBImagesManager.h
//  images
//
//  Created by Alex Ruperez on 28/06/14.
//  Copyright (c) 2014 Mobusi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MOBURLNameGenerator.h"

@class MOBImageStore;
@class MOBImageDownloader;


@class MOBImagesManager;
@protocol MOBImagesManagerDelegate <NSObject>

- (void)imagesManager:(MOBImagesManager *)imagesManager didDownloadImage:(UIImage *)image withURL:(NSURL *)URL;

@optional
- (void)imagesManager:(MOBImagesManager *)imagesManager didFailDownloadImageWithURL:(NSURL *)URL;

@end


@interface MOBImagesManager : NSObject

@property (strong, nonatomic, readonly) NSArray *activeDownloads;
@property (assign, nonatomic) BOOL verbose;

+ (instancetype)sharedManager;

- (instancetype)initWithRootPath:(NSString *)rootPath;
- (instancetype)initWithNameGenerator:(MOBURLNameGenerator *)nameGenerator;
- (instancetype)initWithNameGenerator:(MOBURLNameGenerator *)nameGenerator rootPath:(NSString *)rootPath;
- (instancetype)initWithNameGenerator:(MOBURLNameGenerator *)nameGenerator
                           imageStore:(MOBImageStore *)imageStore
                      imageDownloader:(MOBImageDownloader *)imageDownloader;

- (void)downloadImageURL:(NSURL *)URL delegate:(id<MOBImagesManagerDelegate>)delegate;
- (void)downloadImageURL:(NSURL *)URL;
- (void)downloadImageURLs:(NSArray *)URLs;

- (UIImage *)cachedImageWithURL:(NSURL *)URL;

- (void)removeImageWithURL:(NSURL *)URL;
- (void)removeAllImages;

- (void)clearCache;

@end
