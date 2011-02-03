//
//  JDConnection.m
//  JDFrontend
//
//  Created by Moritz Venn on 02.02.11.
//  Copyright 2011 Moritz Venn. All rights reserved.
//

#import "JDConnection.h"

#import "PackagesXmlReader.h"

static JDConnection *this = nil;
static NSMutableArray *connections = nil;
#define configPath @"~/Library/Preferences/de.ritzMo.JDFrontend.Connections.plist"

@interface JDConnection()
@property (nonatomic, retain) NSURL *baseURL;
@end

@implementation JDConnection

@synthesize baseURL;

+ (BOOL)connectTo:(NSUInteger)idx
{
	if(!this || !connections || idx >= [connections count])
		return NO;

	NSString *newURL = [connections objectAtIndex:idx];
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
		if([newURL rangeOfString:@":" options:NSBackwardsSearch].location > 0)
			this.baseURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", newURL]];
		else
			this.baseURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@:10025", newURL]];
	}
	return YES;
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

+ (JDConnection *)sharedInstance
{
	if(this == nil)
		this = [[JDConnection alloc] init];
	return this;
}

- (void)dealloc
{
	[baseURL release];
	[this release];
	this = nil;

	[super dealloc];
}

- (NSURL *)baseURL
{
	if(baseURL == nil)
	{
		// TODO: implement selecting default connection
		if(![JDConnection connectTo:0])
		{
			// TODO: yield warning
			// FIXME: until this is properly implemented, hardcode my laptop
			baseURL = [[NSURL alloc] initWithString:@"http://moritz-venns-macbook-pro:10025"];
		}
	}
	return baseURL;
}

- (void)getPackages:(NSObject<DataSourceDelegate> *)delegate
{
	NSURL *myURI = [[NSURL alloc] initWithString:@"/get/downloads/all/list" relativeToURL:self.baseURL];
	SaxXmlReader *xmlReader = [[PackagesXmlReader alloc] initWithDelegate:delegate];
	[xmlReader parseXMLFileAtURL:myURI parseError:nil];
	[xmlReader release];
	[myURI release];
}

@end
