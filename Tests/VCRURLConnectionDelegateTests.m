//
//  VCRURLConnectionDelegateTests.m
//  VCRURLConnection
//
//  Created by Dustin Barker on 12/29/13.
//
//

#import <XCTest/XCTest.h>
#import "VCRConnectionDelegate.h"
#import "VCRURLConnectionTestDelegate.h"

@interface VCRURLConnectionDelegateTests : XCTestCase
@property (nonatomic, strong) VCRRecording *recording;
@property (nonatomic, strong) VCRURLConnectionTestDelegate *innerDelegate;
@property (nonatomic, strong) VCRConnectionDelegate *outerDelegate;
@end

@implementation VCRURLConnectionDelegateTests

- (void)setUp {
    self.recording = [[VCRRecording alloc] init];
    self.innerDelegate = [[VCRURLConnectionTestDelegate alloc] init];
    self.outerDelegate = [[VCRConnectionDelegate alloc] initWithDelegate:self.innerDelegate recording:self.recording];
}

- (void)testConnectionDidReceiveResponse {
    XCTAssertTrue(!self.innerDelegate.response, @"");
    NSDictionary *headers = @{ @"X-Test-Key" : @"X-Test-Value" };
    NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:nil statusCode:0 HTTPVersion:@"HTTP/1.1" headerFields:headers];
    [self.outerDelegate connection:nil didReceiveResponse:response];
    
    // ensure headers are copied
    XCTAssertNotEqual(self.recording.headerFields, headers, @"");
    XCTAssertEqualObjects(self.recording.headerFields, headers, @"");
    
    // ensure response is forwarded
    XCTAssertEqual(self.innerDelegate.response, response, @"");
}

// - (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
// test that data is appended
// test that data is forwarded

// - (void)connectionDidFinishLoading:(NSURLConnection *)connection {
// test that recording is finalized
// test that call is forwarded

//- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
// test that error is stored
// test that error is forwarded

@end
