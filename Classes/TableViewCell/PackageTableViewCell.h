//
//  PackageTableViewCell.h
//  JDFrontend
//
//  Created by Moritz Venn on 02.02.11.
//  Copyright 2011 Moritz Venn. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Package.h"

extern NSString *kPackageCell_ID;

@interface PackageTableViewCell : UITableViewCell
{
@private
	Package *package;
	UIProgressView *progress;
	UILabel *nameLabel;
	UILabel *detailsLabel;
}

@property (nonatomic, retain) Package *package;

@end
