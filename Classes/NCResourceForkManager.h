//
// NCResourceForkManager.h
// Newton Commander
//
#include <Foundation/Foundation.h>

@interface NCResourceForkManager : NSObject

+(NCResourceForkManager*)shared;

-(NSData*)getResourceForkFromFile:(NSString*)path;
-(void)setResourceFork:(NSData*)data onFile:(NSString*)path;

/*
ideally we want to copy between filedescriptors, however
filedescriptors cannot be converted into FSRefs.
So we have to use filenames.
*/
-(void)copyFrom:(NSString*)fromPath to:(NSString*)toPath;

@end
