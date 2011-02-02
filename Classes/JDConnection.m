//
//  JDConnection.m
//  JDFrontend
//
//  Created by Moritz Venn on 02.02.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JDConnection.h"

#import "PackagesXmlReader.h"

static JDConnection *this = nil;

@interface JDConnection()
@property (nonatomic, retain) NSURL *baseURL;
@end

@implementation JDConnection

@synthesize baseURL;

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
		// TODO: force connect
		baseURL = [[NSURL alloc] initWithString:@"http://moritz-venns-macbook-pro:10025"];
	}
	return baseURL;
}

- (void)getPackages:(NSObject<DataSourceDelegate> *)delegate
{
	NSURL *myURI = [[NSURL alloc] initWithString:@"/get/downloads/all/list" relativeToURL:self.baseURL];
	SaxXmlReader *xmlReader = [[PackagesXmlReader alloc] initWithDelegate:delegate];
	[xmlReader parseXMLFileAtURL:myURI parseError:nil];
	[xmlReader release];
}

@end
