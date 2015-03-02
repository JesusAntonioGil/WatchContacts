//
//  MOBImageStore.m
//  images
//
//  Created by Alex Ruperez on 28/06/14.
//  Copyright (c) 2014 Mobusi. All rights reserved.
//

#import "MOBImageStore.h"

#import "MOBFileManager.h"

#import "MOBDispatch.h"


@interface MOBImageStore ()

@property (strong, nonatomic) NSString *rootPath;
@property (strong, nonatomic) MOBFileManager *fileManager;
@property (assign, nonatomic) CGFloat screenScale;
@property (strong, nonatomic) NSMutableDictionary *images;

@end


@implementation MOBImageStore

- (instancetype)initWithRootPath:(NSString *)rootPath
{
    MOBFileManager *fileManager = [[MOBFileManager alloc] initWithRootPath:rootPath];
    CGFloat screenScale = [UIScreen mainScreen].scale;
    
    return [self initWithFileManager:fileManager screenScale:screenScale];
}

- (instancetype)initWithFileManager:(MOBFileManager *)fileManager screenScale:(CGFloat)screenScale
{
    self = [super init];
    if (self)
    {
        self.fileManager = fileManager;
        self.screenScale = screenScale;
        self.images = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#pragma mark - Public

- (void)storeImage:(UIImage *)image name:(NSString *)name
{
    self.images[name] = image;
    
    __weak typeof(self) this = self;
    mob_dispatch_background(^{
        NSData *imageData = UIImagePNGRepresentation(image);
        NSString *path = [name stringByAppendingPathExtension:@"png"];
        
        [this.fileManager storeFile:imageData atPath:path];
    });
}

- (UIImage *)imageWithName:(NSString *)name
{
    UIImage *image = self.images[name];
    
    if (!image)
    {
        NSString *path = [name stringByAppendingPathExtension:@"png"];
        
        NSData *imageData = [self.fileManager fileAtPath:path];
        image = [UIImage imageWithData:imageData scale:self.screenScale];
    }
    
    return image;
}

- (BOOL)removeImageWithName:(NSString *)name
{
    [self.images removeObjectForKey:name];
    
    NSString *path = [name stringByAppendingPathExtension:@"png"];
    
    return [self.fileManager removeFileAtPath:path];
}

- (void)removeAllImagesOnMemory
{
    [self.images removeAllObjects];
}

- (void)removeAllImagesOnDisk
{
    [self.fileManager removePath:self.rootPath];
}

@end
