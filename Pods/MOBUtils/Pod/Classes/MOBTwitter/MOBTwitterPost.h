//
//  MOBTwitterPost.h
//  twitter
//
//  Created by Alex Ruperez on 15/09/14.
//  Copyright (c) 2014 Mobusi. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MOBTwitterPost : NSObject

@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSURL *URL;

@end
