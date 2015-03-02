//
//  MOBFileManager.m
//  images
//
//  Created by Alex Ruperez on 27/06/14.
//  Copyright (c) 2014 Mobusi. All rights reserved.
//

#import "MOBFileManager.h"

#import "MOBLogManager.h"
#import "NSFileManager+MOBExtension.h"


@interface MOBFileManager ()

@property (strong, nonatomic) NSFileManager *fileManager;
@property (strong, nonatomic) NSString *rootPath;

@end


@implementation MOBFileManager

- (instancetype)init
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *rootPath = [NSFileManager documentsPath];
    
    return [self initWithFileManager:fileManager rootPath:rootPath];
}

- (instancetype)initWithRootPath:(NSString *)rootPath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    return [self initWithFileManager:fileManager rootPath:rootPath];
}

- (instancetype)initWithFileManager:(NSFileManager *)fileManager rootPath:(NSString *)rootPath
{
    self = [super init];
    if (self)
    {
        self.fileManager = fileManager;
        self.rootPath = rootPath;
    }
    return self;
}

#pragma mark - Public (Paths)

- (BOOL)createPath:(NSString *)path
{
    NSString *fullPath = [self generateFullPath:path];
    
    NSError *error = nil;
    BOOL result = [self.fileManager createDirectoryAtPath:fullPath withIntermediateDirectories:YES attributes:nil error:&error];
    
    if (!result)
    {
        MOBLogNSError(error);
    }
    
    return result;
}

- (BOOL)existsPath:(NSString *)path
{
    NSString *fullPath = [self generateFullPath:path];
    
    return [self.fileManager fileExistsAtPath:fullPath];
}

- (BOOL)removePath:(NSString *)path
{
    NSString *fullPath = [self generateFullPath:path];
    
    NSError *error = nil;
    BOOL result = [self.fileManager removeItemAtPath:fullPath error:&error];
    
    if (!result)
    {
        MOBLogNSError(error);
    }
    
    return result;
}

#pragma mark - Public (Files)

- (BOOL)storeFile:(NSData *)data atPath:(NSString *)path
{
    NSString *pathWithoutFile = [path stringByDeletingLastPathComponent];
    [self createPath:pathWithoutFile];
    NSString *fullPath = [self generateFullPath:path];
    
    NSError *error = nil;
    BOOL result = [data writeToFile:fullPath options:NSDataWritingAtomic error:&error];
    if (!result)
    {
        MOBLogNSError(error);
    }
    
    return result;
}

- (BOOL)storeFile:(NSData *)data withName:(NSString *)name atPath:(NSString *)path
{
    NSString *pathWithFilename = [path stringByAppendingPathComponent:name];
    
    return [self storeFile:data atPath:pathWithFilename];
}

- (NSData *)fileAtPath:(NSString *)path
{
    NSString *fullPath = [self generateFullPath:path];
    
    return [self.fileManager contentsAtPath:fullPath];
}

- (BOOL)removeFileAtPath:(NSString *)path
{
    NSString *fullPath = [self generateFullPath:path];
    
    NSError *error = nil;
    BOOL result = [self.fileManager removeItemAtPath:fullPath error:&error];
    
    if (!result)
    {
        MOBLogNSError(error);
    }
    
    return result;
}

#pragma mark - Private

- (NSString *)generateFullPath:(NSString *)path
{
    return [self.rootPath stringByAppendingPathComponent:path];
}

@end
