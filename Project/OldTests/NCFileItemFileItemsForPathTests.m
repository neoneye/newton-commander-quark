//
// NCFileItemFileItemsForPathTests.m
// Newton Commander
//
#import "NCFileItem+FileItemsForPath.h"
#import <XCTest/XCTest.h>

@interface NCFileItemFileItemsForPathTests : XCTestCase
@end

@implementation NCFileItemFileItemsForPathTests

-(void)test1 {
	NSArray *items = [NCFileItem fileItemsForPath:@"/"];
	BOOL has_tmp = NO;
	BOOL has_home = NO;  
	BOOL has_usr = NO;
	BOOL has_bin = NO;
	for (NCFileItem *item in items) {
		NSString* name = [item name];
		if([name isEqual:@"tmp"]) { has_tmp = YES; }
		if([name isEqual:@"home"]) { has_home = YES; }
		if([name isEqual:@"usr"]) { has_usr = YES; }
		if([name isEqual:@"bin"]) { has_bin = YES; }
	}
	XCTAssertTrue(has_tmp, @"the root dir typically has a /tmp dir");
	XCTAssertTrue(has_home, @"the root dir typically has a /home dir");
	XCTAssertTrue(has_usr, @"the root dir typically has a /usr dir");
	XCTAssertTrue(has_bin, @"the root dir typically has a /bin dir");
}

-(void)test2 {
	NSArray *items = [NCFileItem fileItemsForPath:@"/usr"];
	BOOL has_lib = NO;
	BOOL has_share = NO;  
	BOOL has_bin = NO;
	for (NCFileItem *item in items) {
		NSString* name = [item name];
		if([name isEqual:@"lib"]) { has_lib = YES; }
		if([name isEqual:@"share"]) { has_share = YES; }
		if([name isEqual:@"bin"]) { has_bin = YES; }
	}
	XCTAssertTrue(has_lib, @"the /usr dir typically has a /lib dir");
	XCTAssertTrue(has_share, @"the /usr dir typically has a /share dir");
	XCTAssertTrue(has_bin, @"the /usr dir typically has a /bin dir");
}

#if 0
-(void)test3 {
	NSArray *items = [NCFileItem fileItemsForPath:@"/non_existing_dir"];
	STAssertNil(items, @"invalid paths should not return any items");
}
#endif

@end
