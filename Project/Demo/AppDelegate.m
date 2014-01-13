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
	NSWindow *w = self.window;
	NSView *v = w.contentView;
	
	// Setting up the scroll view
	NSScrollView *scrollview = [[NSScrollView alloc] initWithFrame:[v frame]];
	NSSize contentSize = [scrollview contentSize];
	[scrollview setBorderType:NSNoBorder];
	[scrollview setHasVerticalScroller:YES];
	[scrollview setHasHorizontalScroller:NO];
	[scrollview setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
	
	// Setting up the text view
	NSTextView *theTextView = [[NSTextView alloc] initWithFrame:NSMakeRect(0, 0, contentSize.width, contentSize.height)];
	[theTextView setMinSize:NSMakeSize(0.0, contentSize.height)];
	[theTextView setMaxSize:NSMakeSize(FLT_MAX, FLT_MAX)];
	[theTextView setVerticallyResizable:YES];
	[theTextView setHorizontallyResizable:NO];
	[theTextView setAutoresizingMask:NSViewWidthSizable];
	[[theTextView textContainer] setContainerSize:NSMakeSize(contentSize.width, FLT_MAX)];
	[[theTextView textContainer] setWidthTracksTextView:YES];

	// Assembling the pieces
	[scrollview setDocumentView:theTextView];
	[w setContentView:scrollview];
	[w makeKeyAndOrderFront:nil];
	[w makeFirstResponder:theTextView];

	NSTextView *tv = theTextView;
	
	REPrettyPrint *pp = [[REPrettyPrint alloc] initWithPath:[@"~/Desktop" stringByExpandingTildeInPath]];
	[pp obtain];
	NSAttributedString *s = [pp result];
	
	[tv setEditable:YES];
	[tv insertText:s];
	[tv setEditable:NO];
}

@end
