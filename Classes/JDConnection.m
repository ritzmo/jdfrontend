//
//  JDConnection.m
//  JDFrontend
//
//  Created by Moritz Venn on 02.02.11.
//  Copyright 2011 Moritz Venn. All rights reserved.
//

#import "JDConnection.h"

#import "Constants.h"
#import "PackagesXmlReader.h"
#import "SynchronousRequestReader.h"

static JDConnection *this = nil;
static NSMutableArray *connections = nil;
#define configPath @"~/Library/Preferences/de.ritzMo.JDFrontend.Connections.plist"

@interface JDConnection()
@property (nonatomic, retain) NSURL *baseURL;
@property (nonatomic, retain) NSString *currentString;
@property (assign) NSInteger rcRevision;
@end

@implementation JDConnection

@synthesize baseURL, currentString, rcRevision;

+ (BOOL)connectTo:(NSUInteger)idx
{
	if(!this || !connections || idx >= [connections count])
		return NO;

	NSString *newURL = [connections objectAtIndex:idx];
	this.currentString = newURL;
	if([newURL rangeOfString:@"http"].location == 0)
	{
		// ":" after http(s):
		if([newURL rangeOfString:@":" options:NSBackwardsSearch].location > 5)
			this.baseURL = [NSURL URLWithString:newURL];
		else
			this.baseURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@:10025", newURL]];
	}
	else
	{
		// ":" in url
		if([newURL rangeOfString:@":" options:NSBackwardsSearch].location != NSNotFound)
			this.baseURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", newURL]];
		else
			this.baseURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:10025", newURL]];
	}
	this.rcRevision = -1;

	return YES;
}

+ (void)disconnect
{
	this.baseURL = nil;
}

+ (NSInteger)getConnectedId
{
	const NSUInteger index = [connections indexOfObject: this.currentString];
	if(index == NSNotFound)
		return [[NSUserDefaults standardUserDefaults]
				integerForKey: kActiveConnection];
	return index;
}

+ (NSMutableArray *)getConnections
{
	if(connections == nil)
		[JDConnection loadConnections];
	return connections;
}

+ (BOOL)loadConnections
{
	NSString *finalPath = [configPath stringByExpandingTildeInPath];
    BOOL retVal = YES;

    if(connections)
    {
        [connections release];
    }
    connections = [[NSMutableArray arrayWithContentsOfFile:finalPath] retain];

    if(connections == nil)
    {
        connections = [[NSMutableArray alloc] init];
        retVal = NO;
    }
    return retVal;
}

+ (void)saveConnections
{
	NSString *finalPath = [configPath stringByExpandingTildeInPath];
    [connections writeToFile:finalPath atomically:YES];
}

+ (BOOL)isConnected
{
	return (this.baseURL != nil);
}

+ (JDConnection *)sharedInstance
{
	if(this == nil)
		this = [[JDConnection alloc] init];
	return this;
}

- (void)dealloc
{
	[baseURL release];
	[currentString release];
	[this release];
	this = nil;

	[super dealloc];
}

- (NSURL *)baseURL
{
	if(baseURL == nil)
	{
		@synchronized(self)
		{
			if(baseURL == nil)
			{
				if(![JDConnection connectTo:[[NSUserDefaults standardUserDefaults] integerForKey: kActiveConnection]])
				{
					return nil;
				}
			}
		}
	}
	return baseURL;
}

- (NSInteger)rcRevision
{
	if(rcRevision == -1)
	{
		@synchronized(self)
		{
			if(rcRevision != -1) return rcRevision;

			NSError *error = nil;
			NSURL *myURI = [[NSURL alloc] initWithString:@"/get/rcversion" relativeToURL:self.baseURL];
			NSData *data = [SynchronousRequestReader sendSynchronousRequest:myURI returningResponse:nil error:&error];
			[myURI release];
			if(error == nil)
			{
				NSString *myString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
				rcRevision = [myString integerValue];
				[myString release];
			}
		}
	}
	return rcRevision;
}

- (BOOL)getPackages:(NSObject<DataSourceDelegate> *)delegate
{
	if(!self.baseURL)
	{
		[self performSelectorOnMainThread:@selector(showAlert) withObject:nil waitUntilDone:NO];
		return NO;
	}

	NSString *relativeURL = nil;
	if(self.rcRevision > 10696)
		relativeURL = @"/get/downloads/all/list";
	else
		relativeURL = @"/get/downloads/alllist";

	NSURL *myURI = [[NSURL alloc] initWithString:relativeURL relativeToURL:self.baseURL];
	SaxXmlReader *xmlReader = [[PackagesXmlReader alloc] initWithDelegate:delegate];
	[xmlReader parseXMLFileAtURL:myURI parseError:nil];
	[xmlReader release];
	[myURI release];
	return YES;
}

- (void)showAlert
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

	const UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Unable to connect to remote host", @"")
														  message:nil
														 delegate:nil
												cancelButtonTitle:@"OK"
												otherButtonTitles:nil];
	[alert show];
	[alert release];

	[pool release];
}

@end
