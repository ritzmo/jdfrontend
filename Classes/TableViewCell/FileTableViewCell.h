//
//  FileTableViewCell.h
//  JDFrontend
//
//  Created by Moritz Venn on 02.02.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "File.h"

extern NSString *kFileCell_ID;

@interface FileTableViewCell : UITableViewCell
{
@private
	File *file;
	UIProgressView *progress;
	UILabel *nameLabel;
	UILabel *detailsLabel;
}

@property (nonatomic, retain) File *File;

@end
