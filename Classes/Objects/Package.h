//
//  Package.h
//  JDFrontend
//
//  Created by Moritz Venn on 02.02.11.
//  Copyright 2011 Moritz Venn. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Package : NSObject {
@private
	NSInteger inProgress;
	NSInteger total;
	NSMutableArray *files;
	NSString *loaded;
	NSString *name;
	CGFloat percent;
	NSString *size;
	NSString *speed;
	NSString *todo;
}

@property (nonatomic, readonly) BOOL finished;
@property (nonatomic, assign) NSInteger inProgress;
@property (nonatomic, assign) NSInteger total;
@property (nonatomic, retain) NSMutableArray *files;
@property (nonatomic, retain) NSString *loaded;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, assign) CGFloat percent;
@property (nonatomic, retain) NSString *size;
@property (nonatomic, retain) NSString *speed;
@property (nonatomic, retain) NSString *todo;

@end
