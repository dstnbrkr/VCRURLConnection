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

#import "SenTestCase+SRTAdditions.h"
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
@property (nonatomic, retain) NSHTTPURLResponse *response;
@property (nonatomic, retain) NSData *data;
@property (assign, getter = isDone) BOOL done;
@property (assign, getter = isError) BOOL error;
@end


@interface VCRURLConnectionTests ()
@property (nonatomic, retain) VCRCassette *cassette;
@property (nonatomic, retain) VCRURLConnectionTestDelegate *testDelegate;
@end


@implementation VCRURLConnectionTests

- (void)setUp {
    [super setUp];
    [VCR start];
    self.cassette = [[VCRCassetteManager defaultManager] currentCassette];
    self.testDelegate = [[[VCRURLConnectionTestDelegate alloc] init] autorelease];
}

- (void)tearDown {
    self.cassette = nil;
    self.testDelegate = nil;
    [super tearDown];
}
/*
- (void)testAsyncConnectionIsRecorded {
    NSURL *url = [NSURL URLWithString:@"http://www.iana.org/domains/example/"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // request has not been recorded yet
    STAssertNil([self.cassette recordingForRequest:request], @"Should not have recording for request yet");
    
    // make and record request
    [NSURLConnection connectionWithRequest:request delegate:self.testDelegate];
    
    // wait for request to finish
    [self runCurrentRunLoopUntilTestPasses:^BOOL{
        return [self.testDelegate isDone];
    } timeout:60 * 60];
    
    VCRRecording *recording = [self.cassette recordingForRequest:request];
    STAssertNotNil(recording, @"Should have recording");
    STAssertNotNil(recording.data, @"Should have recorded response data");
    
    NSData *receivedData = self.testDelegate.data;
    STAssertEqualObjects(recording.data, receivedData, @"Recorded data should equal recorded data");
}

- (void)testAsyncGetRequestIsReplayed {
    id json = @[ @{ @"uri": @"http://foo", @"body": @"Foo Bar Baz" } ];
    VCRCassette *cassette = [[[VCRCassette alloc] initWithJSON:json] autorelease];
    [[VCRCassetteManager defaultManager] setCurrentCassette:cassette];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://foo"]];
    
    // cassette has recording for request
    VCRRecording *recording = [self.cassette recordingForRequest:request];
    STAssertNotNil(recording, @"Should have recorded response");

    // make and playback request
    [NSURLConnection connectionWithRequest:request delegate:self.testDelegate];

    // wait for request to finish
    [self runCurrentRunLoopUntilTestPasses:^BOOL{
        return [self.testDelegate isDone];
    } timeout:60 * 60];
    
    // delegate got response
    NSHTTPURLResponse *receivedResponse = self.testDelegate.response;
    STAssertNotNil(receivedResponse, @"Response should not be nil");
    
    // delegate got correct response
    NSHTTPURLResponse *httpResponse = [NSHTTPURLResponse responseFromRecording:recording];
    STAssertTrue([receivedResponse VCR_isIsomorphic:httpResponse],
                 @"Received response should be isomorphic to recorded response");
    
    NSData *receivedData = self.testDelegate.data;
    STAssertEqualObjects(receivedData, recording.data, @"Received data should equal recorded data");
}

// FIXME: test with enough data to fire connection:didReceiveData: times (test data appending)

// FIXME: can start and stop VCR

- (void)testAsyncGetRequestWithErrorIsReplayed {
    id json = @[ @{ @"uri": @"http://foo", @"status": @404 } ];
    VCRCassette *cassette = [[[VCRCassette alloc] initWithJSON:json] autorelease];
    [[VCRCassetteManager defaultManager] setCurrentCassette:cassette];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://foo"]];
    
    // make and playback request
    [NSURLConnection connectionWithRequest:request delegate:self.testDelegate];
    
    // wait for request to finish
    [self runCurrentRunLoopUntilTestPasses:^BOOL{
        return [self.testDelegate isDone];
    } timeout:60 * 60];
    
    STAssertTrue([self.testDelegate isError], @"Delegate should report error");
    
    NSInteger expecteStatusCode = 404;
    STAssertEquals(self.testDelegate.response.statusCode, expecteStatusCode, @"Should get error status code");

}
*/

@end


@implementation VCRURLConnectionTestDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse *)response {
    self.response = response;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    self.data = data;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    _done = YES;
}

- (void)connection:connection didFailWithError:(NSError *)error {
    _error = YES;
}

- (void)dealloc {
    self.data = nil;
    [super dealloc];
}

@end
