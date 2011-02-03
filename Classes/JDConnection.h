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
}

+ (BOOL)loadConnections;
+ (void)saveConnections;
+ (JDConnection *)sharedInstance;

- (void)getPackages:(NSObject<DataSourceDelegate> *)delegate;

@end
