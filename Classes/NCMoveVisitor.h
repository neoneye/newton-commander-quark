//
// NCMoveVisitor.h
// Newton Commander
//

#import <Foundation/Foundation.h>
#import "sc_traversal_objects.h"

@interface NCMoveVisitor : NSObject <TraversalObjectVisitor>

@property (nonatomic, strong) NSString* sourcePath;
@property (nonatomic, strong) NSString* targetPath;

@end
