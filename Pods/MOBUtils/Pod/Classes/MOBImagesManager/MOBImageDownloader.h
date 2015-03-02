//
//  MOBImageDownloader.h
//  images
//
//  Created by Alex Ruperez on 29/06/14.
//  Copyright (c) 2014 Mobusi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MOBImageDownload;


@class MOBImageDownloader;
@protocol MOBImageDownloaderDelegate <NSObject>

- (void)imageDownloader:(MOBImageDownloader *)imageDownloader didDownload:(MOBImageDownload *)imageDownload;
- (void)imageDownloader:(MOBImageDownloader *)imageDownloader didFailDownload:(MOBImageDownload *)imageDownload;

@end


@interface MOBImageDownloader : NSObject

@property (weak, nonatomic) id<MOBImageDownloaderDelegate> delegate;
@property (assign, nonatomic) BOOL verbose;

- (void)download:(MOBImageDownload *)imageDownload;

@end
