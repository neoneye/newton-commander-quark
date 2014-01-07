//
// NCTransferScanner.h
// Newton Commander
//

#import <Foundation/Foundation.h>

typedef void (^NCTransferScannerProgressBlock)(NSString *name, uint64_t bytes_total, uint64_t count_total, uint64_t bytes_item, uint64_t count_item);

@interface NCTransferScanner : NSObject

@property (nonatomic, readonly) NSArray *resultTransactionObjects;
@property (nonatomic, readonly) uint64_t resultBytesTotal;
@property (nonatomic, readonly) uint64_t resultCountTotal;


+(NCTransferScanner*)scannerWithPath:(NSString*)path
							   names:(NSArray*)names
					 progressHandler:(NCTransferScannerProgressBlock)progressBlock;

-(void)execute;

@end
