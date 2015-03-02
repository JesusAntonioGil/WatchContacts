//
//  MOBAFRequest.m
//  utils
//
//  Created by Alex Ruperez on 14/03/14.
//  Copyright (c) 2014 Mobusi. All rights reserved.
//

#import "MOBAFRequest.h"

#import "AFNetworking.h"


@interface MOBAFRequest ()

@property (strong, nonatomic) AFHTTPRequestOperation *operation;

@end


@implementation MOBAFRequest

#pragma mark - Custom Accessors

- (NSDictionary *)responseHeaders
{
    return self.operation.response.allHeaderFields;
}

#pragma mark - Public

- (void)startCompletion:(MOBURLRequestCompletion)completion
{
    if (self.useMock)
    {
        [self mockResponseWithCompletion:completion];
        return;
    }
    
    NSError *error = nil;
    NSMutableURLRequest *request = [self buildRequestError:&error];
    if (!request)
    {
        if (self.verbose) MOBLogNSError(error);
        if (completion)
        {
            MOBURLResponse *response = [[self.responseClass alloc] initWithError:error];
            completion(response);
        }
        return;
    }
    
    __weak typeof(self) this = self;
    self.operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [self.operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, NSData *data) {
        if (this.verbose) [this logOperation:operation];
        if (completion)
        {
            MOBURLResponse *response = [[this.responseClass alloc] initWithData:data];
            completion(response);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (this.verbose) [this logOperation:operation];
        if (completion)
        {
            MOBURLResponse *response = [[this.responseClass alloc] initWithError:error];
            completion(response);
        }
    }];
    
    [self addProgressToOperation];
    
    if (self.verbose)
    {
        MOBLogLine();
        [[self class] logRequest:request];
        MOBLogLine();
    }
    
    [self.operation start];
}

- (void)cancel
{
    [self.operation cancel];
}

#pragma mark - Private

- (NSMutableURLRequest *)buildRequestError:(NSError **)error
{
    NSMutableURLRequest *request = nil;
    AFHTTPRequestSerializer *serializer = [self requestSerializer];
    
    if (self.files.count > 0)
    {
        request = [serializer multipartFormRequestWithMethod:self.method URLString:self.url parameters:self.params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            for (MOBURLFile *file in self.files)
            {
                [formData appendPartWithFileData:file.data name:file.parameterName fileName:file.fileName mimeType:file.mimeType];
            }
        } error:error];
    }
    else
    {
        request = [serializer requestWithMethod:self.method URLString:self.url parameters:self.params error:error];
    }
    
    if (request)
    {
        if (self.timeout > 0) request.timeoutInterval = self.timeout;
        
        request.cachePolicy = self.cachePolicy;
        
        if (self.headers.count > 0)
        {
            for (NSString *header in self.headers)
            {
                [request setValue:self.headers[header] forHTTPHeaderField:header];
            }
        }
    }
    
    return request;
}

- (AFHTTPRequestSerializer *)requestSerializer
{
    switch (self.parameterEncoding) {
        case MOBAFRequestParameterEncodingHTTP:
            return [AFHTTPRequestSerializer serializer];
            break;
        case MOBAFRequestParameterEncodingJSON:
            return [AFJSONRequestSerializer serializer];
            break;
        case MOBAFRequestParameterEncodingPropertyList:
            return [AFPropertyListRequestSerializer serializer];
            break;
    }
}

- (void)addProgressToOperation
{
    if (self.downloadProgress)
    {
        __weak typeof(self) this = self;
        [self.operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
            this.downloadProgress((float)totalBytesRead / (float)totalBytesExpectedToRead);
        }];
    }
    
    if (self.uploadProgress)
    {
        __weak typeof(self) this = self;
        [self.operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            this.uploadProgress((float)totalBytesWritten / (float)totalBytesExpectedToWrite);
        }];
    }
}

- (void)logOperation:(AFHTTPRequestOperation *)operation
{
    MOBLogLine();
    
    [[self class] logRequest:operation.request];
    [[self class] logResponse:operation.response data:operation.responseData error:operation.error];
    
    MOBLogLine();
}

@end
