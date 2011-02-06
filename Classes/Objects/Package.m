//
//  Package.m
//  JDFrontend
//
//  Created by Moritz Venn on 02.02.11.
//  Copyright 2011 Moritz Venn. All rights reserved.
//

#import "Package.h"

#import "Constants.h"

@implementation Package

@synthesize eta, inProgress, total, files, loaded, name, percent, size, speed, todo;

- (BOOL)finished
{
	return (percent >= 100);
}

- (UIColor *)detailsColor
{
	if(self.finished)
		return kSuccessColor;
	return [UIColor blackColor];
}

- (void)setEta:(NSString *)new
{
	if(eta == new) return;

	[eta release];
	if([new isEqualToString:@"~"]) eta = nil;
	else eta = [new retain];
}

@end
