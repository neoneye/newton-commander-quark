//
// sc_transfer.h
// Newton Commander
//
#include <Foundation/Foundation.h>


@protocol TransferOperationDelegate;

@class TransferOperationThread;


@interface TransferOperation : NSObject 
@property (weak) id<TransferOperationDelegate> delegate;
@property (strong) NSArray* names;
@property (strong) NSString* fromDir;
@property (strong) NSString* toDir;
@property BOOL isMove;

+(TransferOperation*)copyOperation;
+(TransferOperation*)moveOperation;


-(void)performScan;
-(void)performOperation;
-(void)abortOperation;
-(void)dump;

-(void)threadResponse:(NSDictionary*)dict forKey:(NSString*)key;

@end // class TransferOperation



@protocol TransferOperationDelegate <NSObject>

-(void)transferOperation:(TransferOperation*)operation response:(NSDictionary*)dict forKey:(NSString*)key;

@end // protocol TransferOperationDelegate

