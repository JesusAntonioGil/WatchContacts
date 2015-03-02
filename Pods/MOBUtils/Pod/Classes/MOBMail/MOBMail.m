//
//  MOBMail.m
//  MOBUtils
//
//  Created by Alex Ruperez on 10/09/14.
//  Copyright (c) 2014 Mobusi. All rights reserved.
//

#import "MOBMail.h"


@interface MOBMail ()
<MFMailComposeViewControllerDelegate>

@property (retain, nonatomic) NSMutableArray *toRecipients;
@property (retain, nonatomic) NSMutableArray *ccRecipients;
@property (retain, nonatomic) NSMutableArray *bccRecipients;

@end

@implementation MOBMail

- (instancetype)init
{
    return [self initWithSubject:nil body:nil recipient:nil];
}

- (instancetype)initWithSubject:(NSString *)subject body:(NSString *)body recipient:(NSString *)recipient
{
    self = [super init];
    if (self)
    {
        self.mailComposeDelegate = self;
        
        [self setSubject:subject];
        [self setBody:body];
        [self addToRecipient:recipient];
    }
    
    return self;
}

#pragma mark - PUBLIC

- (void)addToRecipient:(NSString *)recipient
{
    if (recipient)
    {
        if (self.toRecipients == nil)
        {
            self.toRecipients = [NSMutableArray array];
        }
        
        [self.toRecipients addObject:recipient];
        
        [super setToRecipients:self.toRecipients];
    }
}

- (void)addCcRecipient:(NSString *)recipient
{
    if (recipient)
    {
        if (self.ccRecipients == nil)
        {
            self.ccRecipients = [NSMutableArray array];
        }
        
        [self.ccRecipients addObject:recipient];
        
        [super setCcRecipients:self.ccRecipients];
    }
}

- (void)addBccRecipient:(NSString *)recipient
{
    if (recipient)
    {
        if (self.bccRecipients == nil)
        {
            self.bccRecipients = [NSMutableArray array];
        }
        
        [self.bccRecipients addObject:recipient];
        
        [super setBccRecipients:self.bccRecipients];
    }
}

- (void)addImage:(UIImage *)image filename:(NSString *)filename
{
	if (image && filename)
	{
		NSData *imageData = UIImagePNGRepresentation(image);
		[self addAttachmentData:imageData mimeType:@"image/png" fileName:filename];
	}
}

#pragma mark - Public Override

- (void)setMessageBody:(NSString *)body isHTML:(BOOL)isHTML
{
	_body = body;
	_isHTML = isHTML;
	
	[self updateBody];
}

#pragma mark - Public Accessors

- (void)setBody:(NSString *)body
{
	_body = body;
	
	[self updateBody];
}

- (void)setIsHTML:(BOOL)isHTML
{
	_isHTML = isHTML;
	
	[self updateBody];
}

#pragma mark - Private

- (void)updateBody
{
	[super setMessageBody:self.body isHTML:self.isHTML];
}

#pragma mark - MFMailComposeViewController Delegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
	[controller dismissViewControllerAnimated:YES completion:nil];
	
	switch (result)
	{
		case MFMailComposeResultSent:
		{
            if ([self.delegate respondsToSelector:@selector(mobMailDidSend:)])
            {
                [self.delegate mobMailDidSend:self];
            }
		}
			break;
		case MFMailComposeResultSaved:
		{
            if ([self.delegate respondsToSelector:@selector(mobMailDidSaveDraft:)])
            {
                [self.delegate mobMailDidSaveDraft:self];
            }
		}
			break;
		case MFMailComposeResultCancelled:
		{
            if ([self.delegate respondsToSelector:@selector(mobMailDidCancel:)])
            {
                [self.delegate mobMailDidCancel:self];
            }
		}
			break;
		case MFMailComposeResultFailed:
		{
            if ([self.delegate respondsToSelector:@selector(mobMail:didFailWithError:)])
            {
                [self.delegate mobMail:self didFailWithError:error];
            }
		}
			break;
	}
}

@end
