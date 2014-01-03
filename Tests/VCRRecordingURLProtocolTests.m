//
//  VCRRecordingURLProtocolTests.m
//  VCRURLConnection
//
//  Created by Dustin Barker on 1/2/14.
//
//

#import <XCTest/XCTest.h>
#import "VCRRecordingURLProtocol.h"

@interface VCRRecordingURLProtocolTests : XCTestCase

@end

@implementation VCRRecordingURLProtocolTests

- (void)testCanInitWithHTTPRequest
{
    NSURL *url = [NSURL URLWithString:@"http://www.example.com"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    XCTAssert([[VCRRecordingURLProtocol class] canInitWithRequest:request], @"");
}

- (void)testCanInitWithHTTPSRequest
{
    NSURL *url = [NSURL URLWithString:@"https://www.example.com"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    XCTAssert([[VCRRecordingURLProtocol class] canInitWithRequest:request], @"");
}

- (void)testCannotInitWithNonHTTPRequest
{
    NSURL *url = [NSURL URLWithString:@"foo://www.example.com"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    XCTAssert(![[VCRRecordingURLProtocol class] canInitWithRequest:request], @"");
}

// make request
// vcrrecordingurlprotocol intercepts, makes new request
// make identical request
// vcrrecordingurlprotocol ignores second request

// if a request is being recorded


@end
