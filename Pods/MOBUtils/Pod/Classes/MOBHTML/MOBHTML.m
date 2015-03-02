//
//  MOBHTML.m
//  MOBUtils
//
//  Created by Alex Ruperez on 06/06/14.
//  Copyright (c) 2014 Mobusi. All rights reserved.
//

#import "MOBHTML.h"


static NSUInteger const MOBHTMLTagLength = 5;


@interface MOBHTML ()

@end


@implementation MOBHTML

#pragma mark - Class Methods

#pragma mark - Public Methods

+ (NSAttributedString *)stringWithAttributedsHTML:(NSString *)htmlText fontRegular:(UIFont *)fontRegular fontBold:(UIFont *)fontBold
{
    if (htmlText.length == 0) return nil;

    NSString *text = [MOBHTML stringWithoutHtmlTags:htmlText];
    NSArray *tagStrings = [MOBHTML tagsInHtmlText:htmlText];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttribute:NSFontAttributeName value:fontRegular range:NSMakeRange(0, text.length)];
    
    for (MOBHTML *tagString in tagStrings)
    {
        if (tagString.type == MOBHTMLTypeBold)
        {
            [attributedString addAttribute:NSFontAttributeName value:fontBold range:NSMakeRange(tagString.range.location, tagString.range.length)];
        }
    }
    
    return attributedString;
}

+ (NSString *)stringWithoutHtmlTags:(NSString *)htmlText
{
    NSRange range;
    
    while ((range = [htmlText rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
    {
        htmlText = [htmlText stringByReplacingCharactersInRange:range withString:@""];
    }
    
    return htmlText;
}

+ (NSArray *)tagsInHtmlText:(NSString *)htmlText
{
    NSMutableArray *mutableStrings = [NSMutableArray array];
    
    NSRegularExpression *regexTags = [NSRegularExpression regularExpressionWithPattern:@"<([^>]+)>[^<]+</[^>]+>" options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSArray *matchesTags = [regexTags matchesInString:htmlText options:0 range:NSMakeRange(0, htmlText.length)];
    
    for (NSTextCheckingResult *match in matchesTags)
    {
        NSRange range = [match range];
        
        MOBHTML *string = [[MOBHTML alloc] init];
        
        string.tagName = [self tagName:match htmlText:htmlText];
        string.type = [self stringType:string.tagName];
        
        range.length -= [self lenghtTag:string.tagName];
        
        if (mutableStrings.count > 0)
        {
            range.location -= [self locationTags:mutableStrings];
        }
        
        string.range = range;

        [mutableStrings addObject:string];
    }

    return mutableStrings;
}

#pragma mark - Private Methods

+ (NSUInteger)lenghtTag:(NSString *)tag
{
    return (tag.length * 2) + MOBHTMLTagLength;
}

+ (NSUInteger)locationTags:(NSArray *)mutableStrings
{
    NSUInteger countLenghtTags = 0;
    
    for (MOBHTML *string in mutableStrings)
    {
        countLenghtTags += [self lenghtTag:string.tagName];
    }
    
    return countLenghtTags;
}

+ (NSString *)tagName:(NSTextCheckingResult *)match htmlText:(NSString *)htmlText
{
    NSRange range;
    
    range = [match rangeAtIndex:1];
    
    return [htmlText substringWithRange:range];
}

+ (MOBHTMLType)stringType:(NSString *)type
{
    if ([type isEqualToString:@"b"])
    {
        return MOBHTMLTypeBold;
    }
    
    return MOBHTMLTypeRegular;
}

@end
