//
// NCTransferScanner.m
// Newton Commander
//

#import "NCTransferScanner.h"
#import "sc_traversal_objects.h"
#import "NCTraversalScanner.h"

@interface NCTransferScanner ()
@property (nonatomic, strong) NSString *path;
@property (nonatomic, strong) NSArray *names;
@property (nonatomic, copy) NCTransferScannerProgressBlock progressBlock;
@property (nonatomic, strong) NSArray *resultTraversalObjects;
@property (nonatomic, assign) uint64_t resultBytesTotal;
@property (nonatomic, assign) uint64_t resultCountTotal;
@end

@implementation NCTransferScanner

+(NCTransferScanner*)scannerWithPath:(NSString*)path
							   names:(NSArray*)names
					 progressHandler:(NCTransferScannerProgressBlock)progressBlock
{
	NSParameterAssert(path);
	NSParameterAssert(names);
	// It's ok for progressBlock to be nil
	NCTransferScanner *ts = [NCTransferScanner new];
	ts.path = path;
	ts.names = names;
	ts.progressBlock = progressBlock;
	return ts;
}

-(void)execute {
	NCTraversalScanner* maker = [[NCTraversalScanner alloc] init];
	
	for (NSString *name in _names) {
		
		uint64_t bytes_total0 = [maker bytesTotal];
		uint64_t count_total0 = [maker countTotal];
		
		{
			TOProgressBefore* obj = [[TOProgressBefore alloc] init];
			[obj setName:name];
			[maker addObject:obj];
		}
		
		[maker appendTraverseDataForPath:[_path stringByAppendingPathComponent:name]];
		
		{
			TOProgressAfter* obj = [[TOProgressAfter alloc] init];
			[obj setName:name];
			[maker addObject:obj];
		}
		
		uint64_t bytes_total1 = [maker bytesTotal];
		uint64_t count_total1 = [maker countTotal];
		
		uint64_t bytes_item = bytes_total1 - bytes_total0;
		uint64_t count_item = count_total1 - count_total0;
		
		/*
		 TODO: update scan-progress
		 TODO: poll max 10 times per second some counters protected with a mutex.. run it in a thread
		 */
		
		if (_progressBlock) {
			_progressBlock(name, bytes_total1, count_total1, bytes_item, count_item);
		}
	}
	
	self.resultTraversalObjects = [maker traversalObjects];
	self.resultBytesTotal = [maker bytesTotal];
	self.resultCountTotal = [maker countTotal];
}

@end
