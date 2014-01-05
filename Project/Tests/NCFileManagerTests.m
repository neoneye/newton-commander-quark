//
// NCFileManagerTests.m
// Newton Commander
//
#import "NCFileManager.h"
#import "NCTempDir.h"
#import <XCTest/XCTest.h>

@interface NCFileManagerTests : XCTestCase
@end

@implementation NCFileManagerTests

-(NSString*)nc_readlink:(NSString*)path {
	const char* read_path = [path fileSystemRepresentation];
	char buffer[PATH_MAX + 4];
	ssize_t l = readlink(read_path, buffer, sizeof(buffer) - 1);
	if(l != -1) {
		buffer[l] = 0;
		return [NSString stringWithUTF8String:buffer];
	}
	return nil;
}

-(void)testStringByResolvingSymlink1 {
	/*
	on Mac OS X 10.6
	"/tmp" is a symlink pointing at "private/tmp"
	*/
	{
		NSString* path = @"/tmp";
		NSString* expected = @"private/tmp";
		NSString* actual = [self nc_readlink:path];
		XCTAssertEqualObjects(actual, expected, @"Expected '%@', but got '%@'", expected, actual);
	}
	{
		NSString* path = @"/tmp";
		NSString* expected = @"/tmp";
		/*
		NOTE: Apple's stringByResolvingSymlinksInPath removes "/private" from the path,
		which makes stringByResolvingSymlinksInPath not suitable for us to use
		*/
		NSString* actual = [path stringByResolvingSymlinksInPath];
		XCTAssertEqualObjects(actual, expected, @"Expected '%@', but got '%@'", expected, actual);
	}
	{
		/*
		NOTE: Apple's destinationOfSymbolicLinkAtPath doesn't remove "/private" from the path,
		which means that destinationOfSymbolicLinkAtPath works the same way as readlink()
		*/
		NSString* path = @"/tmp";
		NSString* actual = [[NSFileManager defaultManager]
			destinationOfSymbolicLinkAtPath:path
			error:NULL];

		NSString* expected = @"private/tmp";
		XCTAssertEqualObjects(actual, expected, @"Expected '%@', but got '%@'", expected, actual);
	}
}

-(void)testStringByResolvingSymlink2 {
	/*
	on Mac OS X 10.6
	"/usr/X11R6" is a symlink pointing at "X11"
	*/
	{
		NSString* path = @"/usr/X11R6";
		NSString* expected = @"X11";
		NSString* actual = [self nc_readlink:path];
		XCTAssertEqualObjects(actual, expected, @"Expected '%@', but got '%@'", expected, actual);
	}
	{
		NSString* path = @"/usr/X11R6";
		NSString* expected = @"/usr/X11";
		NSString* actual = [path stringByResolvingSymlinksInPath];
		XCTAssertEqualObjects(actual, expected, @"Expected '%@', but got '%@'", expected, actual);
	}
}

-(void)testStringByResolvingSymlink3 {
	NSString* path = @"/non_existing_dir";
	NSString* actual = [self nc_readlink:path];
	XCTAssertNil(actual, @"invalid paths should not return anything");                     
}

-(void)testNormalizedPath1 {
	NSString* path = @"/";
	NSString* expected = @"/";
	NSString* actual = [[NCFileManager shared] resolvePath:path];
	XCTAssertEqualObjects(actual, expected, @"Expected '%@', but got '%@'", expected, actual);
}

-(void)testNormalizedPath2 {
	NSString* path = @"/usr";
	NSString* expected = @"/usr";
	NSString* actual = [[NCFileManager shared] resolvePath:path];
	XCTAssertEqualObjects(actual, expected, @"Expected '%@', but got '%@'", expected, actual);
}

-(void)testNormalizedPath3 {
	NSString* path = @"/usr/share/../share";
	NSString* expected = @"/usr/share";
	NSString* actual = [[NCFileManager shared] resolvePath:path];
	XCTAssertEqualObjects(actual, expected, @"Expected '%@', but got '%@'", expected, actual);
}

-(void)testNormalizedPath4 {
	NSString* path = @"/usr/./share";
	NSString* expected = @"/usr/share";
	NSString* actual = [[NCFileManager shared] resolvePath:path];
	XCTAssertEqualObjects(actual, expected, @"Expected '%@', but got '%@'", expected, actual);
}

