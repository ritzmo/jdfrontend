//
//  NSDate+RoughDistance.h
//  JDFrontend
//
//  Created by Moritz Venn on 02.02.11.
//  Copyright 2011 Moritz Venn. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDate(RoughDistance)

/*!
 @brief Request a fuzzy distance.
 */
- (NSString *)roughDistance;

@end
