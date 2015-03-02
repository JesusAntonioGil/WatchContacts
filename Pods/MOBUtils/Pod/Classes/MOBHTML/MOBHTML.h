//
//  MOBHTML.h
//  MOBUtils
//
//  Created by Alex Ruperez on 06/06/14.
//  Copyright (c) 2014 Mobusi. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef enum {
    MOBHTMLTypeRegular,
    MOBHTMLTypeBold
} MOBHTMLType;


@interface MOBHTML : NSObject

@property (assign, nonatomic) NSRange range;
@property (assign, nonatomic) MOBHTMLType type;
@property (strong, nonatomic) NSString *tagName;

+ (NSAttributedString *)stringWithAttributedsHTML:(NSString *)htmlText fontRegular:(UIFont *)fontRegular fontBold:(UIFont *)fontBold;

+ (NSString *)stringWithoutHtmlTags:(NSString *)htmlText;

+ (NSArray *)tagsInHtmlText:(NSString *)htmlText;


@end
