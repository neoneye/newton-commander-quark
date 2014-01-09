//
// NCMoveVisitor.m
// Newton Commander
//

#import "NCMoveVisitor.h"
#import "NCLog.h"
#import "NCFileManager.h"
#include <sys/stat.h>

@interface NCMoveVisitor ()
@property (nonatomic, assign) NCMoveVisitorStatusCode statusCode;
@property (nonatomic, strong) NSString* statusMessage;
@property (nonatomic, strong) NSString* sourcePath;
@property (nonatomic, strong) NSString* targetPath;
@end

@implementation NCMoveVisitor

+(NCMoveVisitor*)visitorWithSourcePath:(NSString*)sourcePath targetPath:(NSString*)targetPath {
	NSParameterAssert(sourcePath);
	NSParameterAssert(targetPath);
	NCMoveVisitor *v = [NCMoveVisitor new];
	v.sourcePath = sourcePath;
	v.targetPath = targetPath;
	return v;
}

-(id)init {
	self = [super init];
    if(self) {
		_statusCode = NCMoveVisitorStatusOK;
    }
    return self;
}

-(NSString*)convert:(NSString*)path {
	if([path hasPrefix:_sourcePath]) {
		NSString* s = [path substringFromIndex:[_sourcePath length]];
		return [_targetPath stringByAppendingString:s];
	}
	return path;
}

-(void)setStatus:(NCMoveVisitorStatusCode)status posixError:(int)error_code message:(NSString*)message, ... {
	va_list ap;
	va_start(ap,message);
	NSString* message2 = [[NSString alloc] initWithFormat:message arguments:ap];
	va_end(ap);
	
	NSString* error_text = [NCFileManager errnoString:error_code];
	NSString* status_message = [NSString stringWithFormat:@"ERROR status: %i\nposix-code: %@\nmessage: %@", (int)status, error_text, message2];
	LOG_ERROR(@"%@", status_message);
	
	_statusCode = status;
	_statusMessage = status_message;
}

-(void)renameType:(NSString*)type itemPath:(NSString*)itemPath {
	const char* source_path = [itemPath fileSystemRepresentation];
	const char* target_path = [[self convert:itemPath] fileSystemRepresentation];

	// check if source exist
	{
		struct stat sb;
		if (lstat(source_path, &sb) == -1) {
			[self setStatus:NCMoveVisitorStatusSourceDoesNotExist posixError:ENOENT
					message:@"%@ %s %s", type, source_path, target_path];
			return;
		}
	}

	// check if no dest already exist
	{
		struct stat sb;
		if (!stat(target_path, &sb)) {
			[self setStatus:NCMoveVisitorStatusDestDoesExist posixError:EEXIST
					message:@"%@ %s %s", type, source_path, target_path];
			return;
		}
		
	}
	
	// move it
	if(rename(source_path, target_path)) {
		[self setStatus:NCMoveVisitorStatusRenamedFailed posixError:errno
				message:@"%@ %s %s", type, source_path, target_path];
	}
}

-(void)visitDirPre:(TODirPre*)obj {
	[self renameType:@"dir" itemPath:obj.path];
}

-(void)visitDirPost:(TODirPost*)obj {
	// do nothing
}

-(void)visitFile:(TOFile*)obj {
	[self renameType:@"file" itemPath:obj.path];
}

-(void)visitHardlink:(TOHardlink*)obj {
	[self renameType:@"hardlink" itemPath:obj.path];
}

-(void)visitSymlink:(TOSymlink*)obj {
	[self renameType:@"symlink" itemPath:obj.path];
}

-(void)visitFifo:(TOFifo*)obj {
	[self renameType:@"fifo" itemPath:obj.path];
}

-(void)visitChar:(TOChar*)obj {
	[self renameType:@"char" itemPath:obj.path];
}

-(void)visitBlock:(TOBlock*)obj {
	[self renameType:@"block" itemPath:obj.path];
}

-(void)visitOther:(TOOther*)obj {
	[self renameType:@"other" itemPath:obj.path];
}

-(void)visitProgressBefore:(TOProgressBefore*)obj {
	// do nothing
}

-(void)visitProgressAfter:(TOProgressAfter*)obj {
	// do nothing
}

@end
