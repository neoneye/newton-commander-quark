//
// NCTransferOperationTests.m
// Newton Commander
//

#import <XCTest/XCTest.h>
#import "NCTempDir.h"
#import "sc_transfer.h"

@interface NCTransferOperationTests : XCTestCase <TransferOperationDelegate>
@property (nonatomic, strong) NCTempDir *tempDir;
@end

@implementation NCTransferOperationTests

-(void)setUp {
    [super setUp];
	self.tempDir = [NCTempDir createTempDir:@"NewtonCommander_TransferOperationTests.XXXXXX"];
}

- (void)xtestCopy1
{
	NSString* src = [_tempDir mkdir:@"src"];
	NSString* dst = [_tempDir mkdir:@"dst"];

	NSString *name = @"test_file";
	[_tempDir mkfile:[@"src" stringByAppendingPathComponent:name]];

	
	TransferOperation *op = [TransferOperation copyOperation];
	op.fromDir = src;
	op.toDir = dst;
	op.names = @[name];
	op.delegate = self;
	
	[op performScan];
	
	// wait until transfer has completed
}

-(void)transferOperation:(TransferOperation*)operation response:(NSDictionary*)dict forKey:(NSString*)key {
	NSLog(@"%@ %@", dict, key);
}


@end
