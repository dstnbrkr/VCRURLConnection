//
//  VCRURLSessionDelegateTests.m
//  VCRURLConnection
//
//  Created by Dustin Barker on 12/30/13.
//
//

#import <Availability.h>
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 50000 || __MAC_OS_X_VERSION_MIN_REQUIRED >= 1090

#import <XCTest/XCTest.h>
#import "VCRURLSessionDelegate.h"
#import "VCRURLSessionTestDelegate.h"
#import "VCRRecording.h"

@interface VCRURLSessionDelegateTests : XCTestCase
@property (nonatomic, strong) VCRRecording *recording;
@property (nonatomic, strong) VCRURLSessionTestDelegate *innerDelegate;
@property (nonatomic, strong) VCRURLSessionDelegate *outerDelegate;
@end

@implementation VCRURLSessionDelegateTests

- (void)setUp
{
    [super setUp];
    VCRRecording *recording = [[VCRRecording alloc] init];
    recording.method =
    recording.URI = @"http://example.com";
    self.recording = recording;
    self.innerDelegate = [[VCRURLSessionTestDelegate alloc] init];
    self.outerDelegate = [[VCRURLSessionDelegate alloc] initWithDelegate:self.innerDelegate recording:self.recording];
}

- (void)testSessionDidReceiveResponse {
    XCTAssertTrue(!self.innerDelegate.response, @"");
    NSDictionary *headers = @{ @"X-Test-Key" : @"X-Test-Value" };
    NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:nil statusCode:0 HTTPVersion:@"HTTP/1.1" headerFields:headers];
    [self.outerDelegate URLSession:nil dataTask:nil didReceiveResponse:response completionHandler:nil];
    
    // ensure headers are copied
    XCTAssertNotEqual(self.recording.headerFields, headers, @"");
    XCTAssertEqualObjects(self.recording.headerFields, headers, @"");
    
    // ensure response is forwarded
    XCTAssertEqual(self.innerDelegate.response, response, @"Expected connection:didReceiveResponse: to be forwarded to inner delegate");
}

- (void)testSessionDidReceiveData {
    XCTAssertTrue(!self.innerDelegate.data, @"");
    const char bytes[] = { 0xC, 0xA, 0xF, 0xE };
    NSMutableData *data = [NSMutableData dataWithBytes:&bytes length:4];
    [self.outerDelegate URLSession:nil dataTask:nil didReceiveData:data];
    
    // ensure data is copied
    XCTAssertNotEqual(self.recording.data, data, @"");
    XCTAssertEqualObjects(self.recording.data, data, @"");
    
    // ensure response is forwarded
    XCTAssertEqualObjects(self.innerDelegate.data, data, @"Expected connection:didReceiveData: to be forwarded to inner delegate");
}

@end

#endif


