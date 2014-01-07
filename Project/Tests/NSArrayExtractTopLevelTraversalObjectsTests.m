//
// NSArrayExtractTopLevelTraversalObjectsTests.m
// Newton Commander
//

#import <XCTest/XCTest.h>
#import "NCTempDir.h"
#import "NCTransferScanner.h"
#import "NSArray+ExtractTopLevelTraversalObjects.h"


@interface NSArrayExtractTopLevelTraversalObjectsTests : XCTestCase
@property (nonatomic, strong) NCTempDir *tempDir;
@end

@implementation NSArrayExtractTopLevelTraversalObjectsTests

-(void)setUp {
    [super setUp];
	self.tempDir = [NCTempDir createTempDir:@"NewtonCommander_NSArrayExtractTopLevelTraversalObjectsTests.XXXXXX"];
}

-(void)testRemoveContentOfNestedFolders
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
	[_tempDir mkfile:@"item3/0/0/0/file"];
	
	NSArray *names = @[@"item0", @"item1", @"item2", @"item3"];
	
	NCTransferScanner *ts = [NCTransferScanner scannerWithPath:_tempDir.tempDirPath
														 names:names
											   progressHandler:nil];
	[ts execute];
	
	{
		NSArray *traversalObjects = ts.resultTraversalObjects;
		traversalObjects = [traversalObjects extractTopLevelTraversalObjects];
		
		NSMutableArray *actualAccumulated = [NSMutableArray new];
		for (NSObject *obj in traversalObjects) {
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
		[expectedAccumulated addObject:@"TODirPost"];
		[expectedAccumulated addObject:@"TOProgressAfter"];
		[expectedAccumulated addObject:@"TOProgressBefore"];
		[expectedAccumulated addObject:@"TOFile"];
		[expectedAccumulated addObject:@"TOProgressAfter"];
		[expectedAccumulated addObject:@"TOProgressBefore"];
		[expectedAccumulated addObject:@"TODirPre"];
		[expectedAccumulated addObject:@"TODirPost"];
		[expectedAccumulated addObject:@"TOProgressAfter"];
		NSString *expected = [expectedAccumulated componentsJoinedByString:@"\n"];
		
		XCTAssertEqualObjects(actual, expected, @"traversal objects should be like this");
	}
}

@end
