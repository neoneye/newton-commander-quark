//
// NCTempDir.h
// Newton Commander
//

#import <Foundation/Foundation.h>

@interface NCTempDir : NSObject

@property (nonatomic, readonly) NSString *tempDirPath;

/**
 creates a /tmp folder using the mkdtemp() function
 */
+(NCTempDir*)createTempDir:(NSString*)tempDirName;

/**
 create dir inside tempdir and return absolute path to it
 */
-(NSString*)mkdir:(NSString*)name;

/**
 create file inside tempdir and return absolute path to it
 */
-(NSString*)mkfile:(NSString*)name;

/**
 create symlink inside tempdir and return absolute path to it
 */
-(NSString*)mklink:(NSString*)name target:(NSString*)targetName;

/**
 create alias inside tempdir and return absolute path to it
 */
-(NSString*)mkalias:(NSString*)name target:(NSString*)targetName;


@end
