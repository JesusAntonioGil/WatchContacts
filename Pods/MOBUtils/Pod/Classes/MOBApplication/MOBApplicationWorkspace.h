//
//  MOBApplicationWorkspace.h
//  MOBUtils
//
//  Created by alexruperez on 12/1/15.
//
//

#import <Foundation/Foundation.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface MOBApplicationWorkspace : NSObject

+ (id)defaultWorkspace;

- (id)initWithPrivateObject:(id)object;

- (id)URLOverrideForURL:(id)arg1;
- (void)_LSClearSchemaCaches;
- (void)_clearCachedAdvertisingIdentifier;
- (void)addObserver:(id)arg1;
- (NSArray *)allApplications;
- (NSArray *)allApplicationsIdentifiers;
- (id)allInstalledApplications;
- (id)applicationForOpeningResource:(id)arg1;
- (id)applicationForUserActivityDomainName:(id)arg1;
- (id)applicationForUserActivityType:(id)arg1;
- (id)applicationsAvailableForHandlingURLScheme:(id)arg1;
- (id)applicationsAvailableForOpeningDocument:(id)arg1;
- (id)applicationsWithAudioComponents;
- (id)applicationsWithExternalAccessoryProtocols;
- (id)applicationsWithSettingsBundle;
- (id)applicationsWithUIBackgroundModes;
- (id)applicationsWithVPNPlugins;
- (void)clearAdvertisingIdentifier;
- (void)clearCreatedProgressForBundleID:(id)arg1;
- (id)delegateProxy;
- (id)deviceIdentifierForAdvertising;
- (id)deviceIdentifierForVendor;
- (id)directionsApplications;
- (id)installedPlugins;
- (id)installedVPNPlugins;
- (id)placeholderApplications;
- (id)privateURLSchemes;
- (id)publicURLSchemes;
- (id)remoteObserver;
- (void)removeInstallProgressForBundleID:(id)arg1;
- (void)removeObserver:(id)arg1;
- (id)unrestrictedApplications;


@end
