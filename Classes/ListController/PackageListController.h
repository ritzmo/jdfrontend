//
//  PackageListController.h
//  JDFrontend
//
//  Created by Moritz Venn on 02.02.11.
//  Copyright 2011 Moritz Venn. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DataSourceDelegate.h"
#import "ReloadableListController.h"

@class FileListController;
@class Package;

@interface PackageListController : ReloadableListController <UITableViewDelegate,
															UITableViewDataSource,
															DataSourceDelegate>
{
@private
	NSMutableArray *packages;
	FileListController *fileListController;
}

- (void)reloadData;
- (Package *)packageForPackageName:(NSString *)name;

@property (nonatomic, retain) FileListController *fileListController;

@end
