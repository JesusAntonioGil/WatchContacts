//
//  MOBABContact.h
//  utils
//
//  Created by Alex Ruperez on 18/03/14.
//  Copyright (c) 2014 Mobusi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AddressBook/AddressBook.h>


@interface MOBABContact : NSObject

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *middleName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *fullName;
@property (strong, nonatomic) UIImage *portrait;
@property (strong, nonatomic) NSDictionary *phones;
@property (strong, nonatomic) NSDictionary *emails;

- (instancetype)initWithABRecord:(ABRecordRef)abRecord;

@end
