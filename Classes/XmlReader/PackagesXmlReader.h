//
//  PackagesXmlReader.h
//  JDFrontend
//
//  Created by Moritz Venn on 02.02.11.
//  Copyright 2011 Moritz Venn. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SaxXmlReader.h"
#import "Package.h"

@interface PackagesXmlReader : SaxXmlReader
{
@private
	Package *current; /*!< @brief Current Package. */
}

@end
