//
// sc_scanner.h
// Newton Commander
//
#include <Foundation/Foundation.h>


@class TraversalObject;

/*
TODO: error handling. m_error is there, but no code for dealing with errors.
*/
@interface TraversalScanner : NSObject

@property (assign) unsigned long long bytesTotal;
@property (assign) unsigned long long countTotal;

-(void)addObject:(TraversalObject*)obj;

-(void)appendTraverseDataForPath:(NSString*)absolute_path;

-(NSArray*)traversalObjects;
@end
