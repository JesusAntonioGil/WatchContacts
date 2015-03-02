//
//  MOBImagesManager.m
//  images
//
//  Created by Alex Ruperez on 28/06/14.
//  Copyright (c) 2014 Mobusi. All rights reserved.
//

#import "MOBImagesManager.h"

#import "MOBImageDownload.h"
#import "MOBImageStore.h"
#import "MOBImageDownloader.h"
#import "NSFileManager+MOBExtension.h"
#import "MOBLogManager.h"


@interface MOBImagesManager ()
<MOBImageDownloaderDelegate>

@property (strong, nonatomic) MOBURLNameGenerator *nameGenerator;
@property (strong, nonatomic) MOBImageStore *imageStore;
@property (strong, nonatomic) MOBImageDownloader *imageDownloader;

@property (strong, nonatomic) NSMutableDictionary *downloads;

@end


@implementation MOBImagesManager

+ (instancetype)sharedManager
{
    static MOBImagesManager *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MOBImagesManager alloc] init];
    });
    
    return instance;
}

- (instancetype)init
{
    MOBURLNameGenerator *nameGenerator = [[MOBURLNameGenerator alloc] init];
    
    return [self initWithNameGenerator:nameGenerator];
}

- (instancetype)initWithRootPath:(NSString *)rootPath
{
    MOBURLNameGenerator *nameGenerator = [[MOBURLNameGenerator alloc] init];
    
    return [self initWithNameGenerator:nameGenerator rootPath:rootPath];
}

- (instancetype)initWithNameGenerator:(MOBURLNameGenerator *)nameGenerator
{
    NSString *rootPath = [[NSFileManager documentsPath] stringByAppendingPathComponent:@"mob_images"];
    
    return [self initWithNameGenerator:nameGenerator rootPath:rootPath];
}

- (instancetype)initWithNameGenerator:(MOBURLNameGenerator *)nameGenerator rootPath:(NSString *)rootPath
{
    MOBImageStore *imageStore = [[MOBImageStore alloc] initWithRootPath:rootPath];
    MOBImageDownloader *imageDownloader = [[MOBImageDownloader alloc] init];
    
    return [self initWithNameGenerator:nameGenerator imageStore:imageStore imageDownloader:imageDownloader];
}

- (instancetype)initWithNameGenerator:(MOBURLNameGenerator *)nameGenerator
                           imageStore:(MOBImageStore *)imageStore
                      imageDownloader:(MOBImageDownloader *)imageDownloader
{
    self = [super init];
    if (self)
    {
        self.nameGenerator = nameGenerator;
        self.imageStore = imageStore;
        self.imageDownloader = imageDownloader;
        self.imageDownloader.delegate = self;
        
        self.downloads = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#pragma mark - Custom Accessors

- (NSArray *)activeDownloads
{
    return [self.downloads allValues];
}

- (void)setVerbose:(BOOL)verbose
{
    _verbose = verbose;
    
    self.imageDownloader.verbose = verbose;
}

#pragma mark - Public

- (void)downloadImageURL:(NSURL *)URL delegate:(id<MOBImagesManagerDelegate>)delegate
{
    NSString *name = [self.nameGenerator generateNameFromURL:URL];
    if (!name) return;
    
    UIImage *image = [self.imageStore imageWithName:name];
    if (image)
    {
        [delegate imagesManager:self didDownloadImage:image withURL:URL];
    }
    else
    {
        MOBImageDownload *imageDownload = [self imageDownloadWithName:name andURL:URL];
    
        [imageDownload addDelegate:delegate];
        
        [self.imageDownloader download:imageDownload];
    }
}

- (void)downloadImageURL:(NSURL *)URL
{
    if (self.verbose)
    {
        MOBLog(@"IMAGES MANAGER: Download: %@", URL);
    }
    
    NSString *name = [self.nameGenerator generateNameFromURL:URL];
    if (!name) return;
    
    UIImage *image = [self.imageStore imageWithName:name];
    if (!image)
    {
        MOBImageDownload *imageDownload = [self imageDownloadWithName:name andURL:URL];
        [self.imageDownloader download:imageDownload];
    }
}

- (void)downloadImageURLs:(NSArray *)URLs
{
    for (NSURL *URL in URLs)
    {
        [self downloadImageURL:URL];
    }
}

- (UIImage *)cachedImageWithURL:(NSURL *)URL
{
    NSString *name = [self.nameGenerator generateNameFromURL:URL];
    if (!name) return nil;
    
    return [self.imageStore imageWithName:name];
}

- (void)removeImageWithURL:(NSURL *)URL
{
    NSString *name = [self.nameGenerator generateNameFromURL:URL];
    if (!name) return;
    
    [self.imageStore removeImageWithName:name];
}

- (void)removeAllImages
{
    [self.imageStore removeAllImagesOnMemory];
    [self.imageStore removeAllImagesOnDisk];
}

- (void)clearCache
{
    [self.imageStore removeAllImagesOnMemory];
}

#pragma mark - Private

- (MOBImageDownload *)imageDownloadWithName:(NSString *)name andURL:(NSURL *)URL
{
    MOBImageDownload *imageDownload = self.downloads[name];
    
    if (!imageDownload)
    {
        imageDownload = [[MOBImageDownload alloc] initWithImageName:name andURL:URL];
        self.downloads[name] = imageDownload;
    }
    
    return imageDownload;
}

#pragma mark - MOBImageDownloaderDelegate

- (void)imageDownloader:(MOBImageDownloader *)imageDownloader didDownload:(MOBImageDownload *)imageDownload
{
    [self.imageStore storeImage:imageDownload.image name:imageDownload.imageName];
    
    [imageDownload enumerateDelegates:^(id<MOBImagesManagerDelegate> delegate) {
        [delegate imagesManager:self didDownloadImage:imageDownload.image withURL:imageDownload.URL];
    }];
}

- (void)imageDownloader:(MOBImageDownloader *)imageDownloader didFailDownload:(MOBImageDownload *)imageDownload
{
    [imageDownload enumerateDelegates:^(id<MOBImagesManagerDelegate> delegate) {
        if ([delegate respondsToSelector:@selector(imagesManager:didFailDownloadImageWithURL:)])
        {
            [delegate imagesManager:self didFailDownloadImageWithURL:imageDownload.URL];
        }
    }];
}

@end