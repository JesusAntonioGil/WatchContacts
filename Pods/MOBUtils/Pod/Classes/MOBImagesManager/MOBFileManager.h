//
//  MOBFileManager.h
//  images
//
//  Created by Alex Ruperez on 27/06/14.
//  Copyright (c) 2014 Mobusi. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MOBFileManager : NSObject

- (instancetype)initWithRootPath:(NSString *)rootPath;
- (instancetype)initWithFileManager:(NSFileManager *)fileManager rootPath:(NSString *)rootPath;

// paths
- (BOOL)createPath:(NSString *)path;
- (BOOL)existsPath:(NSString *)path;
- (BOOL)removePath:(NSString *)path;

// files
- (BOOL)storeFile:(NSData *)data atPath:(NSString *)path;
- (BOOL)storeFile:(NSData *)data withName:(NSString *)name atPath:(NSString *)path;
- (NSData *)fileAtPath:(NSString *)path;
- (BOOL)removeFileAtPath:(NSString *)path;

@end
