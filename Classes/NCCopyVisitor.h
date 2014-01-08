//
// NCCopyVisitor.h
// Newton Commander
//
#import <Foundation/Foundation.h>
#import "sc_traversal_objects.h"

enum {
	kCopierStatusOK               = 0x0000,

	// a file or dir already exist at the destination. Do you want to overwrite it?
	kCopierStatusExist            = 0x0001,

	// some other error occured
	kCopierStatusUnknownDir       = 0x1001,
	kCopierStatusUnknownFile      = 0x1002,
	kCopierStatusUnknownHardlink  = 0x1003,
	kCopierStatusUnknownSymlink   = 0x1004,
	kCopierStatusUnknownFifo      = 0x1005,
	kCopierStatusUnknownChar      = 0x1006,
	kCopierStatusUnknownBlock     = 0x1007,
	kCopierStatusUnknownOther     = 0x1008,
};

@interface NCCopyVisitor : NSObject <TraversalObjectVisitor>

@property (assign) unsigned long long bytesCopied;
@property NSUInteger statusCode;
@property (strong) NSString* statusMessage;

+(NCCopyVisitor*)visitorWithSourcePath:(NSString*)sourcePath targetPath:(NSString*)targetPath;


-(void)setStatus:(NSUInteger)status posixError:(int)error_code message:(NSString*)message, ...;

-(NSString*)result;

-(NSString*)convert:(NSString*)path;
@end
