//
//  Package.m
//  JDFrontend
//
//  Created by Moritz Venn on 02.02.11.
//  Copyright 2011 Moritz Venn. All rights reserved.
//

#import "Package.h"


@implementation Package

@synthesize inProgress, total, files, loaded, name, percent, size, speed, todo;

- (BOOL)finished
{
	return (percent >= 100);
}

@end
