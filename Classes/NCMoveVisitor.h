//
// NCMoveVisitor.h
// Newton Commander
//

#import <Foundation/Foundation.h>
#import "sc_traversal_objects.h"

@interface NCMoveVisitor : NSObject <TraversalObjectVisitor>

+(NCMoveVisitor*)visitorWithSourcePath:(NSString*)sourcePath targetPath:(NSString*)targetPath;

@end
