//
//  PackageListController.m
//  JDFrontend
//
//  Created by Moritz Venn on 02.02.11.
//  Copyright 2011 Moritz Venn. All rights reserved.
//

#import "PackageListController.h"

#import "JDConnection.h"

#import "FileListController.h"
#import "PackageTableViewCell.h"

#define kPackageCellHeight 66

@implementation PackageListController

@synthesize fileListController;

- (id)init
{
	if((self = [super init]))
	{
		self.title = NSLocalizedString(@"Downloads", @"Title of Packages List");
		packages = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)dealloc
{
	if(fileListController.packageListController == self)
		fileListController.packageListController = nil;

	[fileListController release];
	[packages release];

	[super dealloc];
}

- (FileListController *)fileListController
{
	if(fileListController == nil)
	{
		fileListController = [[FileListController alloc] init];
		fileListController.packageListController = self;
	}
	return fileListController;
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

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	if(IS_IPHONE())
		[_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
	if(![packages count] && !_reloading)
		[self reloadData];
}

- (Package *)packageForPackageName:(NSString *)name
{
	for(Package *package in packages)
	{
		if([package.name isEqualToString:name])
			return package;
	}
	return nil;
}

/* trigger reload */
- (void)reloadData
{
	[_refreshHeaderView setTableLoadingWithinScrollView:_tableView];
	[self emptyData];
	[NSThread detachNewThreadSelector:@selector(fetchData) toTarget:self withObject:nil];
}

/* remove existing data */
- (void)emptyData
{
	[packages removeAllObjects];
	[_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
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
	NSIndexPath *indexPath = [_tableView indexPathForSelectedRow];
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
	[_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
	if(fileListController)
	{
		[fileListController dataSourceDelegateFinishedParsingDocument:dataSource];
	}

	// move selection back to visible area
	if(indexPath)
	{
		NSArray *visibleRows = [_tableView indexPathsForVisibleRows];
		if(![visibleRows containsObject:indexPath])
			[_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
	}
	// select first row on ipad if nothing selected
	else if(IS_IPAD() && [packages count])
	{
		[_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
		fileListController.package = [packages objectAtIndex:0];
	}
}

#pragma mark -
#pragma mark UITableView delegate methods
#pragma mark -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	self.fileListController.package = [packages objectAtIndex:indexPath.row];

	if(IS_IPHONE())
		[self.navigationController pushViewController:fileListController animated:YES];
}

/* cell for row */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	PackageTableViewCell *cell = nil;
	cell = (PackageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kPackageCell_ID];
	if(cell == nil)
		cell = [[[PackageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kPackageCell_ID] autorelease];
	cell.package = [packages objectAtIndex:indexPath.row];
	return cell;
}

/* number of rows */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [packages count];
}

@end
