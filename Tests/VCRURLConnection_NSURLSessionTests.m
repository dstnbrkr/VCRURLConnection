//
//  VCRURLConnection_NSURLSessionTests.m
//  VCRURLConnection
//
//  Created by Dustin Barker on 12/27/13.
//
//

#import <XCTest/XCTest.h>
#import "XCTestCase+SRTAdditions.h"
#import "VCRCassetteManager.h"
#import "VCR.h"

@interface VCRURLConnection_NSURLSessionTests : XCTestCase

@end

@implementation VCRURLConnection_NSURLSessionTests

- (void)setUp
{
    [super setUp];
    [VCR start];
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (NSURLSession *)defaultSession
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    return session;
}

- (void)testRecords
{
/*
    NSURL *url = [NSURL URLWithString:@"http://www.iana.org/domains/reserved"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    VCRCassette *cassette = [[VCRCassetteManager defaultManager] currentCassette];
    XCTAssertNil([cassette recordingForRequest:request], @"Should not have recording yet");

    __block BOOL completed = NO;
    NSURLSession *session = [self defaultSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                completed = YES;
                                            }];
    [task resume];
    
    [self runCurrentRunLoopUntilTestPasses:^BOOL{
        return completed;
    } timeout:10];
    
    XCTAssertNotNil([cassette recordingForRequest:request], @"Should have recording now");
*/
}

@end
