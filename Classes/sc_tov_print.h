//
// sc_tov_print.h
// Newton Commander
//
#import "sc_traversal_objects.h"

@interface TOVPrint : NSObject <TraversalObjectVisitor> 
@property (strong) NSString* sourcePath;
@property (strong) NSString* targetPath;

-(NSString*)result;

-(NSString*)convert:(NSString*)path;
@end
