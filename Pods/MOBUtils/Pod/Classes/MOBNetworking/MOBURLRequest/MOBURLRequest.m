//
//  MOBURLRequest.m
//  utils
//
//  Created by Alex Ruperez on 12/03/14.
//  Copyright (c) 2014 Mobusi. All rights reserved.
//

#import "MOBURLRequest.h"

#import "NSBundle+MOBExtension.h"
#import "MOBDispatch.h"


static NSString * const MOBRequestErrorDomain = @"com.mobusi.request";


@interface MOBURLRequest ()
<NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (strong, nonatomic) NSURLConnection *connection;
@property (strong, nonatomic) NSMutableURLRequest *request;
@property (strong, nonatomic) NSHTTPURLResponse *response;
@property (strong, nonatomic) NSMutableData *data;
@property (strong, nonatomic) NSError *error;

@property (copy, nonatomic) MOBURLRequestCompletion completion;

@property (strong, nonatomic) NSString *boundary;

@end


@implementation MOBURLRequest

+ (instancetype)GET:(NSString *)url
{
    return [[self alloc] initWithMethod:@"GET" url:url];
}

+ (instancetype)POST:(NSString *)url
{
    return [[self alloc] initWithMethod:@"POST" url:url];
}

+ (instancetype)PUT:(NSString *)url
{
    return [[self alloc] initWithMethod:@"PUT" url:url];
}

+ (instancetype)DELETE:(NSString *)url
{
    return [[self alloc] initWithMethod:@"DELETE" url:url];
}

- (instancetype)initWithMethod:(NSString *)method url:(NSString *)url
{
    self = [super init];
    if (self)
    {
        self.method = method;
        self.url = url;
        self.responseClass = [MOBURLResponse class];
        self.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    }
    return self;
}

#pragma mark - Custom Accessors

- (NSDictionary *)responseHeaders
{
    return self.response.allHeaderFields;
}

#pragma mark - Public

- (void)startCompletion:(MOBURLRequestCompletion)completion
{
    if (self.useMock)
    {
        [self mockResponseWithCompletion:completion];
        return;
    }
    
    self.completion = completion;
    self.request = [self buildRequest];
    
    if (self.verbose)
    {
        MOBLogLine();
        [[self class] logRequest:self.request];
        MOBLogLine();
    }
    
    self.connection = [NSURLConnection connectionWithRequest:self.request delegate:self];
    
    [self.connection start];
}

- (void)cancel
{
    [self.connection cancel];
}

#pragma mark - Private

- (void)completeWithData
{
    [self log];
    
    MOBURLResponse *response = [[self.responseClass alloc] initWithData:self.data];
    if (self.completion) self.completion(response);
}

- (void)completeWithError
{
    [self log];
    
    MOBURLResponse *response = [[self.responseClass alloc] initWithError:self.error];
    if (self.completion) self.completion(response);
}

- (BOOL)isSuccess
{
    return (self.response.statusCode >= 200 && self.response.statusCode < 300);
}

#pragma mark - Mocks

- (void)mockResponseWithCompletion:(MOBURLRequestCompletion)completion
{
    if (completion)
    {
        NSData *responseData = [[NSBundle mainBundle] dataFromResource:self.mockFilename type:nil];
        if (self.verbose)
        {
            MOBLogLine();
            MOBLogTitle(@"REQUEST (MOCK)");
            NSString *url = [NSString stringWithFormat:@"URL: %@", self.url];
            MOBLogMessage(url);
            MOBLog(@"Method: %@", self.method);
            MOBLog(@"Params: %@", self.params);
            MOBLogDataAsString(@"Response", responseData);
            MOBLogLine();
        }
        
        __weak typeof(self) this = self;
        mob_dispatch_after_seconds(1.0f, ^{
            MOBURLResponse *response = [[this.responseClass alloc] initWithData:responseData];
            completion(response);
        });
    }
}

#pragma mark - Request Building

- (NSMutableURLRequest *)buildRequest
{
    NSMutableURLRequest *request = nil;
    if (([self.method isEqualToString:@"GET"] || [self.method isEqualToString:@"DELETE"]) && (self.params.count > 0))
    {
        self.url = [NSString stringWithFormat:@"%@?%@", self.url, [self encodeParams]];
    }
    
	request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:self.url]];
    request.HTTPMethod = self.method;
    request.cachePolicy = self.cachePolicy;
    
    for (NSString *header in self.headers)
    {
        [request setValue:self.headers[header] forHTTPHeaderField:header];
    }
    
    if (self.timeout > 0)
    {
        self.request.timeoutInterval = self.timeout;
    }
    
    if ([self.method isEqualToString:@"POST"] || [self.method isEqualToString:@"PUT"])
    {
        if (self.files.count > 0)
        {
            request.HTTPBody = [self buildMultipartBody];
            NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", self.boundary];
            [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
            
            NSString *contentLength = [NSString stringWithFormat:@"%i", (int)request.HTTPBody.length];
            [request addValue:contentLength forHTTPHeaderField:@"Content-Length"];
        }
        else if (self.params.count > 0)
        {
            request.HTTPBody = [[self encodeParams] dataUsingEncoding:NSUTF8StringEncoding];
        }
    }
    
    return request;
}

