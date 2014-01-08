//
// NCFinderInfoManager.h
// Newton Commander
//
#include <Foundation/Foundation.h>

@interface NCFinderInfoManager : NSObject

+(NCFinderInfoManager*)shared;

/*
ideally we want to copy between filedescriptors, however
filedescriptors cannot be converted into FSRefs.
So we have to use filenames.
*/
-(void)copyFrom:(NSString*)fromPath to:(NSString*)toPath;

@end
