//
//  File.h
//  JDFrontend
//
//  Created by Moritz Venn on 02.02.11.
//  Copyright 2011 Moritz Venn. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface File : NSObject
{
@private
	NSString *downloaded;
	NSString *hoster;
	NSString *name;
	CGFloat percent;
	NSString *size;
	NSInteger speed;
	NSString *status;
}

- (NSString *)humanReadableSpeed;

@property (nonatomic, readonly) BOOL finished;
@property (nonatomic, retain) NSString *downloaded;
@property (nonatomic, retain) NSString *hoster;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, assign) CGFloat percent;
@property (nonatomic, retain) NSString *size;
@property (nonatomic, assign) NSInteger speed;
@property (nonatomic, retain) NSString *status;

@end
