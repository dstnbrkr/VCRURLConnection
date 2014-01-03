//
//  VCR_NSURLSessionTests.m
//  VCRURLConnection
//
//  Created by Dustin Barker on 1/3/14.
//
//

#import <XCTest/XCTest.h>
#import "XCTestCase+VCR.h"
#import "VCR.h"

@interface VCR_NSURLSessionTests : XCTestCase

@end

@implementation VCR_NSURLSessionTests

- (void)setUp
{
    [super setUp];
    [VCR start];
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

@end
