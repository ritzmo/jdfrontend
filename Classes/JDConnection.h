//
//  JDConnection.h
//  JDFrontend
//
//  Created by Moritz Venn on 02.02.11.
//  Copyright 2011 Moritz Venn. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DataSourceDelegate.h"

@interface JDConnection : NSObject {
@private
	NSURL *baseURL;
	NSString *currentString;
}

+ (BOOL)connectTo:(NSUInteger)idx;
+ (void)disconnect;
+ (NSInteger)getConnectedId;
+ (NSMutableArray *)getConnections;
+ (BOOL)loadConnections;
+ (void)saveConnections;
+ (JDConnection *)sharedInstance;

- (void)getPackages:(NSObject<DataSourceDelegate> *)delegate;

@end
