//
//  MOBURLRequest.h
//  utils
//
//  Created by Alex Ruperez on 12/03/14.
//  Copyright (c) 2014 Mobusi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MOBURLFile.h"
#import "MOBURLResponse.h"
#import "MOBURLImageResponse.h"
#import "MOBURLJSONResponse.h"


typedef void(^MOBURLRequestCompletion)(id response); // MOBURLResponse or subclass
typedef void(^MOBURLRequestProgress)(float progress); // 0.0 to 1.0


@interface MOBURLRequest : NSObject

@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *method;
@property (strong, nonatomic) NSDictionary *params;
@property (strong, nonatomic) NSDictionary *headers;
@property (strong, nonatomic) NSArray *files; // MOBURLFile instances
@property (assign, nonatomic) NSTimeInterval timeout;
@property (assign, nonatomic) NSURLRequestCachePolicy cachePolicy;
@property (assign, nonatomic) BOOL verbose;
@property (strong, nonatomic) Class responseClass; // MOBURLResponse or subclass

@property (copy, nonatomic) MOBURLRequestProgress downloadProgress;
@property (copy, nonatomic) MOBURLRequestProgress uploadProgress;

@property (assign, nonatomic) BOOL useMock;
@property (strong, nonatomic) NSString *mockFilename;

@property (strong, nonatomic, readonly) NSDictionary *responseHeaders;

+ (instancetype)GET:(NSString *)url;
+ (instancetype)POST:(NSString *)url;
+ (instancetype)PUT:(NSString *)url;
+ (instancetype)DELETE:(NSString *)url;

- (instancetype)initWithMethod:(NSString *)method url:(NSString *)url;

- (void)startCompletion:(MOBURLRequestCompletion)completion;
- (void)cancel;

- (void)mockResponseWithCompletion:(MOBURLRequestCompletion)completion;

+ (void)logRequest:(NSURLRequest *)request;
+ (void)logResponse:(NSHTTPURLResponse *)response data:(NSData *)data error:(NSError *)error;

@end
