//
//  PackageListController.h
//  JDFrontend
//
//  Created by Moritz Venn on 02.02.11.
//  Copyright 2011 Moritz Venn. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ReloadableListController.h"
#import "DataSourceDelegate.h"

@interface PackageListController : ReloadableListController <UITableViewDelegate,
															UITableViewDataSource,
															DataSourceDelegate>
{
@private
	NSMutableArray *packages;
}

@end
