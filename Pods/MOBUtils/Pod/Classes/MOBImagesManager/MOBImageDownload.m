//
//  MOBImageDownload.m
//  images
//
//  Created by Alex Ruperez on 28/06/14.
//  Copyright (c) 2014 Mobusi. All rights reserved.
//

#import "MOBImageDownload.h"


// PRIVATE CLASS
@interface MOBImageDownloadWeakDelegate : NSObject

@property (weak, nonatomic) id<MOBImagesManagerDelegate> delegate;

@end

@implementation MOBImageDownloadWeakDelegate

@end



@interface MOBImageDownload ()

@property (strong, nonatomic) NSMutableArray *delegates;

@end


@implementation MOBImageDownload

- (instancetype)init
{
    return [self initWithImageName:nil andURL:nil];
}

- (instancetype)initWithImageName:(NSString *)imageName andURL:(NSURL *)URL
{
    self = [super init];
    if (self)
    {
        self.imageName = imageName;
        self.URL = URL;
        self.delegates = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark - Custom Accessors

- (NSUInteger)delegatesCount
{
    return self.delegates.count;
}

#pragma mark - Public

- (void)addDelegate:(id<MOBImagesManagerDelegate>)delegate
{
    MOBImageDownloadWeakDelegate *weakDelegate = [[MOBImageDownloadWeakDelegate alloc] init];
    weakDelegate.delegate = delegate;
    
    [self.delegates addObject:weakDelegate];
}

- (void)removeDelegate:(id<MOBImagesManagerDelegate>)delegate
{
    MOBImageDownloadWeakDelegate *result = [self weakDelegateForDelegate:delegate];
    
    if (result)
    {
        [self.delegates removeObject:result];
    }
}

- (BOOL)hasDelegate:(id<MOBImagesManagerDelegate>)delegate
{
    MOBImageDownloadWeakDelegate *weakDelegate = [self weakDelegateForDelegate:delegate];
    
    return (weakDelegate != nil);
}

- (void)enumerateDelegates:(MOBImagesManagerDelegate)block
{
    for (MOBImageDownloadWeakDelegate *weakDelegate in self.delegates)
    {
        if (weakDelegate.delegate)
        {
            block(weakDelegate.delegate);
        }
    }
}

#pragma mark - Private

- (MOBImageDownloadWeakDelegate *)weakDelegateForDelegate:(id<MOBImagesManagerDelegate>)delegate
{
    for (MOBImageDownloadWeakDelegate *weakDelegate in self.delegates)
    {
        if (weakDelegate.delegate == delegate)
        {
            return weakDelegate;
        }
    }
    
    return nil;
}

@end
