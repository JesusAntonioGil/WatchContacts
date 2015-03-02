//
//  MOBAddressBook.m
//  utils
//
//  Created by Alex Ruperez on 18/03/14.
//  Copyright (c) 2014 Mobusi. All rights reserved.
//

#import "MOBAddressBook.h"

#import <AddressBook/AddressBook.h>
#import "MOBDebug.h"


@interface MOBAddressBook ()

@property (assign, nonatomic) ABAddressBookRef addressBookRef;

@end


@implementation MOBAddressBook

+ (void)addressBookCompletion:(MOBAddressBookCompletion)completion
{
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized)
    {
        CFErrorRef errorRef;
        ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, &errorRef);
        
        MOBAddressBook *addressBook = [[self alloc] initWithAddressBookRef:addressBookRef];
        completion(YES, addressBook, nil);
    }
    else if (ABAddressBookGetAuthorizationStatus() != kABAuthorizationStatusNotDetermined)
    {
        completion(NO, nil, nil);
    }
    else
    {
        CFErrorRef errorRef;
        ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, &errorRef);
        
        if (addressBookRef)
        {
            ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef errorRef) {
                NSError *error = CFBridgingRelease(errorRef);
                MOBAddressBook *addressBook = [[self alloc] initWithAddressBookRef:addressBookRef];
                completion(granted, addressBook, error);
            });
        }
        else
        {
            NSError *error = CFBridgingRelease(errorRef);
            completion(NO, nil, error);
        }
    }
}

- (instancetype)init
{
    MOBThrowInitException(NSSelectorFromString(@"+ addressBookCompletion:"));
    
    return nil;
}

- (instancetype)initWithAddressBookRef:(ABAddressBookRef)addressBookRef
{
    self = [super init];
    if (self)
    {
        _addressBookRef = addressBookRef;
    }
    return self;
}

- (void)dealloc
{
    CFRelease(_addressBookRef);
}

#pragma mark - Public

- (NSArray *)allContacts
{
    NSArray *people = (__bridge_transfer NSArray *)ABAddressBookCopyArrayOfAllPeople(_addressBookRef);
    
    NSMutableArray *contacts = [[NSMutableArray alloc] initWithCapacity:people.count];
    for (NSInteger i = 0; i < people.count; i++)
    {
        ABRecordRef abRecord = (__bridge ABRecordRef)people[i];
        MOBABContact *contact = [[MOBABContact alloc] initWithABRecord:abRecord];
        
        if (contact)
        {
            [contacts addObject:contact];
        }
    }
    
    [contacts sortUsingComparator:^NSComparisonResult(MOBABContact *contact1, MOBABContact *contact2) {
        return [contact1.fullName compare:contact2.fullName];
    }];
    
    return contacts;
}
@end
