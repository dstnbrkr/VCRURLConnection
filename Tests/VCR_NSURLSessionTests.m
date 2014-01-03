//
// VCR_NSURLSessionTests.m
//
// Copyright (c) 2013 Dustin Barker
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Availability.h>
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000 || __MAC_OS_X_VERSION_MAX_ALLOWED >= 1090

#import <XCTest/XCTest.h>
#import "XCTestCase+VCR.h"
#import "VCR.h"
#import "VCRCassetteManager.h"

@interface VCR_NSURLSessionTests : XCTestCase

@end

@implementation VCR_NSURLSessionTests

- (void)setUp
{
    [super setUp];
    [VCR start];
    [[VCRCassetteManager defaultManager] setCurrentCassette:nil];
}

- (void)testResponseIsRecorded {
    NSURL *url = [NSURL URLWithString:@"http://www.iana.org/domains/reserved"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    __block BOOL completed = NO;
    __block NSData *receivedData;
    __block NSHTTPURLResponse *httpResponse;
    [self recordRequest:request requestBlock:^{
        NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                                     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                                         completed = YES;
                                                                         receivedData = data;
                                                                         httpResponse = (NSHTTPURLResponse *)response;
                                                                     }];
        [task resume];
    } predicateBlock:^BOOL{
        return completed;
    } completion:^(VCRRecording *recording) {
        XCTAssertEqual(recording.statusCode, httpResponse.statusCode, @"");
        XCTAssertEqualObjects(recording.data, receivedData, @"");
        
        [self testRecording:recording forRequest:request];
    }];
}

- (void)testResponseIsReplayed {
    id json = @{ @"method": @"GET", @"uri": @"http://foo", @"body": @"Foo Bar Baz" };
    __block BOOL completed = NO;
    __block NSData *receivedData;
    __block NSHTTPURLResponse *httpResponse;
    [self replayJSON:json requestBlock:^(NSURLRequest *request) {
        NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                                     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                                         completed = YES;
                                                                         receivedData = data;
                                                                         httpResponse = (NSHTTPURLResponse *)response;
                                                                     }];
        [task resume];
    } predicateBlock:^BOOL{
        return completed;
    } completion:^(VCRRecording *recording) {
        XCTAssertEqual(httpResponse.statusCode, recording.statusCode, @"");
        XCTAssertEqualObjects(receivedData, recording.data, @"");
    }];
}

@end

#endif
