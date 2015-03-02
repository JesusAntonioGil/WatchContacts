//
//  NSFileManager+MOBExtension.h
//  utils
//
//  Created by Alex Ruperez on 19/11/13.
//  Copyright (c) 2013 Mobusi. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSFileManager (MOBExtension)

+ (NSString *)documentsPath;

- (BOOL)createDirectoryAtPath:(NSString *)path;

@end
