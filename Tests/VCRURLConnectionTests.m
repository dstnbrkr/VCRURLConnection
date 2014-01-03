//
// VCRURLConnectionTests.m
//
// Copyright (c) 2012 Dustin Barker
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

#import "XCTestCase+VCR.h"
#import "XCTestCase+SRTAdditions.h"
#import "VCRURLConnectionTests.h"
#import "VCRCassetteManager.h"
#import "VCRCassette.h"
#import "VCR.h"


@interface NSHTTPURLResponse (VCRConnectionTests)
- (BOOL)VCR_isIsomorphic:(NSHTTPURLResponse *)response;
@end


@implementation NSHTTPURLResponse (VCRConnectionTests)

- (BOOL)VCR_isIsomorphic:(NSHTTPURLResponse *)response {
    return [self.URL isEqual:response.URL];
}

@end


@interface VCRURLConnectionTestDelegate : NSObject<NSURLConnectionDelegate>
@property (nonatomic, strong) NSHTTPURLResponse *response;
@property (nonatomic, strong) NSData *data;
@property (assign, getter = isDone) BOOL done;
@property (nonatomic, strong) NSError *error;
@end


@interface VCRURLConnectionTests ()
@property (nonatomic, strong) VCRCassette *cassette;
@end


@implementation VCRURLConnectionTests

- (void)setUp {
    [super setUp];
    [VCR start];
    self.cassette = [[VCRCassetteManager defaultManager] currentCassette];
}

- (void)tearDown {
    self.cassette = nil;
    [super tearDown];
}

- (void)testResponse_NSURLConnection_connectionWithRequest_delegate:(void (^)(NSURLRequest *request, VCRRecording *recording))assertionsBlock {

}

- (void)testResponseIsRecorded_NSURLConnection_connectionWithRequest_delegate {
    VCRURLConnectionTestDelegate *delegate = [[VCRURLConnectionTestDelegate alloc] init];
    [self recordRequestBlock:^(NSURLRequest *request) {
        [NSURLConnection connectionWithRequest:request delegate:delegate];
    } predicateBlock:^BOOL{
        return [delegate isDone];
    } assertionsBlock:^(NSURLRequest *request, VCRRecording *recording) {
        [self testRecording:recording forRequest:request];
    }];
}

- (void)testResponseIsDelegated {
    VCRURLConnectionTestDelegate *delegate = [[VCRURLConnectionTestDelegate alloc] init];
    [self recordRequestBlock:^(NSURLRequest *request) {
        [NSURLConnection connectionWithRequest:request delegate:delegate];
    } predicateBlock:^BOOL{
        return [delegate isDone];
    } assertionsBlock:^(NSURLRequest *request, VCRRecording *recording) {
        [self testDelegate:(id<VCRTestDelegate>)delegate forRecording:recording];
    }];
}

- (void)testAsyncGetRequestIsReplayed {
    id json = @[ @{ @"method": @"GET", @"uri": @"http://foo", @"body": @"Foo Bar Baz" } ];
    VCRCassette *cassette = [[VCRCassette alloc] initWithJSON:json];
    [[VCRCassetteManager defaultManager] setCurrentCassette:cassette];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://foo"]];
    
    // cassette has recording for request
    VCRRecording *recording = [cassette recordingForRequest:request];
    XCTAssertNotNil(recording, @"Should have recorded response");

    // make and playback request
    VCRURLConnectionTestDelegate *delegate = [[VCRURLConnectionTestDelegate alloc] init];
    [NSURLConnection connectionWithRequest:request delegate:delegate];

    // wait for request to finish
    [self runCurrentRunLoopUntilTestPasses:^BOOL{
        return [delegate isDone];
    } timeout:60 * 60];
    
    // delegate got response
    NSHTTPURLResponse *receivedResponse = delegate.response;
    XCTAssertNotNil(receivedResponse, @"Response should not be nil");
    
    // delegate got correct response
    NSHTTPURLResponse *httpResponse = [recording HTTPURLResponse];
    XCTAssertTrue([receivedResponse VCR_isIsomorphic:httpResponse],
                 @"Received response should be isomorphic to recorded response");
    
    NSData *receivedData = delegate.data;
    XCTAssertEqualObjects(receivedData, recording.data, @"Received data should equal recorded data");
}

// FIXME: test with enough data to fire connection:didReceiveData: times (test data appending)

// FIXME: can start and stop VCR

- (void)testAsyncGetRequestWithErrorIsReplayed {
    id json = @[ @{ @"method": @"get", @"uri": @"http://foo", @"status": @404 } ];
    VCRCassette *cassette = [[VCRCassette alloc] initWithJSON:json];
    [[VCRCassetteManager defaultManager] setCurrentCassette:cassette];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://example.com/foo"]];
    
    // make and playback request
    VCRURLConnectionTestDelegate *delegate = [[VCRURLConnectionTestDelegate alloc] init];
    [NSURLConnection connectionWithRequest:request delegate:delegate];
    
    // wait for request to finish
    [self runCurrentRunLoopUntilTestPasses:^BOOL{
        return [delegate isDone];
    } timeout:60 * 60];
    
    NSInteger expectedStatusCode = 404;
    XCTAssertEqual(delegate.response.statusCode, expectedStatusCode, @"Should get error status code");
}

- (void)testErrorIsRecorded {
    NSURL *url = [NSURL URLWithString:@"http://z/foo"]; // non-existant host
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    XCTAssertNil([self.cassette recordingForRequest:request], @"Should not have recording for request yet");

    VCRURLConnectionTestDelegate *delegate = [[VCRURLConnectionTestDelegate alloc] init];
    [NSURLConnection connectionWithRequest:request delegate:delegate];
    
    [self runCurrentRunLoopUntilTestPasses:^BOOL{
        return delegate.error != nil;
    } timeout:10];
    
    XCTAssertNotNil(delegate.error, @""); // make sure we got an error
    
    VCRCassette *cassette = [[VCRCassetteManager defaultManager] currentCassette];
    VCRRecording *recording = [cassette recordingForRequest:request];
    XCTAssertNotNil(recording.error, @"");
}

@end


@implementation VCRURLConnectionTestDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse *)response {
    self.response = response;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSMutableData *currentData = [NSMutableData dataWithData:self.data];
    [currentData appendData:data];
    self.data = currentData;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    _done = YES;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    _done = YES;
    _error = error;
}


@end
