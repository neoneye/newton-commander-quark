//
// NCMoveVisitor.h
// Newton Commander
//

#import <Foundation/Foundation.h>
#import "sc_traversal_objects.h"

typedef enum {
	NCMoveVisitorStatusOK                 = 0x0000,
	
	NCMoveVisitorStatusSourceDoesNotExist = 0x0001,
	NCMoveVisitorStatusDestDoesExist      = 0x0002,
	NCMoveVisitorStatusRenamedFailed      = 0x0003,
} NCMoveVisitorStatusCode;

@interface NCMoveVisitor : NSObject <TraversalObjectVisitor>

@property (nonatomic, readonly) NCMoveVisitorStatusCode statusCode;
@property (nonatomic, readonly) NSString* statusMessage;

+(NCMoveVisitor*)visitorWithSourcePath:(NSString*)sourcePath targetPath:(NSString*)targetPath;

@end
