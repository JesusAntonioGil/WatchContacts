//
//  NSData+MOBEncrypt.h
//  pruebaEncrypt
//
//  Created by Mobilendo on 06/05/13.
//  Copyright (c) 2013 Mobilendo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSData (MOBEncrypt)

- (NSData *)AES256EncryptWithKey:(NSString *)key iv:(const void *) iv;
- (NSData *)AES256DecryptWithKey:(NSString *)key iv:(const void *) iv;

@end
