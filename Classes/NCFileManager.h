//
// NCFileManager.h
// Newton Commander
//
#import <Foundation/Foundation.h>


/*
Similar to Apple's File Attribute Keys
*/
extern NSString * const NCFileSystemFileNumber;  // corresponds to stat.st_ino
extern NSString * const NCFileType;
extern NSString * const NCFileSize;
extern NSString * const NCFileReferenceCount;
extern NSString * const NCFileGroupOwnerAccountName;
extern NSString * const NCFileOwnerAccountName;
extern NSString * const NCFilePosixPermissions;
extern NSString * const NCFileFlags;
extern NSString * const NCFileAccessDate;
extern NSString * const NCFileContentModificationDate;
extern NSString * const NCFileAttributeModificationDate;
extern NSString * const NCFileCreationDate;        
extern NSString * const NCFileBackupDate;


extern NSString * const NCSpotlightKind;           // corresponds to kMDItemKind
extern NSString * const NCSpotlightContentType;    // corresponds to kMDItemContentType
extern NSString * const NCSpotlightFinderComment;  // corresponds to kMDItemFinderComment


/*
Similar to Apple's NSFileType Attribute Values.

NSFileManager lacks FIFO and Whiteout. 
I have experienced FIFO files, but never whiteout files.
*/
extern NSString * const NCFileTypeFIFO;
extern NSString * const NCFileTypeWhiteout;
extern NSString * const NCFileTypeDirectory;
extern NSString * const NCFileTypeRegular;
extern NSString * const NCFileTypeSymbolicLink;
extern NSString * const NCFileTypeSocket;
extern NSString * const NCFileTypeCharacterSpecial;
extern NSString * const NCFileTypeBlockSpecial;
extern NSString * const NCFileTypeUnknown;





@interface NCFileManager : NSObject

+(NCFileManager*)shared;

/*
wrapper for strerror_r
*/
+(NSString*)errnoString:(int)code;

-(NSDictionary*)attributesOfItemAtPath:(NSString*)path error:(NSError**)error;

/**
 Lookup the target URL that an alias points to
 @param anURL  A file path URL, such as file:///Users/johndoe/Desktop/myalias
 @return A file reference URL, such as file:///.file/id=6571367.30393253/
 From this file reference URL you must invoke -filePathURL in order to the the actual target URL
 */
-(NSURL*)fileReferenceURLFromAlias:(NSURL*)anURL;

-(NSString*)resolveAlias:(NSString*)pathAlias;

-(NSString*)resolvePath:(NSString*)path;

-(NSDictionary*)aclForItemAtPath:(NSString*)path error:(NSError**)error;

-(NSDictionary*)extendedAttributesOfItemAtPath:(NSString*)path error:(NSError**)error;

-(NSDictionary*)spotlightAttributesOfItemAtPath:(NSString*)path error:(NSError**)error;
                                  
-(unsigned long long)sizeOfResourceFork:(NSString*)path;

@end