#pragma mark - Parameters

- (NSData *)buildMultipartBody
{
    self.boundary = [NSString stringWithFormat:@"---------------------------%08X%08X%08X", arc4random(), arc4random(), arc4random()];
    NSMutableData *body = [NSMutableData data];
    
    for (MOBURLFile *file in self.files)
    {
        [body appendData:[self dataForFile:file]];
    }
    
    [self.params enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL __unused *stop) {
        [body appendData:[self dataForParameter:key value:value]];
    }];
    
    [body appendData:[self endBoundary]];
    
    return body;
}

- (NSData *)dataForFile:(MOBURLFile *)file
{
    NSMutableData *data = [[NSMutableData alloc] init];
    
	[data appendData:[self boundaryString]];
	[data appendData:[self contentDispositionForFile:file]];
    [data appendData:[self contentTypeForFile:file]];
    [data appendData:file.data];
    
    return data;
}

- (NSData *)contentDispositionForFile:(MOBURLFile *)file
{
	NSString *result = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", file.parameterName, file.fileName];
	
	return [result dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSData *)contentTypeForFile:(MOBURLFile *)file
{
	return [[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", file.mimeType] dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSData *)dataForParameter:(NSString *)name value:(id)value
{
    NSMutableData *data = [NSMutableData data];
    
	[data appendData:[self boundaryString]];
	[data appendData:[self contentDispositionForParameter:name]];
    [data appendData:[[self parameterValueToString:value] dataUsingEncoding:NSUTF8StringEncoding]];
    
    return data;
}

- (NSData *)contentDispositionForParameter:(NSString *)parameter
{
    return [[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", parameter] dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSData *)boundaryString
{
	return [[NSString stringWithFormat:@"\r\n--%@\r\n", self.boundary] dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSData *)endBoundary
{
	return [[NSString stringWithFormat:@"\r\n--%@--\r\n", self.boundary] dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)encodeParams
{
    NSMutableArray *parts = [[NSMutableArray alloc] init];
    
    [self.params enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL __unused *stop) {
        NSString *encodedValue = [[self parameterValueToString:value] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *encodedKey = [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *part = [NSString stringWithFormat: @"%@=%@", encodedKey, encodedValue];
        [parts addObject:part];
    }];
    
    return [parts componentsJoinedByString:@"&"];
}

- (NSString *)parameterValueToString:(id)value
{
    if ([value isKindOfClass:[NSString class]])
    {
        return value;
    }
    else if ([value isKindOfClass:[NSNumber class]])
    {
        return [NSString stringWithFormat:@"%@", value];
    }
    
    return @"";
}

#pragma mark - Logs

+ (void)logRequest:(NSURLRequest *)request
{
    MOBLogTitle(@"REQUEST");
    NSString *url = [NSString stringWithFormat:@"URL: %@", request.URL];
    MOBLogMessage(url);
    MOBLog(@"Method: %@", request.HTTPMethod);
    MOBLog(@"Headers: %@", request.allHTTPHeaderFields);
    if (request.HTTPBody) MOBLogDataAsString(@"Body (String)", request.HTTPBody);
}

+ (void)logResponse:(NSHTTPURLResponse *)response data:(NSData *)data error:(NSError *)error
{
    MOBLogTitle(@"RESPONSE");
    NSString *url = [NSString stringWithFormat:@"URL: %@", response.URL];
    MOBLogMessage(url);
    MOBLog(@"Status Code: %d", (int)response.statusCode);
    MOBLog(@"Headers: %@", response.allHeaderFields);
    MOBLog(@"Size: %d bytes", (int)data.length);
    if (data) MOBLogDataAsString(@"Data (String)", data);
    if (error) MOBLogNSError(error);
}

- (void)log
{
    if (self.verbose)
    {
        MOBLogLine();
        [[self class] logRequest:self.request];
        [[self class] logResponse:self.response data:self.data error:self.error];
        MOBLogLine();
    }
}

#pragma mark - NSURLConnection Delegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)aResponse
{
	self.response = (NSHTTPURLResponse *)aResponse;
	self.data = [NSMutableData data];
	
	if (![self isSuccess])
	{
		self.error = [NSError errorWithDomain:MOBRequestErrorDomain code:self.response.statusCode userInfo:nil];
        [self completeWithError];
	}
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.error = error;
    [self completeWithError];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)someData
{
	[self.data appendData:someData];
	if (self.downloadProgress)
	{
		float progress = ((float)self.data.length / (float)[self.response expectedContentLength]);
		self.downloadProgress(progress);
	}
}

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
	if (self.uploadProgress)
	{
		float progress = (float)totalBytesWritten / (float)totalBytesExpectedToWrite;
		self.uploadProgress(progress);
	}
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	if ([self isSuccess])
	{
        [self completeWithData];
	}
}

@end
