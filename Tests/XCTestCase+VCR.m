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

- (void)recordRequestBlock:(void(^)(NSURLRequest *request))requestBlock
            predicateBlock:(BOOL(^)())predicateBlock
           assertionsBlock:(void(^)(NSURLRequest *request, VCRRecording *recording))assertionsBlock {
    
    NSURL *url = [NSURL URLWithString:@"http://www.iana.org/domains/reserved"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // request has not been recorded yet
    VCRCassette *cassette = [[VCRCassetteManager defaultManager] currentCassette];
    XCTAssertNil([cassette recordingForRequest:request], @"Should not have recording for request yet");
    
    // make and record request
    requestBlock(request);
    
    // wait for request to finish
    [self runCurrentRunLoopUntilTestPasses:predicateBlock timeout:60 * 60];
    
    VCRRecording *recording = [[[VCRCassetteManager defaultManager] currentCassette] recordingForRequest:request];
    assertionsBlock(request, recording);
}

- (void)testRecording:(VCRRecording *)recording forRequest:(NSURLRequest *)request {
    XCTAssertNotNil(recording, @"Should have recording");
    XCTAssertEqualObjects(recording.method, request.HTTPMethod);
    XCTAssertEqualObjects(recording.URI, [request.URL absoluteString], @"");
    XCTAssertNotNil(recording.data, @"Should have recorded response data");
}

- (void)testDelegate:(id<VCRTestDelegate>)delegate forRecording:(VCRRecording *)recording {
    XCTAssertEqualObjects(recording.data, delegate.data, @"Recorded data should equal recorded data");
}

@end
