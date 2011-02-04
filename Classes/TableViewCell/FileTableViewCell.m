//
//  FileTableViewCell.m
//  JDFrontend
//
//  Created by Moritz Venn on 02.02.11.
//  Copyright 2011 Moritz Venn. All rights reserved.
//

#import "FileTableViewCell.h"

NSString *kFileCell_ID = @"FileCell_ID";

@interface FileTableViewCell()
- (UILabel *)newLabelWithPrimaryColor:(UIColor *) primaryColor selectedColor:(UIColor *) selectedColor fontSize:(CGFloat) fontSize bold:(BOOL) bold;
@end

#define kFileCellNameSize 14
#define kLeftMargin 5
#define kRightMargin 5
#define kTopMargin 5
#define kBottomMargin 5

@implementation FileTableViewCell

@synthesize File;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	if((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
	{
		const UIView *contentView = self.contentView;
		
		nameLabel = [self newLabelWithPrimaryColor:[UIColor blackColor]
									 selectedColor:[UIColor whiteColor]
										  fontSize:kFileCellNameSize
											  bold:YES];
		detailsLabel = [self newLabelWithPrimaryColor:[UIColor blackColor]
									 selectedColor:[UIColor whiteColor]
										  fontSize:kFileCellNameSize
											  bold:YES];
		progress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];

		[contentView addSubview:nameLabel];
		[contentView addSubview:detailsLabel];
		[contentView addSubview:progress];

		self.accessoryType = UITableViewCellAccessoryNone;
	}
	return self;
}

- (void)setFile:(File *)new
{
	if(file == new) return;

	[file release];
	file = [new retain];

	nameLabel.text = file.name;
	progress.progress = file.percent/100.0f;

	detailsLabel.textColor = file.detailsColor;
	if(file.status)
	{
		if(IS_IPAD() && file.percent > 0 && file.percent < 100)
			detailsLabel.text = [NSString stringWithFormat:@"%.2f%% of %@, %@", file.percent, file.size, file.status];
		else
			detailsLabel.text = file.status;
	}
	else if(file.percent >= 100 || !file.speed)
	{
		detailsLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%.2f%% of %@", @""), file.percent, file.size];
	}
	else
	{
		detailsLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%.2f%% of %@ @ %@", @""), file.percent, file.size, [file humanReadableSpeed]];
	}

	[self setNeedsLayout];
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	const CGRect contentRect = self.contentView.bounds;
	CGRect frame = CGRectMake(contentRect.origin.x + kLeftMargin, kTopMargin, contentRect.size.width - kLeftMargin - kRightMargin, kFileCellNameSize + 3);
	nameLabel.frame = frame;

	// FIXME: progress height appears to be fixed, so find it out instead of using evil voodoo
	frame.origin.y += frame.size.height + 5;
	frame.size.height = 10;
	progress.frame = frame;
	
	frame.origin.y += frame.size.height + 5;
	frame.size.height = kFileCellNameSize + 3;
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
