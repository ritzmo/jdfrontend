//
//  PackageSplitViewController.h
//  JDFrontend
//
//  Created by Moritz Venn on 03.02.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MGSplitViewController.h"
#import "PackageListController.h"

@interface PackageSplitViewController : MGSplitViewController
{
@private
	PackageListController *plc;
}

@end
