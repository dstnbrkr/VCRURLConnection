//
//  XCTestCase+VCR.m
//  VCRURLConnection
//
//  Created by Dustin Barker on 1/2/14.
//
//

#import "XCTestCase+VCR.h"
#import "XCTestCase+SRTAdditions.h"
#import "VCRCassetteManager.h"
#import "VCRCassette.h"
#import "VCRRecording.h"

@implementation XCTestCase (VCR)

- (void)recordRequest:(NSURLRequest *)request
         requestBlock:(void(^)())requestBlock
       predicateBlock:(BOOL(^)())predicateBlock
           completion:(void(^)(VCRRecording *recording))completion {
    
    // request has not been recorded yet
    VCRCassette *cassette = [[VCRCassetteManager defaultManager] currentCassette];
    XCTAssertNil([cassette recordingForRequest:request], @"Should not have recording for request yet");
    
    // make and record request
    requestBlock(request);
    
    // wait for request to finish
    [self runCurrentRunLoopUntilTestPasses:predicateBlock timeout:60 * 60];
    
    VCRRecording *recording = [[[VCRCassetteManager defaultManager] currentCassette] recordingForRequest:request];
    completion(recording);
}

- (void)testRecording:(VCRRecording *)recording forRequest:(NSURLRequest *)request {
    XCTAssertNotNil(recording, @"Should have recording");
    XCTAssertEqualObjects(recording.method, request.HTTPMethod);
    XCTAssertEqualObjects(recording.URI, [request.URL absoluteString], @"");
    XCTAssertNotNil(recording.data, @"Should have recorded response data");
}

- (void)testDelegate:(id<VCRTestDelegate>)delegate forRecording:(VCRRecording *)recording {
    XCTAssertNotNil(delegate.response, @"Response should not be nil");
    XCTAssertEqualObjects(delegate.data, recording.data, @"Recorded data should equal recorded data");
    XCTAssertEqualObjects(delegate.response.URL, [recording HTTPURLResponse].URL, @"");
    XCTAssertEqualObjects(delegate.data, recording.data, @"Received data should equal recorded data");
    XCTAssertEqual(delegate.response.statusCode, recording.statusCode, @"");
}

- (void)replayJSON:(id)json
      requestBlock:(void(^)(NSURLRequest *request))requestBlock
    predicateBlock:(BOOL(^)())predicateBlock
        completion:(void(^)(VCRRecording *))completion {

    VCRCassette *cassette = [[VCRCassette alloc] initWithJSON:@[ json ]];
    [[VCRCassetteManager defaultManager] setCurrentCassette:cassette];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:json[@"uri"]]];
    
    // cassette has recording for request
    VCRRecording *recording = [cassette recordingForRequest:request];
    XCTAssertNotNil(recording, @"Should have recorded response");
    
    requestBlock(request);
    
    // wait for request to finish
    [self runCurrentRunLoopUntilTestPasses:predicateBlock timeout:60 * 60];
    
    completion(recording);
}

@end
