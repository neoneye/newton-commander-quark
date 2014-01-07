//
// NCTransferScannerTests.m
// Newton Commander
//

#import <XCTest/XCTest.h>
#import "NCTempDir.h"
#import "NCTransferScanner.h"

@interface NCTransferScannerTests : XCTestCase
@property (nonatomic, strong) NCTempDir *tempDir;
@end

@implementation NCTransferScannerTests

-(void)setUp {
    [super setUp];
	self.tempDir = [NCTempDir createTempDir:@"NewtonCommander_NCTransferScannerTests.XXXXXX"];
}

-(void)testProgressCallback
{
	[_tempDir mkdir:@"item0"];
	[_tempDir mkdir:@"item1"];
	[_tempDir mkfile:@"item1/0"];
	[_tempDir mkfile:@"item1/1"];
	[_tempDir mkfile:@"item2"];
	[_tempDir mkdir:@"item3"];
	[_tempDir mkdir:@"item3/0"];
	[_tempDir mkdir:@"item3/0/0"];
	[_tempDir mkdir:@"item3/0/0/0"];
	
	NSArray *names = @[@"item0", @"item1", @"item2", @"item3"];
	
	NSMutableArray *actualAccumulated = [NSMutableArray new];
	
	NCTransferScanner *ts = [NCTransferScanner scannerWithPath:_tempDir.tempDirPath
														 names:names
											   progressHandler:^(NSString *name, uint64_t bytes_total, uint64_t count_total, uint64_t bytes_item, uint64_t count_item) {
												   NSString *s = [NSString stringWithFormat:@"%@ %llu %llu", name, count_total, count_item];
												   [actualAccumulated addObject:s];
											   }];
	[ts execute];
	
	NSString *actual = [actualAccumulated componentsJoinedByString:@"\n"];


	NSMutableArray *expectedAccumulated = [NSMutableArray new];
	[expectedAccumulated addObject:@"item0 1 1"];
	[expectedAccumulated addObject:@"item1 4 3"];
	[expectedAccumulated addObject:@"item2 5 1"];
	[expectedAccumulated addObject:@"item3 9 4"];
	NSString *expected = [expectedAccumulated componentsJoinedByString:@"\n"];
	
	XCTAssertEqualObjects(actual, expected, @"progress result should match expected progress output");
}

-(void)testResult
{
	[_tempDir mkdir:@"item0"];
	[_tempDir mkdir:@"item1"];
	[_tempDir mkfile:@"item1/0"];
	[_tempDir mkfile:@"item1/1"];
	[_tempDir mkfile:@"item2"];
	[_tempDir mkdir:@"item3"];
	[_tempDir mkdir:@"item3/0"];
	[_tempDir mkdir:@"item3/0/0"];
	[_tempDir mkdir:@"item3/0/0/0"];
	
	NSArray *names = @[@"item0", @"item1", @"item2", @"item3"];
	
	NCTransferScanner *ts = [NCTransferScanner scannerWithPath:_tempDir.tempDirPath
														 names:names
											   progressHandler:nil];
	[ts execute];
	
	{
		uint64_t actual = ts.resultCountTotal;
		uint64_t expected = 9;
		XCTAssertEqual(actual, expected, @"total number of items");
	}
	{
		NSMutableArray *actualAccumulated = [NSMutableArray new];
		for (NSObject *obj in ts.resultTransactionObjects) {
			[actualAccumulated addObject:NSStringFromClass(obj.class)];
		}
		NSString *actual = [actualAccumulated componentsJoinedByString:@"\n"];
		
		
		NSMutableArray *expectedAccumulated = [NSMutableArray new];
		[expectedAccumulated addObject:@"TOProgressBefore"];
		[expectedAccumulated addObject:@"TODirPre"];
		[expectedAccumulated addObject:@"TODirPost"];
		[expectedAccumulated addObject:@"TOProgressAfter"];
		[expectedAccumulated addObject:@"TOProgressBefore"];
		[expectedAccumulated addObject:@"TODirPre"];
		[expectedAccumulated addObject:@"TOFile"];
		[expectedAccumulated addObject:@"TOFile"];
		[expectedAccumulated addObject:@"TODirPost"];
		[expectedAccumulated addObject:@"TOProgressAfter"];
		[expectedAccumulated addObject:@"TOProgressBefore"];
		[expectedAccumulated addObject:@"TOFile"];
		[expectedAccumulated addObject:@"TOProgressAfter"];
		[expectedAccumulated addObject:@"TOProgressBefore"];
		[expectedAccumulated addObject:@"TODirPre"];
		[expectedAccumulated addObject:@"TODirPre"];
		[expectedAccumulated addObject:@"TODirPre"];
		[expectedAccumulated addObject:@"TODirPre"];
		[expectedAccumulated addObject:@"TODirPost"];
		[expectedAccumulated addObject:@"TODirPost"];
		[expectedAccumulated addObject:@"TODirPost"];
		[expectedAccumulated addObject:@"TODirPost"];
		[expectedAccumulated addObject:@"TOProgressAfter"];
		NSString *expected = [expectedAccumulated componentsJoinedByString:@"\n"];

		XCTAssertEqualObjects(actual, expected, @"traversal objects should be like this");
	}
}

@end
