//
//  PackageListController.m
//  JDFrontend
//
//  Created by Moritz Venn on 02.02.11.
//  Copyright 2011 Moritz Venn. All rights reserved.
//

#import "PackageListController.h"

#import "JDConnection.h"

#import "Package.h"
#import "PackageTableViewCell.h"

#define kPackageCellHeight 65

@implementation PackageListController

- (id)init
{
	if((self = [super init]))
	{
		self.title = NSLocalizedString(@"Packages", @"Title of Packages List");
		packages = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)dealloc
{
	[packages release];

	[super dealloc];
}

/* layout */
- (void)loadView
{
	[super loadView];

	_tableView.delegate = self;
	_tableView.dataSource = self;
	_tableView.sectionHeaderHeight = 0;
	_tableView.rowHeight = kPackageCellHeight;
}

/* fetch packages */
- (void)fetchData
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	_reloading = YES;
	[[JDConnection sharedInstance] getPackages:self];
	[pool release];
}

#pragma mark -
#pragma mark PackageXmlReader
#pragma mark -

- (void)addPackage:(Package *)package
{
	const NSInteger idx = packages.count;
	[packages addObject:package];
	[_tableView insertRowsAtIndexPaths: [NSArray arrayWithObject: [NSIndexPath indexPathForRow:idx inSection:0]]
					  withRowAnimation: UITableViewRowAnimationLeft];
}

#pragma mark -
#pragma mark DataSourceDelegate methods
#pragma mark -

- (void)dataSourceDelegateFinishedParsingDocument:(SaxXmlReader *)dataSource
{
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
	[_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
	// if nothing selected, select first item
}

#pragma mark -
#pragma mark UITableView delegate methods
#pragma mark -

/* cell for row */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	PackageTableViewCell *cell = nil;
	cell = (PackageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kPackageCell_ID];
	if(cell == nil)
		cell = [[PackageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kPackageCell_ID];
	cell.package = [packages objectAtIndex:indexPath.row];
	return cell;
}

/* number of rows */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [packages count];
}

@end
