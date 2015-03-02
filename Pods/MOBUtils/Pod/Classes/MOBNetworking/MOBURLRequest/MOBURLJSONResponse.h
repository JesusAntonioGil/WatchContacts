//
//  MOBURLJSONResponse.h
//  utils
//
//  Created by Alex Ruperez on 14/03/14.
//  Copyright (c) 2014 Mobusi. All rights reserved.
//

#import "MOBURLResponse.h"


@interface MOBURLJSONResponse : MOBURLResponse

@property (strong, nonatomic) NSDictionary *json;

@end
