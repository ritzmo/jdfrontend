//
//  FileListController.h
//  JDFrontend
//
//  Created by Moritz Venn on 02.02.11.
//  Copyright 2011 Moritz Venn. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DataSourceDelegate.h"
#import "ReloadableListController.h"

@class Package;
@class PackageListController;

@interface FileListController : ReloadableListController <UITableViewDelegate,
															UITableViewDataSource,
															DataSourceDelegate>
{
@private
	Package *package;
	PackageListController *packageListController;
}

@property (nonatomic, retain) Package *package;
@property (nonatomic, retain) PackageListController *packageListController;

@end
