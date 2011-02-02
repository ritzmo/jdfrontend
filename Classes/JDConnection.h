//
//  JDConnection.h
//  JDFrontend
//
//  Created by Moritz Venn on 02.02.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DataSourceDelegate.h"

@interface JDConnection : NSObject {
@private
	NSURL *baseURL;
}

+ (JDConnection *)sharedInstance;

- (void)getPackages:(NSObject<DataSourceDelegate> *)delegate;

@end
