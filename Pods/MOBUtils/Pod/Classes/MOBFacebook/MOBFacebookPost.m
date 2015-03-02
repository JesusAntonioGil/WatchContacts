//
//  MOBFacebookPost.m
//  facebook
//
//  Created by Alex Ruperez on 10/09/14.
//  Copyright (c) 2014 MOB. All rights reserved.
//

#import "MOBFacebookPost.h"


@implementation MOBFacebookPost

- (NSDictionary *)parameters
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    if (self.picture) params[@"picture"] = self.picture;
    if (self.link) params[@"link"] = self.link;
    if (self.name) params[@"name"] = self.name;
    if (self.summary) params[@"summary"] = self.summary;
    if (self.message) params[@"message"] = self.message;
	
	return [params copy];
}

@end
