//
//  MOBURLFile.h
//  utils
//
//  Created by Alex Ruperez on 13/03/14.
//  Copyright (c) 2014 Mobusi. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MOBURLFile : NSObject

@property (strong, nonatomic) NSData *data;
@property (strong, nonatomic) NSString *parameterName;
@property (strong, nonatomic) NSString *fileName;
@property (strong, nonatomic) NSString *mimeType;

@end
