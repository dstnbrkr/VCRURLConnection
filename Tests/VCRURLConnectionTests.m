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


@implementation VCRURLConnectionTests

- (void)setUp {
    [super setUp];
    [VCR start];
    [[VCRCassetteManager defaultManager] setCurrentCassette:nil];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testResponseIsRecorded_NSURLConnection_connectionWithRequest_delegate {
    NSURL *url = [NSURL URLWithString:@"http://www.iana.org/domains/reserved"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    VCRURLConnectionTestDelegate *delegate = [[VCRURLConnectionTestDelegate alloc] init];
    [self recordRequest:request requestBlock:^{
        [NSURLConnection connectionWithRequest:request delegate:delegate];
    } predicateBlock:^BOOL{
        return [delegate isDone];
    } completion:^(VCRRecording *recording) {
        [self testRecording:recording forRequest:request];
    }];
}

- (void)testResponseIsDelegated_NSURLConnection_connectionWithRequest_delegate {
    NSURL *url = [NSURL URLWithString:@"http://www.iana.org/domains/reserved"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    VCRURLConnectionTestDelegate *delegate = [[VCRURLConnectionTestDelegate alloc] init];
    [self recordRequest:request requestBlock:^{
        [NSURLConnection connectionWithRequest:request delegate:delegate];
    } predicateBlock:^BOOL{
        return [delegate isDone];
    } completion:^(VCRRecording *recording) {
        [self testDelegate:(id<VCRTestDelegate>)delegate forRecording:recording];
    }];
}

- (void)testResponseIsReplayed_NSURLConnection_connectionWithRequest_delegate {
    id json = @{ @"method": @"GET", @"uri": @"http://foo", @"body": @"Foo Bar Baz" };
    VCRURLConnectionTestDelegate *delegate = [[VCRURLConnectionTestDelegate alloc] init];
    [self replayJSON:json requestBlock:^(NSURLRequest *request) {
        [NSURLConnection connectionWithRequest:request delegate:delegate];
    } predicateBlock:^BOOL{
        return [delegate isDone];
    } completion:^(VCRRecording *recording) {
        [self testDelegate:(id<VCRTestDelegate>)delegate forRecording:recording];
    }];
}

- (void)testErrorIsReplayed_NSURLConnection_connectionWithRequest_delegate {
    id json = @{ @"method": @"get", @"uri": @"http://foo", @"status": @404 };
    VCRURLConnectionTestDelegate *delegate = [[VCRURLConnectionTestDelegate alloc] init];
    [self replayJSON:json requestBlock:^(NSURLRequest *request) {
        [NSURLConnection connectionWithRequest:request delegate:delegate];
    } predicateBlock:^BOOL{
        return [delegate isDone];
    } completion:^(VCRRecording *recording) {
        [self testDelegate:(id<VCRTestDelegate>)delegate forRecording:recording];
    }];
}

/*
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
*/

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
