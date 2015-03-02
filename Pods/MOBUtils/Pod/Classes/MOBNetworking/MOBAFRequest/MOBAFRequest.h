//
//  MOBAFRequest.h
//  utils
//
//  Created by Alex Ruperez on 14/03/14.
//  Copyright (c) 2014 Mobusi. All rights reserved.
//

#import "MOBURLRequest.h"


typedef NS_ENUM(char, MOBAFRequestParameterEncoding) {
    MOBAFRequestParameterEncodingHTTP,
    MOBAFRequestParameterEncodingJSON,
    MOBAFRequestParameterEncodingPropertyList
};


@interface MOBAFRequest : MOBURLRequest

@property (assign, nonatomic) MOBAFRequestParameterEncoding parameterEncoding;

@end
