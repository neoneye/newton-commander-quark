//
// NCFinderInfoManager.m
// Newton Commander
//
#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "NCFinderInfoManager.h"
#import <CoreServices/CoreServices.h>

@implementation NCFinderInfoManager

+(NCFinderInfoManager*)shared {
    static NCFinderInfoManager *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [NCFinderInfoManager new];
    });
    return shared;
}

-(void)copyFrom:(NSString*)fromPath to:(NSString*)toPath {
	const char* source_path = [fromPath fileSystemRepresentation];
	const char* target_path = [toPath fileSystemRepresentation];

	FSRef source_ref;
	OSStatus status = FSPathMakeRef((unsigned char*)source_path, &source_ref, NULL);
	if(status != noErr) {
		NSLog(@"%@ FSPathMakeRef", NSStringFromSelector(_cmd));
    	return;
  	}

	FSRef target_ref;
	status = FSPathMakeRef((unsigned char*)target_path, &target_ref, NULL);
	if(status != noErr) {
		NSLog(@"%@ FSPathMakeRef", NSStringFromSelector(_cmd));
    	return;
  	}

	FSCatalogInfo info;
	status = FSGetCatalogInfo(
		&source_ref, 
		kFSCatInfoFinderInfo,
		&info, 
		NULL,
		NULL,
		NULL
	);
	if(status != noErr) {
		NSLog(@"%@ FSGetCatalogInfo", NSStringFromSelector(_cmd));
		return;
	}

	status = FSSetCatalogInfo(
		&target_ref, 
		kFSCatInfoFinderInfo, 
		&info
	);
	if(status != noErr) {
		NSLog(@"%@ FSSetCatalogInfo", NSStringFromSelector(_cmd));
		return;
	}
}

@end // @implementation FinderInfoManager
