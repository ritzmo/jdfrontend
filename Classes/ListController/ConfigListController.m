//
//  ConfigListController.m
//  JDFrontend
//
//  Created by Moritz Venn on 09.03.08.
//  Copyright 2008-2011 Moritz Venn. All rights reserved.
//

#import "ConfigListController.h"

#import "JDConnection.h"
#import "Constants.h"

//#import "ConfigViewController.h"

@implementation ConfigListController

/* initialize */
- (id)init
{
	if((self = [super init]))
	{
		self.title = NSLocalizedString(@"Configuration", @"Default Title of ConfigListController");
	}
	return self;
}

/* dealloc */
- (void)dealloc
{
	[super dealloc];
}

/* layout */
- (void)loadView
{
	UITableView *tableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] style:UITableViewStyleGrouped];
	tableView.delegate = self;
	tableView.dataSource = self;
	//tableView.rowHeight = 48.0;
	//tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;

	// setup our content view so that it auto-rotates along with the UViewController
	tableView.autoresizesSubviews = YES;
	tableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);

	self.view = tableView;
	[tableView release];

	// add edit button
	self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

/* (un)set editing */
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
	[super setEditing: editing animated: animated];

	// Animate if requested
	if(animated)
	{
		if(editing)
		{
			[(UITableView*)self.view insertRowsAtIndexPaths: [NSArray arrayWithObject:
											[NSIndexPath indexPathForRow:0 inSection:0]]
							withRowAnimation: UITableViewRowAnimationFade];
		}
		else
		{
			[(UITableView*)self.view deleteRowsAtIndexPaths: [NSArray arrayWithObject:
											[NSIndexPath indexPathForRow:0 inSection:0]]
							withRowAnimation: UITableViewRowAnimationFade];
		}
	}
	else
	{
		[(UITableView*)self.view reloadData];
	}
	[(UITableView*)self.view setEditing: editing animated: animated];
}

#pragma mark	-
#pragma mark		Table View
#pragma mark	-

/* select row */
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	// Only do something in section 0
	if(indexPath.section != 0)
		return nil;
	const NSArray *connections = [JDConnection getConnections];

	// NOTE: has been an issue in previous versions of another app, so keep this for now
	if([connections count] <= indexPath.row)
	{
		NSLog(@"ERROR: about to select out of bounds, aborting...");
		return nil;
	}

	// Open ConfigViewController for selected item
	//UIViewController *targetViewController = [ConfigViewController withConnection: [connections objectAtIndex: indexPath.row]: indexPath.row];
	//[self.navigationController pushViewController: targetViewController animated: YES];

	return indexPath;
}

/* indent when editing? */
- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
	// Only indent section 0
	return (indexPath.section == 0);
}

/* determine which UITableViewCell to be used on a given row. */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	const NSInteger section = indexPath.section;
	NSInteger row = indexPath.row;
	UITableViewCell *sourceCell = nil;
	
	// we are creating a new cell, setup its attributes
	switch(section)
	{
		/* Connections */
		case 0:
		{
			sourceCell = [tableView dequeueReusableCellWithIdentifier: kVanilla_ID];
			if(sourceCell == nil) 
				sourceCell = [[[UITableViewCell alloc] initWithFrame: CGRectZero reuseIdentifier: kVanilla_ID] autorelease];

			sourceCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			sourceCell.textLabel.font = [UIFont boldSystemFontOfSize:kTextViewFontSize-1];

			/*!
			 @brief When editing we add a fake first item to the list so cover this here.
			 */
			if(self.editing)
			{
				// Setup fake item and abort
				if(row == 0)
				{
					sourceCell.imageView.image = nil;
					sourceCell.textLabel.text = NSLocalizedString(@"New Connection", @"");
					break;
				}

				// Fix index in list
				row--;
			}

			// Set image for cell
			if([[NSUserDefaults standardUserDefaults] integerForKey: kActiveConnection] == row)
				sourceCell.imageView.image = [UIImage imageNamed:@"emblem-favorite.png"];
			else if([JDConnection getConnectedId] == row)
				sourceCell.imageView.image = [UIImage imageNamed:@"network-wired.png"];
			else
				sourceCell.imageView.image = nil;

			// Set title
			sourceCell.textLabel.text = [[JDConnection getConnections] objectAtIndex:row];

			break;
		}
		default:
			break;
	}

	return sourceCell;
}

/* number of section */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
	return 1;
}

/* number of rows in given section */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	switch(section)
	{
		case 0:
		{
			const NSUInteger cnt = [[JDConnection getConnections] count];
			if(self.editing)
				return cnt + 1;
			return cnt;
		}
		default:
			return 0;
	}
}

/* section header */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if(section == 0)
		return NSLocalizedString(@"Configured Connections", @"");
	return nil;
}

/* rotate with device */
- (BOOL)shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

/* editing style */
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	// Only custom style in section 0
	if(indexPath.section != 0)
		return UITableViewCellEditingStyleNone;

	// First row is fake "new connection" item
	if(indexPath.row == 0)
		return UITableViewCellEditingStyleInsert;
	return UITableViewCellEditingStyleDelete;
}

/* edit action */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	// If row is deleted, remove it from the list.
	if (editingStyle == UITableViewCellEditingStyleDelete)
	{
		NSUserDefaults *stdDefaults = [NSUserDefaults standardUserDefaults];
		NSInteger currentDefault = [stdDefaults integerForKey: kActiveConnection];
		NSInteger currentConnected = [JDConnection getConnectedId];
		NSInteger index = indexPath.row;
		if(self.editing) --index;

		// Shift index
		if(currentDefault > index)
			[stdDefaults setObject: [NSNumber numberWithInteger: currentDefault - 1] forKey: kActiveConnection];
		// Default to 0 if current default connection removed
		else if(currentDefault == index)
		{
			[stdDefaults setObject: [NSNumber numberWithInteger: 0] forKey: kActiveConnection];
			[JDConnection disconnect];
			[tableView reloadData];
		}
		// connected is removed
		if(currentConnected == index && currentConnected != currentDefault)
		{
			[JDConnection disconnect];
			[tableView reloadData];
		}

		// Remove item
		const NSMutableArray *connections = [JDConnection getConnections];
		[connections removeObjectAtIndex: index];
		[tableView deleteRowsAtIndexPaths: [NSArray arrayWithObject: indexPath]
						 withRowAnimation: UITableViewRowAnimationFade];
	}
	// Add new connection
	else if(editingStyle == UITableViewCellEditingStyleInsert)
	{
		//UIViewController *targetViewController = [ConfigViewController newConnection];
		//[self.navigationController pushViewController: targetViewController animated: YES];
		//[targetViewController release];
	}
}

#pragma mark - UIViewController delegate methods

/* about to appear */
- (void)viewWillAppear:(BOOL)animated
{
	// this UIViewController is about to re-appear, make sure we remove the current selection in our table view
	NSIndexPath *tableSelection = [(UITableView *)self.view indexPathForSelectedRow];
	[(UITableView *)self.view reloadData];
	[(UITableView *)self.view selectRowAtIndexPath:tableSelection animated:NO scrollPosition:UITableViewScrollPositionNone];
	[(UITableView *)self.view deselectRowAtIndexPath:tableSelection animated:YES];
}

/* about to hide */
- (void)viewWillDisappear:(BOOL)animated
{
	if(self.editing)
		[self setEditing: NO animated: YES];
}

@end
