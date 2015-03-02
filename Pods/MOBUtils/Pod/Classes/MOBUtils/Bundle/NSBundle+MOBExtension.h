//
//  NSBundle+MOBExtension.h
//  utils
//
//  Created by Alex Ruperez on 20/11/13.
//  Copyright (c) 2013 Mobusi. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSBundle (MOBExtension)

+ (NSString *)version;
+ (NSString *)build;
+ (NSString *)productName;

- (NSData *)dataFromResource:(NSString *)resource type:(NSString *)type;
- (NSDictionary *)JSONFromResource:(NSString *)resource;

@end
