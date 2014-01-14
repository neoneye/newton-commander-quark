/*********************************************************************
NCInspectFile.h - obtain detailed info about a file/dir/...

Copyright (c) 2009 - opcoders.com
Simon Strandgaard <simon@opcoders.com>
*********************************************************************/

@interface NCInspectFile : NSObject

-(id)initWithPath:(NSString*)path;

-(void)obtain;

-(NSAttributedString*)result;

@end
