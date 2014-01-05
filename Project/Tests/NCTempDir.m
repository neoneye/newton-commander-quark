//
// NCTempDir.m
// Newton Commander
//

#import "NCTempDir.h"

@interface NCTempDir ()
@property (nonatomic, strong) NSString *tempDirPath;
@end

@implementation NCTempDir

+(NCTempDir*)createTempDir:(NSString*)tempDirName {
	NSParameterAssert(tempDirName);
	NSString *path = [NCTempDir createTheActualTempDir:tempDirName];
	NCTempDir *td = [NCTempDir new];
	td.tempDirPath = path;
	return td;
}

+(NSString*)createTheActualTempDir:(NSString*)tempDirName {
	NSParameterAssert(tempDirName);
	/*
	 create a temporary dir, seen on Matt Gallagher's blog
	 http://cocoawithlove.com/2009/07/temporary-files-and-folders-in-cocoa.html
	 */
	NSString* tempDirectoryTemplate = [NSTemporaryDirectory() stringByAppendingPathComponent:tempDirName];
	const char* tempDirectoryTemplateCString = [tempDirectoryTemplate fileSystemRepresentation];
	char* tempDirectoryNameCString = (char *)malloc(strlen(tempDirectoryTemplateCString) + 1);
	strcpy(tempDirectoryNameCString, tempDirectoryTemplateCString);
	char* result = mkdtemp(tempDirectoryNameCString);
	NSAssert((result != NULL), @"cannot create tempdir for testing");
	NSString* tempDirectoryPath =
	[[NSFileManager defaultManager]
	 stringWithFileSystemRepresentation:tempDirectoryNameCString
	 length:strlen(result)];
	free(tempDirectoryNameCString);

	NSAssert(tempDirectoryPath, @"must always run this test inside a sandbox dir");
	return tempDirectoryPath;
}

-(NSString*)mkdir:(NSString*)name {
	NSParameterAssert(name);
	NSString* path = [_tempDirPath stringByAppendingPathComponent:name];
	BOOL ok = [[NSFileManager defaultManager]
			   createDirectoryAtPath:path
			   withIntermediateDirectories:NO
			   attributes:nil
			   error:NULL];
	if(!ok) {
		NSLog(@"couldn't create dir '%@' inside '%@'", name, _tempDirPath);
		NSAssert(nil, @"faild to create dir");
	}
	return path;
}

-(NSString*)mkfile:(NSString*)name {
	NSParameterAssert(name);
	NSString* path = [_tempDirPath stringByAppendingPathComponent:name];
	BOOL ok = [[NSFileManager defaultManager]
			   createFileAtPath:path
			   contents:[NSData data]
			   attributes:nil];
	if(!ok) {
		NSLog(@"couldn't create file '%@' inside '%@'", name, _tempDirPath);
		NSAssert(nil, @"faild to create file");
	}
	return path;
}

-(NSString*)mklink:(NSString*)name target:(NSString*)targetName {
	NSParameterAssert(name);
	NSParameterAssert(targetName);
	NSString* path = [_tempDirPath stringByAppendingPathComponent:name];
	BOOL ok = [[NSFileManager defaultManager]
			   createSymbolicLinkAtPath:path
			   withDestinationPath:targetName
			   error:NULL];
	if(!ok) {
		NSLog(@"couldn't create link '%@' inside '%@'  target: '%@'", name, _tempDirPath, targetName);
		NSAssert(nil, @"faild to create link");
	}
	return path;
}

-(NSString*)mkalias:(NSString*)name target:(NSString*)targetName {
	NSParameterAssert(name);
	NSParameterAssert(targetName);
	NSString* destpath = [_tempDirPath stringByAppendingPathComponent:name];
	NSURL* targetPath = [NSURL fileURLWithPath:[_tempDirPath stringByAppendingPathComponent:targetName]];
	NSURL* dest = [NSURL fileURLWithPath:destpath];
	
	NSData* data = [targetPath bookmarkDataWithOptions:NSURLBookmarkCreationSuitableForBookmarkFile
				 includingResourceValuesForKeys:nil
								  relativeToURL:nil
										  error:NULL];
	NSAssert(data, @"mkalias - no alias data");
	BOOL ok = [NSURL writeBookmarkData:data
								 toURL:dest
							   options:0
								 error:NULL];
	
	if(!ok) {
		NSLog(@"couldn't create alias '%@' inside '%@'  target: '%@'", targetName, _tempDirPath, name);
		NSAssert(nil, @"faild to create alias");
	}
	return destpath;
}

@end
