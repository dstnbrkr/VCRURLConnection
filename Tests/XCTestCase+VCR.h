//
//  VCRTestHelper.h
//  VCRURLConnection
//
//  Created by Dustin Barker on 12/30/13.
//
//

#import <XCTest/XCTest.h>
#import "VCRTestDelegate.h"

@interface XCTestCase (VCR)

- (void)testRecordResponseForRequestBlock:(id<VCRTestDelegate> (^)(NSURLRequest *request))block;

@end
