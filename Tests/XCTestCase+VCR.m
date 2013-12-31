//
//  VCRTestHelper.m
//  VCRURLConnection
//
//  Created by Dustin Barker on 12/30/13.
//
//

#import "XCTestCase+VCR.h"
#import "VCRCassette.h"
#import "VCRCassetteManager.h"
#import "XCTestCase+SRTAdditions.h"

@implementation XCTestCase (VCR)

- (void)testRecordResponseForRequestBlock:(void(^)(NSURLRequest *request))block predicateBlock:(BOOL(^)())predicateBlock {
    NSURL *url = [NSURL URLWithString:@"http://www.iana.org/domains/reserved"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    VCRCassette *cassette = [[VCRCassetteManager defaultManager] currentCassette];
    
    // request has not been recorded yet
    XCTAssertNil([cassette recordingForRequest:request], @"Should not have recording for request yet");
    
    block(request);
    
    // wait for request to finish
    [self runCurrentRunLoopUntilTestPasses:predicateBlock timeout:60];
    
    VCRRecording *recording = [cassette recordingForRequest:request];
    XCTAssertNotNil(recording, @"Should have recording");
    XCTAssertEqualObjects(recording.URI, [request.URL absoluteString], @"");
    XCTAssertNotNil(recording.data, @"Should have recorded response data");
    //XCTAssertEqualObjects(recording.data, delegate.data, @"Recorded data should equal recorded data");
}

@end
