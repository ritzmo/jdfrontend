//
//  NSDate+RoughDistance.m
//  JDFrontend
//
//  Created by Moritz Venn on 02.02.11.
//  Copyright 2011 Moritz Venn. All rights reserved.
//

#import "NSDate+RoughDistance.h"

@implementation NSDate(RoughDistance)

- (NSString *)roughDistance
{
	NSDate *now = [[NSDate alloc] init];
	NSTimeInterval interval = [self timeIntervalSinceDate:now];
	[now release];
	const BOOL wasNeg = (interval < 0);
	NSString *unit = nil;
	interval = fabs(interval);
	if(interval == 0)
	{
		return NSLocalizedString(@"Now", @"");
	}
	else if(interval < 60)
	{
		if(interval > 1)
			unit = NSLocalizedString(@"seconds", @"");
		else
			unit = NSLocalizedString(@"second", @"");
	}
	else if(interval < 3600)
	{
		interval /= 60;
		if(interval > 1)
			unit = NSLocalizedString(@"minutes", @"");
		else
			unit = NSLocalizedString(@"minute", @"");
	}
	else if(interval < 86400)
	{
		interval /= 3600;
		if(interval > 1)
			unit = NSLocalizedString(@"hours", @"");
		else
			unit = NSLocalizedString(@"hour", @"");
	}
	else if(interval < 604800)
	{
		interval /= 86400;
		if(interval > 1)
			unit = NSLocalizedString(@"days", @"");
		else
			unit = NSLocalizedString(@"day", @"");
	}
	else if(interval < 2592000)
	{
		interval /= 604800;
		if(interval > 1)
			unit = NSLocalizedString(@"weeks", @"");
		else
			unit = NSLocalizedString(@"week", @"");
	}
	else if(interval < 31557600)
	{
		interval /= 2592000;
		if(interval > 1)
			unit = NSLocalizedString(@"months", @"");
		else
			unit = NSLocalizedString(@"month", @"");
	}
	else
	{
		interval /= 31557600;
		if(interval > 1)
			unit = NSLocalizedString(@"years", @"");
		else
			unit = NSLocalizedString(@"year", @"");
	}

	if(wasNeg)
		return [NSString stringWithFormat:NSLocalizedString(@"%d %@ ago", @""), (int)interval, unit];
	return [NSString stringWithFormat:NSLocalizedString(@"in %d %@", @""), (int)interval, unit];
}

@end