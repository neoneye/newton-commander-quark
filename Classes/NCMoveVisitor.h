//
// NCMoveVisitor.h
// Newton Commander
//

#import <Foundation/Foundation.h>
#import "sc_traversal_objects.h"

typedef enum {
	NCMoveVisitorStatusOK               = 0x0000,
	
	// some other error occured
	NCMoveVisitorStatusUnknownDir       = 0x1001,
	NCMoveVisitorStatusUnknownFile      = 0x1002,
	NCMoveVisitorStatusUnknownHardlink  = 0x1003,
	NCMoveVisitorStatusUnknownSymlink   = 0x1004,
	NCMoveVisitorStatusUnknownFifo      = 0x1005,
	NCMoveVisitorStatusUnknownChar      = 0x1006,
	NCMoveVisitorStatusUnknownBlock     = 0x1007,
	NCMoveVisitorStatusUnknownOther     = 0x1008,
} NCMoveVisitorStatusCode;

@interface NCMoveVisitor : NSObject <TraversalObjectVisitor>

@property (nonatomic, readonly) NCMoveVisitorStatusCode statusCode;
@property (nonatomic, readonly) NSString* statusMessage;

+(NCMoveVisitor*)visitorWithSourcePath:(NSString*)sourcePath targetPath:(NSString*)targetPath;

@end
