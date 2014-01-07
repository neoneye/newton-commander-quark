//
// NSArray+ExtractTopLevelTraversalObjects.m
// Newton Commander
//

#import "NSArray+ExtractTopLevelTraversalObjects.h"
#import "sc_traversal_objects.h"

@implementation NSArray (ExtractTopLevelTraversalObjects)

-(NSArray*)extractTopLevelTraversalObjects {
	NSMutableArray *result = [NSMutableArray new];
	NSInteger depth = 0;
	for (NSObject *obj in self) {
		if ([obj isKindOfClass:TODirPost.class]) depth--;
		if (depth == 0) [result addObject:obj];
		if ([obj isKindOfClass:TODirPre.class]) depth++;
	}
	return result.copy;
}

@end
