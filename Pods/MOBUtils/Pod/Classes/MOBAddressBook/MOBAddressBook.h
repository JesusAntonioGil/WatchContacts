//
//  MOBAddressBook.h
//  utils
//
//  Created by Alex Ruperez on 18/03/14.
//  Copyright (c) 2014 Mobusi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MOBABContact.h"


@class MOBAddressBook;
typedef void(^MOBAddressBookCompletion)(BOOL granted, MOBAddressBook *addressBook, NSError *error);


@interface MOBAddressBook : NSObject

+ (void)addressBookCompletion:(MOBAddressBookCompletion)completion;

- (NSArray *)allContacts;

@end
