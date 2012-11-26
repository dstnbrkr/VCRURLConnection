//
//  VCRURLConnectionTests.m
//  Tests
//
//  Created by Dustin Barker on 11/25/12.
//
//

#import "VCRURLConnectionTests.h"
#import "VCRCassetteManager.h"
#import "VCRCassette.h"
#import "VCR.h"

@interface VCRURLConnectionTestDelegate : NSObject<NSURLConnectionDelegate>
@property (nonatomic, retain) NSData *data;
@property (assign, getter = isDone) BOOL done;
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

- (void)testAsyncConnectionRecordedAndReplayed {
    NSURL *url = [NSURL URLWithString:@"http://www.iana.org/domains/example/"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // request has not been recorded yet
    STAssertNil([self.cassette responseForRequest:request], @"Should not have recording for request yet");
    
    // make and record request
    [NSURLConnection connectionWithRequest:request delegate:self.testDelegate];
    
    // wait for request to finish
    while (![self.testDelegate isDone]) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        usleep(10000);
    }
    
    // the response was recorded
    VCRResponse *recordedResponse = [self.cassette responseForRequest:request];
    STAssertNotNil(recordedResponse, @"Should have recorded a response");
    
    NSData *receivedData = self.testDelegate.data;
    NSData *recordedData = recordedResponse.responseData;
    STAssertEqualObjects(recordedData, receivedData, @"Recorded data should equal received data");
}

// FIXME: test with enough data to fire connection:didReceiveData: times (test data appending)

// FIXME: can start and stop VCR

@end


@implementation VCRURLConnectionTestDelegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    self.data = data;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    _done = YES;
}

- (void)dealloc {
    self.data = nil;
    [super dealloc];
}

@end
