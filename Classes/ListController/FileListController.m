//
//  FileListController.m
//  JDFrontend
//
//  Created by Moritz Venn on 02.02.11.
//  Copyright 2011 Moritz Venn. All rights reserved.
//

#import "FileListController.h"

#import "JDConnection.h"

#import "FileTableViewCell.h"
#import "Package.h"
#import "PackageListController.h"

#define kFileCellHeight 65

@interface FileListController()
@property (nonatomic, retain) UIPopoverController *popoverController;
@end

@implementation FileListController

@synthesize package, packageListController, popoverController;

- (id)init
{
	if((self = [super init]))
	{
		self.title = NSLocalizedString(@"Files", @"Default Title of File List");
	}
	return self;
}

- (void)dealloc
{
	if(packageListController.fileListController == self)
		packageListController.fileListController = nil;

	[package release];
	[packageListController release];
	[popoverController release];

	[super dealloc];
}

- (void)setPackage:(Package *)new
{
	if(new == package) return;

	[package release];
	package = [new retain];

	if(popoverController)
	{
		[popoverController dismissPopoverAnimated:YES];
	}

	[_tableView reloadData];
}

/* layout */
- (void)loadView
{
	[super loadView];

	_tableView.delegate = self;
	_tableView.dataSource = self;
	_tableView.sectionHeaderHeight = 0;
	_tableView.rowHeight = kFileCellHeight;
}

/* fetch packages */
- (void)fetchData
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[packageListController reloadData];
	[pool release];
}

#pragma mark -
#pragma mark DataSourceDelegate methods
#pragma mark -

- (void)dataSourceDelegate:(SaxXmlReader *)dataSource errorParsingDocument:(NSError *)error
{
	// parent will yield warning
	self.package = nil;
}

- (void)dataSourceDelegateFinishedParsingDocument:(SaxXmlReader *)dataSource
{
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
	self.package = [packageListController packageForPackageName:package.name];
}

#pragma mark -
#pragma mark UITableView delegate methods
#pragma mark -

/* cell for row */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	FileTableViewCell *cell = (FileTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kFileCell_ID];
	if(cell == nil)
		cell = [[FileTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kFileCell_ID];
	cell.file = [package.files objectAtIndex:indexPath.row];
	return cell;
}

/* number of rows */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return package.total;
}

/* row selected */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	// TODO: add functionality
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark Split view support
#pragma mark -

- (void)splitViewController:(MGSplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController: (UIPopoverController*)pc
{
    barButtonItem.title = aViewController.title;
    self.navigationItem.leftBarButtonItem = barButtonItem;
    self.popoverController = pc;
}

// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void)splitViewController:(MGSplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    self.navigationItem.leftBarButtonItem = nil;
    self.popoverController = nil;
}

@end
