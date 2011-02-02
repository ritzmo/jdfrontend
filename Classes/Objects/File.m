//
//  File.m
//  JDFrontend
//
//  Created by Moritz Venn on 02.02.11.
//  Copyright 2011 Moritz Venn. All rights reserved.
//

#import "File.h"


@implementation File

@synthesize downloaded, hoster, name, percent, size, speed, status;

- (BOOL)finished
{
	return (percent >= 100);
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
