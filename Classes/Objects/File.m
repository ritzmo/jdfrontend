//
//  File.m
//  JDFrontend
//
//  Created by Moritz Venn on 02.02.11.
//  Copyright 2011 Moritz Venn. All rights reserved.
//

#import "File.h"

#import "Constants.h"

@implementation File

@synthesize downloaded, hoster, name, percent, size, speed, status;

- (BOOL)finished
{
	return (percent >= 100);
}

- (UIColor *)detailsColor
{
	// got status text
	if(status)
	{
		// File already exists, File loaded from <another hoster>, ...
		if([status rangeOfString:@"File "].location == 0)
			return kInformationColor;
		// > {Extract,CRC} OK (<algorithm>)
		else if([status rangeOfString:@" OK"].location != NSNotFound)
			return kSuccessColor;
		// > {Extract,CRC} failed (<algorithm>)
		else if([status rangeOfString:@" failed"].location != NSNotFound)
			return kFailureColor;
	}
	// completed file
	else if(percent >= 100)
		return kSuccessColor;
	// default
	return [UIColor blackColor];
}

- (void)setStatus:(NSString *)new
{
	if(status == new) return;

	[status release];
	if([new isEqualToString:@""]) status = nil;
	else status = [[new stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"] retain];
}

- (NSString *)humanReadableSpeed
{
	NSString *unit = nil;
	CGFloat localSpeed = (CGFloat)speed;
	if(speed == 0)
	{
		return NSLocalizedString(@"stalled", @"");
	}
	else if(speed < 1024)
	{
		unit = @"B/s";
	}
	else if(speed < 1048576)
	{
		localSpeed /= 1024;
		unit = @"KiB/s";
	}
	else
	{
		localSpeed /= 1048576;
		unit = @"MiB/s";
	}

	return [NSString stringWithFormat:@"%.2f %@", localSpeed, unit];
}

@end
