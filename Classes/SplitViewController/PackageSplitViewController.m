//
//  PackageSplitViewController.m
//  JDFrontend
//
//  Created by Moritz Venn on 03.02.11.
//  Copyright 2011 Moritz Venn. All rights reserved.
//

#import "PackageSplitViewController.h"

#import "FileListController.h"

@implementation PackageSplitViewController

- (id)init
{
	if((self = [super init]))
	{
		self.tabBarItem.title = NSLocalizedString(@"Downloads", @"Title of Packages List");
		// TODO: add tab bar image
	}
	return self;
}

- (void)dealloc
{
	plc.fileListController = nil;
	[plc release];

	[super dealloc];
}

- (void)loadView
{
	[super loadView];

	plc = [[PackageListController alloc] init];
	FileListController *flc = [[FileListController alloc] init];

	flc.packageListController = plc;
	plc.fileListController = flc;

	UINavigationController *nav1, *nav2;
	nav1 = [[UINavigationController alloc] initWithRootViewController:plc];
	nav2 = [[UINavigationController alloc] initWithRootViewController:flc];

	self.viewControllers = [NSArray arrayWithObjects:nav1, nav2, nil];
	self.delegate = flc;

	[flc release];
	[nav1 release];
	[nav2 release];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[plc reloadData];
}

@end
