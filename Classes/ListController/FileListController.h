//
//  FileListController.h
//  JDFrontend
//
//  Created by Moritz Venn on 02.02.11.
//  Copyright 2011 Moritz Venn. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DataSourceDelegate.h"
#import "MGSplitViewController.h" /* MGSplitViewControllerDelegate */
#import "ReloadableListController.h"

@class Package;
@class PackageListController;

@interface FileListController : ReloadableListController <UITableViewDelegate,
														UITableViewDataSource,
														DataSourceDelegate,
														MGSplitViewControllerDelegate>
{
@private
	Package *package;
	PackageListController *packageListController;
	UIPopoverController *popoverController;
}

@property (nonatomic, retain) Package *package;
@property (nonatomic, retain) PackageListController *packageListController;

@end
