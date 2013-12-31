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

@interface VCRMockDataTask : NSURLSessionDataTask
@property (nonatomic, strong, readwrite) NSURLRequest *currentRequest;
@end

@interface VCRURLSessionDelegateTests : XCTestCase
@property (nonatomic, strong) VCRMockDataTask *task;
@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, strong) VCRURLSessionTestDelegate *innerDelegate;
@property (nonatomic, strong) VCRURLSessionDelegate *outerDelegate;
@property (nonatomic, strong) VCRRecording *recording;
@end

@implementation VCRURLSessionDelegateTests

- (void)setUp
{
    [super setUp];
    self.request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://foo.com"]];
    self.task = [[VCRMockDataTask alloc] init];
    self.task.currentRequest = self.request;
    self.innerDelegate = [[VCRURLSessionTestDelegate alloc] init];
    self.outerDelegate = [[VCRURLSessionDelegate alloc] initWithDelegate:self.innerDelegate];
    self.recording = [self.outerDelegate recordingForRequest:self.request];
}

- (void)testSessionDidReceiveResponse {
    XCTAssertTrue(!self.innerDelegate.response, @"");
    
    // set up response
    NSDictionary *headers = @{ @"X-Test-Key" : @"X-Test-Value" };
    NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:nil statusCode:0 HTTPVersion:@"HTTP/1.1" headerFields:headers];

    [self.outerDelegate URLSession:nil dataTask:self.task didReceiveResponse:response completionHandler:^(NSURLSessionResponseDisposition disposition) {
        // do nothing
    }];
    
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
    [self.outerDelegate URLSession:nil dataTask:self.task didReceiveData:data];
    
    // ensure data is copiedu
    XCTAssertNotEqual(self.recording.data, data, @"");
    XCTAssertEqualObjects(self.recording.data, data, @"");
    
    // ensure response is forwarded
    XCTAssertEqualObjects(self.innerDelegate.data, data, @"Expected connection:didReceiveData: to be forwarded to inner delegate");
}

- (void)testSessionDidCompleteWithError {
    XCTAssertNil(self.recording.error, @"Should not have error yet");
    NSError *error = [[NSError alloc] initWithDomain:@"VCR" code:0 userInfo:nil];
    [self.outerDelegate URLSession:nil task:self.task didCompleteWithError:error];
    XCTAssertEqualObjects(self.recording.error, error, @"");
}

@end

@implementation VCRMockDataTask
@end

#endif


