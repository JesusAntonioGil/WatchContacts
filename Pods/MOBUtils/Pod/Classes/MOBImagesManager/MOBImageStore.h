//
//  MOBImageStore.h
//  images
//
//  Created by Alex Ruperez on 28/06/14.
//  Copyright (c) 2014 Mobusi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MOBFileManager;


extern CGFloat const MOBImagesStoreDefaultQuality;


@interface MOBImageStore : NSObject

- (instancetype)initWithRootPath:(NSString *)rootPath;
- (instancetype)initWithFileManager:(MOBFileManager *)fileManager screenScale:(CGFloat)screenScale;

- (void)storeImage:(UIImage *)image name:(NSString *)name;
- (UIImage *)imageWithName:(NSString *)name;
- (BOOL)removeImageWithName:(NSString *)name;

- (void)removeAllImagesOnMemory;
- (void)removeAllImagesOnDisk;

@end
