//
//  MOBFacebookPost.h
//  facebook
//
//  Created by Alex Ruperez on 10/09/14.
//  Copyright (c) 2014 MOB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MOBFacebookPost : NSObject

@property (strong, nonatomic) NSString *picture;
@property (strong, nonatomic) NSString *link;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *summary;
@property (strong, nonatomic) NSString *message;

- (NSDictionary *)parameters;

@end
