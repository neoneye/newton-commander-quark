//
// NCMoveVisitorTests.m
// Newton Commander
//

#import <XCTest/XCTest.h>
#import "NCTempDir.h"
#import "NCMoveVisitor.h"

@interface NCMoveVisitorTests : XCTestCase
@property (nonatomic, strong) NCTempDir *tempDir;
@end

@implementation NCMoveVisitorTests

-(void)setUp {
    [super setUp];
	self.tempDir = [NCTempDir createTempDir:@"NewtonCommander_NCMoveVisitorTests.XXXXXX"];
}

- (void)testSuccess
{
	NSString *sourcePath = [_tempDir mkdir:@"src"];
	NSString *sourceFile = [_tempDir mkfile:@"src/0"];
	NSString *destPath = [_tempDir mkdir:@"dest"];

	TOFile *file = [TOFile new];
	file.path = sourceFile;
	NCMoveVisitor *v = [NCMoveVisitor visitorWithSourcePath:sourcePath targetPath:destPath];
	[file accept:v];
	
	XCTAssertEqual(v.statusCode, NCMoveVisitorStatusOK, @"there should be no problems moving this file");
	BOOL sourceExist = [[NSFileManager defaultManager] fileExistsAtPath:[sourcePath stringByAppendingPathComponent:@"0"]];
	XCTAssertFalse(sourceExist, @"source file should no longer exist");
	BOOL destExist = [[NSFileManager defaultManager] fileExistsAtPath:[destPath stringByAppendingPathComponent:@"0"]];
	XCTAssertTrue(destExist, @"dest file exist");
}

- (void)testFailSourceDoesNotExist
{
	NSString *sourcePath = [_tempDir mkdir:@"src"];
	NSString *destPath = [_tempDir mkdir:@"dest"];
	
	TOFile *file = [TOFile new];
	file.path = [sourcePath stringByAppendingPathComponent:@"0"];
	NCMoveVisitor *v = [NCMoveVisitor visitorWithSourcePath:sourcePath targetPath:destPath];
	[file accept:v];
	
	XCTAssertEqual(v.statusCode, NCMoveVisitorStatusSourceDoesNotExist, @"we should detect that there is no source file with the specified name");
	BOOL destExist = [[NSFileManager defaultManager] fileExistsAtPath:[destPath stringByAppendingPathComponent:@"0"]];
	XCTAssertFalse(destExist, @"dest file should not have been created");
}

- (void)testFailDestAlreadyExist
{
	NSString *sourcePath = [_tempDir mkdir:@"src"];
	NSString *sourceFile = [_tempDir mkfile:@"src/0"];
	NSString *destPath = [_tempDir mkdir:@"dest"];
	[_tempDir mkfile:@"dest/0"];
	
	TOFile *file = [TOFile new];
	file.path = sourceFile;
	NCMoveVisitor *v = [NCMoveVisitor visitorWithSourcePath:sourcePath targetPath:destPath];
	[file accept:v];
	
	XCTAssertEqual(v.statusCode, NCMoveVisitorStatusDestDoesExist, @"we should detect that there already is a file at the destination with the same name");
	BOOL sourceExist = [[NSFileManager defaultManager] fileExistsAtPath:[sourcePath stringByAppendingPathComponent:@"0"]];
	XCTAssertTrue(sourceExist, @"source file should not have been moved");
	BOOL destExist = [[NSFileManager defaultManager] fileExistsAtPath:[destPath stringByAppendingPathComponent:@"0"]];
	XCTAssertTrue(destExist, @"dest file should not have been overwritten");
}

@end
