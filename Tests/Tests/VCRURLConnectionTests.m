//
//  VCRURLConnectionTests.m
//  Tests
//
//  Created by Dustin Barker on 11/25/12.
//
//

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

- (void)testAsyncConnectionIsRecorded {
    NSURL *url = [NSURL URLWithString:@"http://www.iana.org/domains/example/"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // request has not been recorded yet
    STAssertNil([self.cassette responseForRequest:request], @"Should not have recording for request yet");
    
    // make and record request
    [NSURLConnection connectionWithRequest:request delegate:self.testDelegate];
    
    // wait for request to finish
    [self runCurrentRunLoopUntilTestPasses:^BOOL{
        return [self.testDelegate isDone];
    } timeout:60 * 60];
    
    VCRResponse *recordedResponse = [self.cassette responseForRequest:request];
    NSData *recordedData = recordedResponse.responseData;
    STAssertNotNil(recordedResponse, @"Should have recorded response data");
    
    NSData *receivedData = self.testDelegate.data;
    STAssertEqualObjects(recordedData, receivedData, @"Recorded data should equal recorded data");    
}

- (void)testAsyncGetRequestIsReplayed {
    id json = @[ @{ @"url": @"http://foo", @"body": @"Foo Bar Baz" } ];
    VCRCassette *cassette = [[[VCRCassette alloc] initWithJSON:json] autorelease];
    [[VCRCassetteManager defaultManager] setCurrentCassette:cassette];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://foo"]];
    
    // cassette has recording for request
    VCRResponse *recordedResponse = [cassette responseForRequest:request];
    STAssertNotNil(recordedResponse, @"Should have recorded response");

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
    NSHTTPURLResponse *httpResponse = [recordedResponse generateHTTPURLResponse];
    STAssertTrue([receivedResponse VCR_isIsomorphic:httpResponse],
                 @"Received response should be isomorphic to recorded response");
    
    NSData *receivedData = self.testDelegate.data;
    STAssertEqualObjects(receivedData, recordedResponse.responseData, @"Received data should equal recorded data");
}

// FIXME: test with enough data to fire connection:didReceiveData: times (test data appending)

// FIXME: can start and stop VCR

- (void)testAsyncGetRequestWithErrorIsReplayed {
    id json = @[ @{ @"url": @"http://foo", @"statusCode": @404 } ];
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
