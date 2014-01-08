//
// NCMoveVisitor.m
// Newton Commander
//

#import "NCMoveVisitor.h"
#import "NCLog.h"
#import "NCFileManager.h"

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

-(void)visitDirPre:(TODirPre*)obj {
	const char* target_path = [[self convert:[obj path]] fileSystemRepresentation];
	const char* source_path = [[obj path] fileSystemRepresentation];
	if(rename(source_path, target_path)) {
		[self setStatus:NCMoveVisitorStatusUnknownDir posixError:errno
				message:@"dir %s", target_path];
	}
}

-(void)visitDirPost:(TODirPost*)obj {
	// do nothing
}

-(void)visitFile:(TOFile*)obj {
	const char* target_path = [[self convert:[obj path]] fileSystemRepresentation];
	const char* source_path = [[obj path] fileSystemRepresentation];
	if(rename(source_path, target_path)) {
		[self setStatus:NCMoveVisitorStatusUnknownFile posixError:errno
				message:@"file %s", target_path];
	}
}

-(void)visitHardlink:(TOHardlink*)obj {
	const char* target_path = [[self convert:[obj path]] fileSystemRepresentation];
	const char* source_path = [[obj path] fileSystemRepresentation];
	if(rename(source_path, target_path)) {
		[self setStatus:NCMoveVisitorStatusUnknownHardlink posixError:errno
				message:@"hardlink %s", target_path];
	}
}

-(void)visitSymlink:(TOSymlink*)obj {
	const char* target_path = [[self convert:[obj path]] fileSystemRepresentation];
	const char* source_path = [[obj path] fileSystemRepresentation];
	if(rename(source_path, target_path)) {
		[self setStatus:NCMoveVisitorStatusUnknownSymlink posixError:errno
				message:@"symlink %s", target_path];
	}
}

-(void)visitFifo:(TOFifo*)obj {
	const char* target_path = [[self convert:[obj path]] fileSystemRepresentation];
	const char* source_path = [[obj path] fileSystemRepresentation];
	if(rename(source_path, target_path)) {
		[self setStatus:NCMoveVisitorStatusUnknownFifo posixError:errno
				message:@"fifo %s", target_path];
	}
}

-(void)visitChar:(TOChar*)obj {
	const char* target_path = [[self convert:[obj path]] fileSystemRepresentation];
	const char* source_path = [[obj path] fileSystemRepresentation];
	if(rename(source_path, target_path)) {
		[self setStatus:NCMoveVisitorStatusUnknownChar posixError:errno
				message:@"char %s", target_path];
	}
}

-(void)visitBlock:(TOBlock*)obj {
	const char* target_path = [[self convert:[obj path]] fileSystemRepresentation];
	const char* source_path = [[obj path] fileSystemRepresentation];
	if(rename(source_path, target_path)) {
		[self setStatus:NCMoveVisitorStatusUnknownBlock posixError:errno
				message:@"block %s", target_path];
	}
}

-(void)visitOther:(TOOther*)obj {
	// socket and whiteout is not something that we can copy
	const char* target_path = [[self convert:[obj path]] fileSystemRepresentation];
	const char* source_path = [[obj path] fileSystemRepresentation];
	[self setStatus:NCMoveVisitorStatusUnknownOther posixError:errno
			message:@"other %s", target_path];
}

-(void)visitProgressBefore:(TOProgressBefore*)obj {
	// do nothing
}

-(void)visitProgressAfter:(TOProgressAfter*)obj {
	// do nothing
}

@end
