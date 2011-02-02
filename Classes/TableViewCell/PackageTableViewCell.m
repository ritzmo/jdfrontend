//
//  PackageTableViewCell.m
//  JDFrontend
//
//  Created by Moritz Venn on 02.02.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PackageTableViewCell.h"

NSString *kPackageCell_ID = @"PackageCell_ID";

@interface PackageTableViewCell()
- (UILabel *)newLabelWithPrimaryColor:(UIColor *) primaryColor selectedColor:(UIColor *) selectedColor fontSize:(CGFloat) fontSize bold:(BOOL) bold;
@end

#define kPackageCellNameSize 14
#define kLeftMargin 5
#define kRightMargin 5
#define kTopMargin 5
#define kBottomMargin 5

@implementation PackageTableViewCell

@synthesize package;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	if((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
	{
		const UIView *contentView = self.contentView;
		
		nameLabel = [self newLabelWithPrimaryColor:[UIColor blackColor]
									 selectedColor:[UIColor whiteColor]
										  fontSize:kPackageCellNameSize
											  bold:YES];
		detailsLabel = [self newLabelWithPrimaryColor:[UIColor blackColor]
									 selectedColor:[UIColor whiteColor]
										  fontSize:kPackageCellNameSize
											  bold:YES];
		progress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];

		[contentView addSubview:nameLabel];
		[contentView addSubview:detailsLabel];
		[contentView addSubview:progress];

		self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	return self;
}

- (void)setPackage:(Package *)new
{
	if(package == new) return;

	[package release];
	package = [new retain];

	nameLabel.text = package.name;
	progress.progress = package.percent;
	detailsLabel.text = nil;

	[self setNeedsLayout];
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	const CGRect contentRect = self.contentView.bounds;
	CGRect frame = CGRectMake(contentRect.origin.x + kLeftMargin, kTopMargin, contentRect.size.width - kLeftMargin - kRightMargin, kPackageCellNameSize + 3);
	nameLabel.frame = frame;

	// FIXME: progress height appears to be fixed, so find it out instead of using evil voodoo
	frame.origin.y += frame.size.height + 5;
	frame.size.height = contentRect.size.height - (kTopMargin + kBottomMargin + frame.size.height + kPackageCellNameSize + 3);
	progress.frame = frame;
	
	frame.origin.y += frame.size.height + 5;
	frame.size.height = kPackageCellNameSize + 3;
	detailsLabel.frame = frame;
}

- (UILabel *)newLabelWithPrimaryColor:(UIColor *) primaryColor selectedColor:(UIColor *) selectedColor fontSize:(CGFloat) fontSize bold:(BOOL) bold
{
    UIFont *font;
    UILabel *newLabel;
	
    if (bold) {
        font = [UIFont boldSystemFontOfSize:fontSize];
    } else {
        font = [UIFont systemFontOfSize:fontSize];
    }
	
    newLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    newLabel.backgroundColor = [UIColor clearColor];
    newLabel.opaque = NO;
    newLabel.textColor = primaryColor;
    newLabel.highlightedTextColor = selectedColor;
    newLabel.font = font;
	
    return newLabel;
}					 
					 
@end
