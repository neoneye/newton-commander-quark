//
// NSArray+ExtractTopLevelTraversalObjects.h
// Newton Commander
//

#import <Foundation/Foundation.h>

@interface NSArray (ExtractTopLevelTraversalObjects)

/**
 Only keep objects at depth 0. Reject objects deeper than 0.
 
 The move operation we only want to move the top-level objects.
 So here we have to discard content of nested folders.
 */
-(NSArray*)extractTopLevelTraversalObjects;

@end
