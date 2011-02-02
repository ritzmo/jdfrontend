//
//  PackagesXmlReader.m
//  JDFrontend
//
//  Created by Moritz Venn on 02.02.11.
//  Copyright 2011 Moritz Venn. All rights reserved.
//

#import "PackagesXmlReader.h"

#import "File.h"

static const char *kPackageElement = "packages";
static const NSUInteger kPackageElementLength = 8;
static const char *kPackageInProgress = "package_linksinprogress";
static const NSUInteger kPackageInProgressLength = 23;
static const char *kPackageLinksTotal = "package_linkstotal";
static const NSUInteger kPackageLinksTotalLength = 18;
static const char *kPackageLoaded = "package_loaded";
static const NSUInteger kPackageLoadedLength = 14;
static const char *kPackagePercent = "package_percent";
static const NSUInteger kPackagePercentLength = 15;
static const char *kPackageSize = "package_size";
static const NSUInteger kPackageSizeLength = 12;
static const char *kPackageSpeed = "package_speed";
static const NSUInteger kPackageSpeedLength = 13;
static const char *kPackageTodo = "package_todo";
static const NSUInteger kPackageTodoLength = 12;
static const char *kFileElement = "file";
static const NSUInteger kFileElementLength = 4;
static const char *kFileDownloaded = "file_downloaded";
static const NSUInteger kFileDownloadedLength = 15;
static const char *kFileHoster = "file_hoster";
static const NSUInteger kFileHosterLength = 11;
static const char *kFileName = "file_name";
static const NSUInteger kFileNameLength = 9;
static const char *kFilePercent = "file_percent";
static const NSUInteger kFilePercentLength = 12;
static const char *kFileSize = "files_size";
static const NSUInteger kFileSizeLength = 10;
static const char *kFileSpeed = "file_speed";
static const NSUInteger kFileSpeedLength = 10;
static const char *kFileStatus = "file_status";
static const NSUInteger kFileStatusLength = 11;

@interface PackagesXmlReader()
@property (nonatomic, retain) Package *current;
@end

@implementation PackagesXmlReader

@synthesize current;

- (void)dealloc
{
	[current release];

	[super dealloc];
}

- (void)elementFound:(const xmlChar *)localname prefix:(const xmlChar *)prefix uri:(const xmlChar *)URI namespaceCount:(int)namespaceCount namespaces:(const xmlChar **)namespaces attributeCount:(int)attributeCount defaultAttributeCount:(int)defaultAttributeCount attributes:(xmlSAX2Attributes *)attributes
{
    if(!strncmp((const char *)localname, kPackageElement, kPackageElementLength))
    {
		NSInteger i = 0;
        self.current = [[[Package alloc] init] autorelease];

		for(; i < attributeCount; ++i)
		{
			NSInteger valueLength = (int)(attributes[i].end - attributes[i].value);
			NSString *value = [[NSString alloc] initWithBytes:(const void *)attributes[i].value
													   length:valueLength
													 encoding:NSUTF8StringEncoding];
			if(!strncmp((const char*)attributes[i].localname, kPackageInProgress, kPackageInProgressLength))
			{
				current.inProgress = [value integerValue];
			}
			else if(!strncmp((const char*)attributes[i].localname, kPackageLinksTotal, kPackageLinksTotalLength))
			{
				current.total = [value integerValue];
				current.files = [NSMutableArray arrayWithCapacity:current.total];
			}
			else if(!strncmp((const char*)attributes[i].localname, kPackageLoaded, kPackageLoadedLength))
			{
				current.loaded = value;
			}
			else if(!strncmp((const char*)attributes[i].localname, kPackagePercent, kPackagePercentLength))
			{
				current.percent = [value floatValue];
			}
			else if(!strncmp((const char*)attributes[i].localname, kPackageSize, kPackageSizeLength))
			{
				current.size = value;
			}
			else if(!strncmp((const char*)attributes[i].localname, kPackageSpeed, kPackageSpeedLength))
			{
				current.speed = value;
			}
			else if(!strncmp((const char*)attributes[i].localname, kPackageTodo, kPackageTodoLength))
			{
				current.todo = value;
			}
			[value release];
		}
    }
    else if(!strncmp((const char *)localname, kFileElement, kFileElementLength))
	{
		NSInteger i = 0;
		File *file = [[File alloc] init];
		[current.files addObject:file];

		for(; i < attributeCount; ++i)
		{
			NSInteger valueLength = (int)(attributes[i].end - attributes[i].value);
			NSString *value = [[NSString alloc] initWithBytes:(const void *)attributes[i].value
													   length:valueLength
													 encoding:NSUTF8StringEncoding];
			if(!strncmp((const char*)attributes[i].localname, kFileDownloaded, kFileDownloadedLength))
			{
				file.downloaded = value;
			}
			else if(!strncmp((const char*)attributes[i].localname, kFileHoster, kFileHosterLength))
			{
				file.hoster = value;
			}
			else if(!strncmp((const char*)attributes[i].localname, kFileName, kFileNameLength))
			{
				file.name = value;
			}
			else if(!strncmp((const char*)attributes[i].localname, kFilePercent, kFilePercentLength))
			{
				file.percent = [value floatValue];
			}
			else if(!strncmp((const char*)attributes[i].localname, kFileSize, kFileSizeLength))
			{
				file.size = value;
			}
			else if(!strncmp((const char*)attributes[i].localname, kFileSpeed, kFileSpeedLength))
			{
				file.speed = value;
			}
			else if(!strncmp((const char*)attributes[i].localname, kFileStatus, kFileStatusLength))
			{
				file.status = value;
			}
			[value release];
		}
		[file release];
	}
}

- (void)endElement:(const xmlChar *)localname prefix:(const xmlChar *)prefix uri:(const xmlChar *)URI
{
	if(!strncmp((const char *)localname, kPackageElement, kPackageElementLength))
	{
		[_delegate performSelectorOnMainThread: @selector(addPackage:)
                                    withObject: current
                                 waitUntilDone: NO];
	}
}

@end
