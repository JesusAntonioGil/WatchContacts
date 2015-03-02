//
//  MOBApplicationWorkspace.m
//  MOBUtils
//
//  Created by alexruperez on 12/1/15.
//
//

#import "MOBApplicationWorkspace.h"

#import "MOBApplicationProxy.h"

@interface MOBApplicationWorkspace ()

@property (strong, nonatomic) id object;

@end

@implementation MOBApplicationWorkspace

+ (NSString *)privateClassName
{
    return [NSStringFromClass(self) stringByReplacingOccurrencesOfString:@"MOB" withString:@"LS"];
}

+ (Class)applicationWorkspaceClass
{
    return NSClassFromString(self.privateClassName);
}

+ (id)defaultWorkspace
{
    return [self.alloc initWithPrivateObject:[self.applicationWorkspaceClass performSelector:@selector(defaultWorkspace)]];
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

- (id)URLOverrideForURL:(id)arg1
{
    return [self.object performSelector:@selector(URLOverrideForURL:) withObject:arg1];
}

- (void)_LSClearSchemaCaches
{
    [self.object performSelector:@selector(_LSClearSchemaCaches)];
}

- (void)_clearCachedAdvertisingIdentifier
{
    [self.object performSelector:@selector(_clearCachedAdvertisingIdentifier)];
}

- (void)addObserver:(id)arg1
{
    [self.object performSelector:@selector(addObserver:) withObject:arg1];
}

- (NSArray *)allApplications
{
    return [self.object performSelector:@selector(allApplications)];
}

- (NSArray *)allApplicationsIdentifiers
{
    NSArray *allApplications = self.allApplications;
    NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithCapacity:allApplications.count];
    
    for (id object in allApplications)
    {
        MOBApplicationProxy *applicationProxy = [MOBApplicationProxy.alloc initWithPrivateObject:object];
        [mutableArray addObject:applicationProxy.applicationIdentifier];
    }
    
    return mutableArray;
}

- (id)allInstalledApplications
{
    return [self.object performSelector:@selector(allInstalledApplications)];
}

- (id)applicationForOpeningResource:(id)arg1
{
    return [self.object performSelector:@selector(applicationForOpeningResource:) withObject:arg1];
}

- (id)applicationForUserActivityDomainName:(id)arg1
{
    return [self.object performSelector:@selector(applicationForUserActivityDomainName:) withObject:arg1];
}

- (id)applicationForUserActivityType:(id)arg1
{
    return [self.object performSelector:@selector(applicationForUserActivityType:) withObject:arg1];
}

- (id)applicationsAvailableForHandlingURLScheme:(id)arg1
{
    return [self.object performSelector:@selector(applicationsAvailableForHandlingURLScheme:) withObject:arg1];
}

- (id)applicationsAvailableForOpeningDocument:(id)arg1
{
    return [self.object performSelector:@selector(applicationsAvailableForOpeningDocument:) withObject:arg1];
}

- (id)applicationsWithAudioComponents
{
    return [self.object performSelector:@selector(applicationsWithAudioComponents)];
}

- (id)applicationsWithExternalAccessoryProtocols
{
    return [self.object performSelector:@selector(applicationsWithExternalAccessoryProtocols)];
}

- (id)applicationsWithSettingsBundle
{
    return [self.object performSelector:@selector(applicationsWithSettingsBundle)];
}

- (id)applicationsWithUIBackgroundModes
{
    return [self.object performSelector:@selector(applicationsWithUIBackgroundModes)];
}

- (id)applicationsWithVPNPlugins
{
    return [self.object performSelector:@selector(applicationsWithVPNPlugins)];
}

- (void)clearAdvertisingIdentifier
{
    [self.object performSelector:@selector(clearAdvertisingIdentifier)];
}

- (void)clearCreatedProgressForBundleID:(id)arg1
{
    [self.object performSelector:@selector(clearAdvertisingIdentifier) withObject:arg1];
}

- (id)delegateProxy
{
    return [self.object performSelector:@selector(delegateProxy)];
}

- (id)deviceIdentifierForAdvertising
{
    return [self.object performSelector:@selector(deviceIdentifierForAdvertising)];
}

- (id)deviceIdentifierForVendor
{
    return [self.object performSelector:@selector(deviceIdentifierForVendor)];
}

- (id)directionsApplications
{
    return [self.object performSelector:@selector(directionsApplications)];
}

- (id)installedPlugins
{
    return [self.object performSelector:@selector(installedPlugins)];
}

- (id)installedVPNPlugins
{
    return [self.object performSelector:@selector(installedVPNPlugins)];
}

- (id)placeholderApplications
{
    return [self.object performSelector:@selector(placeholderApplications)];
}

- (id)privateURLSchemes
{
    return [self.object performSelector:@selector(privateURLSchemes)];
}

- (id)publicURLSchemes
{
    return [self.object performSelector:@selector(publicURLSchemes)];
}

- (id)remoteObserver
{
    return [self.object performSelector:@selector(remoteObserver)];
}

- (void)removeInstallProgressForBundleID:(id)arg1
{
    [self.object performSelector:@selector(removeInstallProgressForBundleID:) withObject:arg1];
}

- (void)removeObserver:(id)arg1
{
    [self.object performSelector:@selector(removeObserver:) withObject:arg1];
}

- (id)unrestrictedApplications
{
    return [self.object performSelector:@selector(unrestrictedApplications)];
}


@end
