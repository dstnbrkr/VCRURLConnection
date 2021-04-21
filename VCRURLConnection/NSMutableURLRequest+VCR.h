//
//  NSMutableURLRequest+VCR.h
//  VCRURLConnection
//
//  Created by Mike Akers on 4/20/21.
//

#import <Foundation/Foundation.h>


@interface NSURLRequest (CustomHTTPBody)
/**
 *   Unfortunately, when sending POST requests (with a body) using NSURLSession,
 *   by the time the request arrives at OHHTTPStubs, the HTTPBody of the
 *   NSURLRequest has been reset to nil.
 *
 *   You can use this method to retrieve the HTTPBody for testing and use it to
 *   conditionally stub your requests.
 */
- (NSData *)OHHTTPStubs_HTTPBody;
@end
