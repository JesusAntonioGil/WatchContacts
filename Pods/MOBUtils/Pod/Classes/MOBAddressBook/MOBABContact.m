//
//  MOBABContact.m
//  utils
//
//  Created by Alex Ruperez on 18/03/14.
//  Copyright (c) 2014 Mobusi. All rights reserved.
//

#import "MOBABContact.h"

@implementation MOBABContact

- (instancetype)initWithABRecord:(ABRecordRef)abRecord
{
    self = [super init];
    if (self)
    {
        self.firstName = (__bridge_transfer NSString*)ABRecordCopyValue(abRecord, kABPersonFirstNameProperty);
        self.middleName = (__bridge_transfer NSString *)ABRecordCopyValue(abRecord, kABPersonMiddleNameProperty);
        self.lastName = (__bridge_transfer NSString *)ABRecordCopyValue(abRecord, kABPersonLastNameProperty);
        self.fullName = [self buildFullName];
        self.portrait = [UIImage imageWithData:(__bridge_transfer NSData *)ABPersonCopyImageDataWithFormat(abRecord, kABPersonImageFormatThumbnail)];
        self.phones = [self phonesFromABRecord:abRecord];
        self.emails = [self mailsFromABRecord:abRecord];
    }
    
    return self;
}

#pragma mark - Private

- (NSString *)buildFullName
{
    NSMutableString *fullName = nil;
    
    if (self.firstName.length > 0 || self.middleName.length > 0 || self.lastName.length > 0)
    {
        fullName = [[NSMutableString alloc] init];
        
        if (self.firstName.length > 0) [fullName appendString:self.firstName];
        if ((self.firstName.length > 0) && (self.middleName.length > 0 || self.lastName.length > 0)) [fullName appendString:@" "];
        if (self.middleName) [fullName appendString:self.middleName];
        if (self.middleName.length > 0 && self.lastName.length > 0) [fullName appendString:@" "];
        if (self.lastName.length > 0) [fullName  appendString:self.lastName];
    }
    
    return [fullName copy];
}

- (NSDictionary *)phonesFromABRecord:(ABRecordRef)abRecord
{
    NSDictionary *result = nil;
    
    ABMultiValueRef phoneNumbersRef = ABRecordCopyValue(abRecord, kABPersonPhoneProperty);
    NSInteger numberOfPhones = ABMultiValueGetCount(phoneNumbersRef);
    if (numberOfPhones > 0)
    {
        NSMutableDictionary *phones = [[NSMutableDictionary alloc] initWithCapacity:numberOfPhones];
        for (CFIndex i = 0; i < numberOfPhones; i++)
        {
            CFStringRef phoneLabelRef = ABMultiValueCopyLabelAtIndex(phoneNumbersRef, i);
            NSString *phoneLabel = (__bridge_transfer NSString *)ABAddressBookCopyLocalizedLabel(phoneLabelRef);
            NSString *phoneNumber = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(phoneNumbersRef, i);
            
            phones[phoneNumber] = phoneLabel;
            if (phoneLabelRef) CFRelease(phoneLabelRef);
        }
        
        result = [phones copy];
    }
    
    CFRelease(phoneNumbersRef);
    
    return result;
}

- (NSDictionary *)mailsFromABRecord:(ABRecordRef)abRecord
{
    NSDictionary *result = nil;
    ABMutableMultiValueRef emailsRef = ABRecordCopyValue(abRecord, kABPersonEmailProperty);
    NSInteger numberOfEmails = ABMultiValueGetCount(emailsRef);
    if (numberOfEmails > 0)
    {
        NSMutableDictionary *emails = [[NSMutableDictionary alloc] initWithCapacity:numberOfEmails];
        for (CFIndex i = 0; i < numberOfEmails; i++)
        {
            CFStringRef emailLabelRef = ABMultiValueCopyLabelAtIndex(emailsRef, i);
            NSString *emailLabel = (__bridge_transfer NSString *)ABAddressBookCopyLocalizedLabel(emailLabelRef);
            NSString *email = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(emailsRef, i);
            
            emails[email] = emailLabel;
            if (emailLabelRef) CFRelease(emailLabelRef);
        }
        
        result = [emails copy];
    }
    
    CFRelease(emailsRef);
    
    return result;
}

@end
