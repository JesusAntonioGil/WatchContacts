//
//  MOBImageDownloader.m
//  images
//
//  Created by Alex Ruperez on 29/06/14.
//  Copyright (c) 2014 Mobusi. All rights reserved.
//

#import "MOBImageDownloader.h"

#import "MOBImageDownload.h"
#import "MOBAFRequest.h"


@interface MOBImageDownloader ()

@property (strong, nonatomic) NSMutableArray *requests;

@end


@implementation MOBImageDownloader

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.requests = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark - Public

- (void)download:(MOBImageDownload *)imageDownload
{
    if (!imageDownload.downloading)
    {
        [self startDownload:imageDownload];
    }
}

#pragma mark - Private

- (void)startDownload:(MOBImageDownload *)imageDownload
{
    imageDownload.downloading = YES;
    
    MOBAFRequest *request = [MOBAFRequest GET:[imageDownload.URL absoluteString]];
    request.responseClass = [MOBURLImageResponse class];
    request.verbose = self.verbose;
    
    [self.requests addObject:request];
    
    __weak typeof(self) this = self;
    [request startCompletion:^(MOBURLImageResponse *response) {
        imageDownload.downloading = NO;
        
        if (response.image)
        {
            imageDownload.image = response.image;
            
            [this.delegate imageDownloader:self didDownload:imageDownload];
        }
        else
        {
            [this.delegate imageDownloader:self didFailDownload:imageDownload];
        }
        
        [this.requests removeObject:request];
    }];
}

@end
