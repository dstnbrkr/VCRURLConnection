#import <XCTest/XCTest.h>
#import "XCTestCase+SRTAdditions.h"
#import "VCR.h"

@interface VCRIntegrationTests : XCTestCase

@property (nonatomic, assign) BOOL finishedLoading;
@property (nonatomic, strong) NSHTTPURLResponse *lastResponse;
@property (nonatomic, strong) NSMutableData *currentData;

- (NSString *)bodyFromURL:(NSString *)urlString;

@end


@implementation VCRIntegrationTests

- (void)tearDown
{
    [[NSFileManager defaultManager] removeItemAtPath:@"/tmp/cassette.json" error:nil];
    [super tearDown];
}

- (void)testDuplicates {
    // Record hitting a URL 3 times
    [VCR startRecordingDuplicates];
    NSString *one = [self bodyFromURL:@"http://www.timeapi.org/utc/now"];
    [NSThread sleepForTimeInterval:1];
    NSString *two = [self bodyFromURL:@"http://www.timeapi.org/utc/now"];
    [NSThread sleepForTimeInterval:1];
    NSString *three = [self bodyFromURL:@"http://www.timeapi.org/utc/now"];
    [VCR save:@"/tmp/cassette.json"];
    [VCR stop];

    // Make sure replay happens in same order
    NSURL *cassetteURL = [NSURL fileURLWithPath:@"/tmp/cassette.json"];
    [VCR loadCassetteWithContentsOfURL:cassetteURL];
    [VCR start];
    XCTAssertEqualObjects(one, [self bodyFromURL:@"http://www.timeapi.org/utc/now"]);
    XCTAssertEqualObjects(two, [self bodyFromURL:@"http://www.timeapi.org/utc/now"]);
    XCTAssertEqualObjects(three, [self bodyFromURL:@"http://www.timeapi.org/utc/now"]);
    [VCR stop];
}

- (NSString *)bodyFromURL:(NSString *)urlString {
    self.finishedLoading = NO;
    self.currentData = [[NSMutableData alloc] init];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                             cachePolicy:NSURLRequestReloadIgnoringCacheData
                                         timeoutInterval:(5 * 60)];
    [NSURLConnection connectionWithRequest:request delegate:self];
    [self runCurrentRunLoopUntilTestPasses:^BOOL{ return self.finishedLoading; } timeout:(5 * 60)];
    return [[NSString alloc] initWithData:self.currentData encoding:NSUTF8StringEncoding];
}

#pragma mark - NSURLConnection delegate methods

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    self.finishedLoading = YES;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.lastResponse = (NSHTTPURLResponse *)response;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.currentData appendData:data];
}

@end
