//
// NCCopyVisitor.h
// Newton Commander
//
#import <Foundation/Foundation.h>
#import "sc_traversal_objects.h"

typedef enum {
	NCCopyVisitorStatusOK               = 0x0000,

	// a file or dir already exist at the destination
	NCCopyVisitorStatusExist            = 0x0001,

	// some other error occured
	NCCopyVisitorStatusUnknownDir       = 0x1001,
	NCCopyVisitorStatusUnknownFile      = 0x1002,
	NCCopyVisitorStatusUnknownHardlink  = 0x1003,
	NCCopyVisitorStatusUnknownSymlink   = 0x1004,
	NCCopyVisitorStatusUnknownFifo      = 0x1005,
	NCCopyVisitorStatusUnknownChar      = 0x1006,
	NCCopyVisitorStatusUnknownBlock     = 0x1007,
	NCCopyVisitorStatusUnknownOther     = 0x1008,
} NCCopyVisitorStatusCode;

@interface NCCopyVisitor : NSObject <TraversalObjectVisitor>

@property (nonatomic, readonly) unsigned long long bytesCopied;
@property (nonatomic, readonly) NCCopyVisitorStatusCode statusCode;
@property (nonatomic, readonly) NSString* statusMessage;

+(NCCopyVisitor*)visitorWithSourcePath:(NSString*)sourcePath targetPath:(NSString*)targetPath;

@end
