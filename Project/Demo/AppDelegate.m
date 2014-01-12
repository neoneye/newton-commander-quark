//
//  AppDelegate.m
//  Demo
//
//  Created by Simon Strandgaard on 02/01/14.
//
//

#import "AppDelegate.h"
#include "re_pretty_print.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	// Insert code here to initialize your application
	
	NSWindow *w = self.window;
	NSView *v = w.contentView;

	NSRect r = NSInsetRect(v.bounds, 10, 10);
	NSTextView *tv = [[NSTextView alloc] initWithFrame:r];
	[v addSubview:tv];
	
	
	REPrettyPrint *pp = [[REPrettyPrint alloc] initWithPath:[@"~/Desktop" stringByExpandingTildeInPath]];
	[pp obtain];
	NSAttributedString *s = [pp result];
	
	[tv setEditable:YES];
	[tv insertText:s];
	[tv setEditable:NO];
	
}

@end
