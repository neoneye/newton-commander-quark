//
// NCMoveVisitor.m
// Newton Commander
//

#import "NCMoveVisitor.h"
#import "NCLog.h"

@implementation NCMoveVisitor

-(NSString*)convert:(NSString*)path {
	if([path hasPrefix:_sourcePath]) {
		NSString* s = [path substringFromIndex:[_sourcePath length]];
		return [_targetPath stringByAppendingString:s];
	}
	return path;
}

//-(void)setStatus:(NSUInteger)status posixError:(int)error_code message:(NSString*)message, ... {
//	va_list ap;
//	va_start(ap,message);
//	NSString* message2 = [[NSString alloc] initWithFormat:message arguments:ap];
//	va_end(ap);
//	
//	NSString* error_text = [NCFileManager errnoString:error_code];
//	NSString* status_message = [NSString stringWithFormat:@"ERROR status: %i\nposix-code: %@\nmessage: %@", (int)status, error_text, message2];
//	LOG_ERROR(@"%@", status_message);
//	
//	m_status_code = status;
//	self.statusMessage = status_message;
//}
//

-(void)visitDirPre:(TODirPre*)obj {
	const char* target_path = [[self convert:[obj path]] fileSystemRepresentation];
	const char* source_path = [[obj path] fileSystemRepresentation];
	if(rename(source_path, target_path)) {
		LOG_ERROR(@"could not move dir %@ -> %@", source_path, target_path);
//		if(errno == EEXIST) {
//			[self setStatus:kCopierStatusExist posixError:errno
//					message:@"mkdir %s", target_path];
//			return;
//		}
//		[self setStatus:kCopierStatusUnknownDir posixError:errno
//				message:@"mkdir %s", target_path];
	}
}

-(void)visitDirPost:(TODirPost*)obj {
	// do nothing
}

-(void)visitFile:(TOFile*)obj {
	const char* target_path = [[self convert:[obj path]] fileSystemRepresentation];
	const char* source_path = [[obj path] fileSystemRepresentation];
	if(rename(source_path, target_path)) {
		LOG_ERROR(@"could not move file %@ -> %@", source_path, target_path);
		//		if(errno == EEXIST) {
		//			[self setStatus:kCopierStatusExist posixError:errno
		//					message:@"mkdir %s", target_path];
		//			return;
		//		}
		//		[self setStatus:kCopierStatusUnknownDir posixError:errno
		//				message:@"mkdir %s", target_path];
	}
}

-(void)visitHardlink:(TOHardlink*)obj {
	const char* target_path = [[self convert:[obj path]] fileSystemRepresentation];
	const char* source_path = [[obj path] fileSystemRepresentation];
	if(rename(source_path, target_path)) {
		LOG_ERROR(@"could not move hardlink %@ -> %@", source_path, target_path);
		//		if(errno == EEXIST) {
		//			[self setStatus:kCopierStatusExist posixError:errno
		//					message:@"mkdir %s", target_path];
		//			return;
		//		}
		//		[self setStatus:kCopierStatusUnknownDir posixError:errno
		//				message:@"mkdir %s", target_path];
	}
}

-(void)visitSymlink:(TOSymlink*)obj {
	const char* target_path = [[self convert:[obj path]] fileSystemRepresentation];
	const char* source_path = [[obj path] fileSystemRepresentation];
	if(rename(source_path, target_path)) {
		LOG_ERROR(@"could not move symlink %@ -> %@", source_path, target_path);
		//		if(errno == EEXIST) {
		//			[self setStatus:kCopierStatusExist posixError:errno
		//					message:@"mkdir %s", target_path];
		//			return;
		//		}
		//		[self setStatus:kCopierStatusUnknownDir posixError:errno
		//				message:@"mkdir %s", target_path];
	}
}

-(void)visitFifo:(TOFifo*)obj {
	const char* target_path = [[self convert:[obj path]] fileSystemRepresentation];
	const char* source_path = [[obj path] fileSystemRepresentation];
	if(rename(source_path, target_path)) {
		LOG_ERROR(@"could not move symlink %@ -> %@", source_path, target_path);
		//		if(errno == EEXIST) {
		//			[self setStatus:kCopierStatusExist posixError:errno
		//					message:@"mkdir %s", target_path];
		//			return;
		//		}
		//		[self setStatus:kCopierStatusUnknownDir posixError:errno
		//				message:@"mkdir %s", target_path];
	}
}

-(void)visitChar:(TOChar*)obj {
	const char* target_path = [[self convert:[obj path]] fileSystemRepresentation];
	const char* source_path = [[obj path] fileSystemRepresentation];
	if(rename(source_path, target_path)) {
		LOG_ERROR(@"could not move char-device %@ -> %@", source_path, target_path);
		//		if(errno == EEXIST) {
		//			[self setStatus:kCopierStatusExist posixError:errno
		//					message:@"mkdir %s", target_path];
		//			return;
		//		}
		//		[self setStatus:kCopierStatusUnknownDir posixError:errno
		//				message:@"mkdir %s", target_path];
	}
}

-(void)visitBlock:(TOBlock*)obj {
	const char* target_path = [[self convert:[obj path]] fileSystemRepresentation];
	const char* source_path = [[obj path] fileSystemRepresentation];
	if(rename(source_path, target_path)) {
		LOG_ERROR(@"could not move block-device %@ -> %@", source_path, target_path);
		//		if(errno == EEXIST) {
		//			[self setStatus:kCopierStatusExist posixError:errno
		//					message:@"mkdir %s", target_path];
		//			return;
		//		}
		//		[self setStatus:kCopierStatusUnknownDir posixError:errno
		//				message:@"mkdir %s", target_path];
	}
}

-(void)visitOther:(TOOther*)obj {
	// socket and whiteout is not something that we can copy
	const char* target_path = [[self convert:[obj path]] fileSystemRepresentation];
	const char* source_path = [[obj path] fileSystemRepresentation];
	LOG_ERROR(@"don't know how to move other %@ -> %@", source_path, target_path);
//	[self setStatus:kCopierStatusUnknownOther posixError:0
//			message:@"Unknown file-type at path %@", s];
}

-(void)visitProgressBefore:(TOProgressBefore*)obj {
	// do nothing
}

-(void)visitProgressAfter:(TOProgressAfter*)obj {
	// do nothing
}

@end
