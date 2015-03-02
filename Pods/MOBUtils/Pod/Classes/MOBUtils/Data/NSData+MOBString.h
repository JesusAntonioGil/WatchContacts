//
//  NSData+MOBString.h
//  utils
//
//  Created by Alex Ruperez on 10/25/13.
//  Copyright (c) 2013 Mobusi. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSData (MOBString)

- (NSString *)toStringWithEncoding:(NSStringEncoding)encoding;
- (NSString *)toUTF8String;
- (NSString *)toASCIIString;

@end