-(void)testNormalizedPath5 {
	NSString* path = @"/usr/X11R6";
	NSString* expected = @"/usr/X11";
	NSString* actual = [[NCFileManager shared] resolvePath:path];
	XCTAssertEqualObjects(actual, expected, @"Expected '%@', but got '%@'", expected, actual);
}

@end


@interface NSFileManager_ResolvePathTest : XCTestCase
@property (nonatomic, strong) NCTempDir *tempDir;
@end

@implementation NSFileManager_ResolvePathTest

-(void)setUp {
    [super setUp];
	self.tempDir = [NCTempDir createTempDir:@"NSFileManager_ResolvePathTest.XXXXXX"];
}

-(void)test1 {
	NSString* path = [_tempDir mkdir:@"test_dir"];
	
	NSString* expected = path;
	NSString* actual = [[NCFileManager shared] resolvePath:path];
	expected = [expected stringByStandardizingPath];
	actual = [actual stringByStandardizingPath];
	XCTAssertEqualObjects(actual, expected, @"Expected '%@', but got '%@'", expected, actual);
}

-(void)test2 {
	NSString* path_dir = [_tempDir mkdir:@"test_dir"];
	NSString* path_link = [_tempDir mklink:@"test_link" target:@"test_dir"];
	
	NSString* expected = path_dir;
	NSString* actual = [[NCFileManager shared] resolvePath:path_link];
	expected = [expected stringByStandardizingPath];
	actual = [actual stringByStandardizingPath];
	XCTAssertEqualObjects(actual, expected, @"Path mismatch");
}

-(void)testSymlink1 {
	NSString* path_dir = @"/usr/bin";
	NSString* path_link = [_tempDir mklink:@"test_link" target:@"/usr/bin"];
	
	NSString* expected = path_dir;
	NSString* actual = [[NCFileManager shared] resolvePath:path_link];
	expected = [expected stringByStandardizingPath];
	actual = [actual stringByStandardizingPath];
	XCTAssertEqualObjects(actual, expected, @"Path mismatch");
}

-(void)testSymlink2 {
	[_tempDir mkdir:@"test_dir"];
	NSString* path_file = [_tempDir mkfile:@"test_dir/test_file"];
	NSString* path_link = [_tempDir mklink:@"test_link" target:@"test_dir"];
	NSString* path_link2 = [path_link stringByAppendingPathComponent:@"test_file"];
	
	NSString* expected = path_file;
	NSString* actual = [[NCFileManager shared] resolvePath:path_link2];
	expected = [expected stringByStandardizingPath];
	actual = [actual stringByStandardizingPath];
	XCTAssertEqualObjects(actual, expected, @"Path mismatch");
}

-(void)testSymlinkCycle1 {
	NSString* path_link = [_tempDir mklink:@"test_link" target:@"test_link"];
	NSString* actual = [[NCFileManager shared] resolvePath:path_link];
	XCTAssertNil(actual, @"paths containing loops should not return anything");                     
}

-(void)testAlias1 {
	NSString* path_dir = [_tempDir mkdir:@"test_dir"];
	NSString* path_link = [_tempDir mkalias:@"test_alias" target:@"test_dir"];
	
	NSString* expected = path_dir;
	NSString* actual = [[NCFileManager shared] resolvePath:path_link];
	expected = [expected stringByStandardizingPath];
	actual = [actual stringByStandardizingPath];
	XCTAssertEqualObjects(actual, expected, @"Path mismatch");
}

-(void)testAlias2 {
	[_tempDir mkdir:@"test_dir"];
	NSString* path_file = [_tempDir mkfile:@"test_dir/test_file"];
	NSString* path_link = [_tempDir mkalias:@"test_alias" target:@"test_dir"];
	NSString* path_link2 = [path_link stringByAppendingPathComponent:@"test_file"];
	
	NSString* expected = path_file;
	NSString* actual = [[NCFileManager shared] resolvePath:path_link2];
	expected = [expected stringByStandardizingPath];
	actual = [actual stringByStandardizingPath];
	XCTAssertEqualObjects(actual, expected, @"Path mismatch");
}

-(void)testAliasCycle1 {
	// the alias code refuses to create loops
	XCTAssertThrows([_tempDir mkalias:@"test_alias" target:@"test_alias"], @"alias cycle");
}

@end
