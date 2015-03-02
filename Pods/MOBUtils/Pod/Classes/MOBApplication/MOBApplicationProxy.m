//
//  MOBApplicationProxy.m
//  MOBUtils
//
//  Created by alexruperez on 12/1/15.
//
//

#import "MOBApplicationProxy.h"

@interface MOBApplicationProxy ()

@property (strong, nonatomic) id object;

@end

@implementation MOBApplicationProxy

+ (NSString *)privateClassName
{
    return [NSStringFromClass(self) stringByReplacingOccurrencesOfString:@"MOB" withString:@"LS"];
}

+ (Class)applicationProxyClass
{
    return NSClassFromString(self.privateClassName);
}

+ (NSArray *)arrayFromPrivateArray:(NSArray *)array
{
    NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithCapacity:array.count];
    
    for (id object in array)
    {
        [mutableArray addObject:[self.alloc initWithPrivateObject:object]];
    }
    
    return mutableArray;
}

- (id)initWithPrivateObject:(id)object
{
    self = [super init];
    
    if (self)
    {
        self.object = object;
    }
    
    return self;
}

- (id)UIBackgroundModes
{
    return [self.object performSelector:@selector(UIBackgroundModes)];
}

- (id)VPNPlugins
{
    return [self.object performSelector:@selector(VPNPlugins)];
}

- (id)appStoreReceiptURL
{
    return [self.object performSelector:@selector(appStoreReceiptURL)];
}

- (id)appTags
{
    return [self.object performSelector:@selector(appTags)];
}

- (id)applicationDSID
{
    return [self.object performSelector:@selector(applicationDSID)];
}

- (id)applicationIdentifier
{
    return [self.object performSelector:@selector(applicationIdentifier)];
}

- (id)applicationType
{
    return [self.object performSelector:@selector(applicationType)];
}

- (id)audioComponents
{
    return [self.object performSelector:@selector(audioComponents)];
}

- (id)description
{
    return [[self.object performSelector:@selector(description)] stringByReplacingOccurrencesOfString:self.class.privateClassName withString:NSStringFromClass(self.class)];
}

- (id)deviceFamily
{
    return [self.object performSelector:@selector(deviceFamily)];
}

- (id)deviceIdentifierForVendor
{
    return [self.object performSelector:@selector(deviceIdentifierForVendor)];
}

- (id)directionsModes
{
    return [self.object performSelector:@selector(directionsModes)];
}

- (id)dynamicDiskUsage
{
    return [self.object performSelector:@selector(dynamicDiskUsage)];
}

- (void)encodeWithCoder:(id)arg1
{
    [self.object performSelector:@selector(encodeWithCoder:) withObject:arg1];
}

- (id)externalAccessoryProtocols
{
    return [self.object performSelector:@selector(externalAccessoryProtocols)];
}

- (id)groupContainers
{
    return [self.object performSelector:@selector(groupContainers)];
}

- (id)groupIdentifiers
{
    return [self.object performSelector:@selector(groupIdentifiers)];
}

- (id)iconStyleDomain
{
    return [self.object performSelector:@selector(iconStyleDomain)];
}

- (id)installProgress
{
    return [self.object performSelector:@selector(installProgress)];
}

- (id)installProgressSync
{
    return [self.object performSelector:@selector(installProgressSync)];
}

- (id)itemID
{
    return [self.object performSelector:@selector(itemID)];
}

- (id)itemName
{
    return [self.object performSelector:@selector(itemName)];
}

- (id)localizedName
{
    return [self.object performSelector:@selector(localizedName)];
}

- (id)localizedShortName
{
    return [self.object performSelector:@selector(localizedShortName)];
}

- (id)machOUUIDs
{
    return [self.object performSelector:@selector(machOUUIDs)];
}

- (id)minimumSystemVersion
{
    return [self.object performSelector:@selector(minimumSystemVersion)];
}

- (id)plugInKitPlugins
{
    return [self.object performSelector:@selector(plugInKitPlugins)];
}

- (id)privateDocumentIconNames
{
    return [self.object performSelector:@selector(privateDocumentIconNames)];
}

- (id)privateDocumentTypeOwner
{
    return [self.object performSelector:@selector(privateDocumentTypeOwner)];
}

- (id)requiredDeviceCapabilities
{
    return [self.object performSelector:@selector(requiredDeviceCapabilities)];
}

- (id)resourcesDirectoryURL
{
    return [self.object performSelector:@selector(resourcesDirectoryURL)];
}

- (id)roleIdentifier
{
    return [self.object performSelector:@selector(roleIdentifier)];
}

- (id)sdkVersion
{
    return [self.object performSelector:@selector(sdkVersion)];
}

- (void)setPrivateDocumentIconNames:(id)arg1
{
    [self.object performSelector:@selector(setPrivateDocumentIconNames:) withObject:arg1];
}

- (void)setPrivateDocumentTypeOwner:(id)arg1
{
    [self.object performSelector:@selector(setPrivateDocumentTypeOwner:) withObject:arg1];
}

- (id)shortVersionString
{
    return [self.object performSelector:@selector(shortVersionString)];
}

- (id)staticDiskUsage
{
    return [self.object performSelector:@selector(staticDiskUsage)];
}

- (id)storeCohortMetadata
{
    return [self.object performSelector:@selector(storeCohortMetadata)];
}

- (id)storeFront
{
    return [self.object performSelector:@selector(storeFront)];
}

- (id)teamID
{
    return [self.object performSelector:@selector(teamID)];
}

- (id)userActivityStringForAdvertisementData:(id)arg1
{
    return [self.object performSelector:@selector(userActivityStringForAdvertisementData:) withObject:arg1];
}

- (id)vendorName
{
    return [self.object performSelector:@selector(vendorName)];
}


@end
