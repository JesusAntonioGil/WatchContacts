//
//  MOBApplicationProxy.h
//  MOBUtils
//
//  Created by alexruperez on 12/1/15.
//
//

#import <Foundation/Foundation.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface MOBApplicationProxy : NSObject

+ (NSArray *)arrayFromPrivateArray:(NSArray *)array;

- (id)initWithPrivateObject:(id)object;

- (id)UIBackgroundModes;
- (id)VPNPlugins;
- (id)appStoreReceiptURL;
- (id)appTags;
- (id)applicationDSID;
- (id)applicationIdentifier;
- (id)applicationType;
- (id)audioComponents;
- (id)description;
- (id)deviceFamily;
- (id)deviceIdentifierForVendor;
- (id)directionsModes;
- (id)dynamicDiskUsage;
- (void)encodeWithCoder:(id)arg1;
- (id)externalAccessoryProtocols;
- (id)groupContainers;
- (id)groupIdentifiers;
- (id)iconStyleDomain;
- (id)installProgress;
- (id)installProgressSync;
- (id)itemID;
- (id)itemName;
- (id)localizedName;
- (id)localizedShortName;
- (id)machOUUIDs;
- (id)minimumSystemVersion;
- (id)plugInKitPlugins;
- (id)privateDocumentIconNames;
- (id)privateDocumentTypeOwner;
- (id)requiredDeviceCapabilities;
- (id)resourcesDirectoryURL;
- (id)roleIdentifier;
- (id)sdkVersion;
- (void)setPrivateDocumentIconNames:(id)arg1;
- (void)setPrivateDocumentTypeOwner:(id)arg1;
- (id)shortVersionString;
- (id)staticDiskUsage;
- (id)storeCohortMetadata;
- (id)storeFront;
- (id)teamID;
- (id)userActivityStringForAdvertisementData:(id)arg1;
- (id)vendorName;

@end
