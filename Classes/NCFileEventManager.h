//
// NCFileEventManager.h
// Newton Commander
//
#import <Foundation/Foundation.h>

// NCFileEventManagerPrivate is defined in the implementation file
typedef struct NCFileEventManagerPrivate NCFileEventManagerPrivate;


@class NCFileEventManager;

@protocol NCFileEventManagerDelegate <NSObject>
@required
-(void)fileEventManager:(NCFileEventManager*)fileEventManager changeOccured:(NSArray*)ary;
@end

@interface NCFileEventManager : NSObject 
-(void)setDelegate:(NSObject <NCFileEventManagerDelegate> *)delegate;

-(void)start;
-(void)stop;

-(void)notify:(NSArray*)ary;

-(void)setPathsToWatch:(NSArray*)paths;
@end
