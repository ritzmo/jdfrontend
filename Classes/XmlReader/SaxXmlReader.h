//
//  SaxXmlReader.h
//  JDFrontend
//
//  Created by Moritz Venn on 15.01.11.
//  Copyright 2011 Moritz Venn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <libxml/tree.h>

#import "DataSourceDelegate.h"

typedef struct
{
	const xmlChar* localname;
	const xmlChar* prefix;
	const xmlChar* uri;
	const xmlChar* value;
	const xmlChar* end;
} xmlSAX2Attributes;

/*!
 @brief Protocol for streaming readers
 */
@protocol StreamingReader
/*!
 @brief Element has begun.

 @param localname the local name of the element
 @param prefix the element namespace prefix if available
 @param uri the element namespace name if available
 @param namespaceCount number of namespace definitions on that node
 @param namespaces pointer to the array of prefix/URI pairs namespace definitions
 @param attributeCount the number of attributes on that node
 @param defaultAttributeCount the number of defaulted attributes.
 @param attributes pointer to the array of (localname/prefix/URI/value/end) attribute values.
 */
- (void)elementFound:(const xmlChar *)localname prefix:(const xmlChar *)prefix uri:(const xmlChar *)URI namespaceCount:(int)namespaceCount namespaces:(const xmlChar **)namespaces attributeCount:(int)attributeCount defaultAttributeCount:(int)defaultAttributeCount attributes:(xmlSAX2Attributes *)attributes;

/*!
 @brief Element has ended.

 @param localname the local name of the element
 @param prefix the element namespace prefix if available
 @param uri the element namespace name if available
 */
- (void)endElement:(const xmlChar *)localname prefix:(const xmlChar *)prefix uri:(const xmlChar *)URI;

/*!
 @brief Send fake object back to delegate to indicate a failure
 */
- (void)sendErroneousObject;
@end

/*!
 @brief SAX XML Reader.
 */
@interface SaxXmlReader : NSObject <StreamingReader>
{
@private
	NSError *failureReason; /*!< @brief Reason for parsing failure. */
	xmlParserCtxtPtr _xmlParserContext; /*!< @brief Parser context of libxml2. */
@protected
	NSMutableString *currentString; /*!< @brief String that is currently being completed. */
    BOOL _done; /*!< @brief Finished parsing? */
    NSObject<DataSourceDelegate> *_delegate; /*!< @brief Delegate. */
    NSTimeInterval _timeout; /*!< @brief Timeout for requests. */
}

/*
 @brief Standard initializer.

 @param delegate Delegate.
 @return SaxXmlParser instance
 */
- (id)initWithDelegate:(NSObject<DataSourceDelegate> *)delegate;

/*
 @brief Download and parse XML document.
 
 @param URL URL to download.
 @param error Will be pointed to NSError if one occurs.
 @return YES if error occured.
 */
- (BOOL)parseXMLFileAtURL: (NSURL *)URL parseError: (NSError **)error;

/*!
 @brief Currently received string.
 */
@property (nonatomic, retain) NSMutableString *currentString;

@end
