//
//  VCRRecordingTests.m
//  VCRURLConnection
//
//  Created by Dustin Barker on 12/17/12.
//
//

#import "VCRRecordingTests.h"
#import "VCRRecording.h"

@interface VCRRecording (Private)
- (BOOL)isText;
@end

@interface VCRRecordingTests ()
@property (nonatomic, strong) id json;
@end

@implementation VCRRecordingTests

- (void)setUp {
    [super setUp];
    self.json = @{
        @"method": @"GET",
        @"uri": @"http://foo",
        @"status": @200,
        @"body": @"Foo Bar Baz",
        @"headers": @{ @"X-Foo": @"foo" }
    };
}

- (void)tearDown {
    self.json = nil;
    [super tearDown];
}

- (void)testInitWithJSON {
    id json = self.json;
    VCRRecording *recording = [[VCRRecording alloc] initWithJSON:json];
    
    STAssertEqualObjects(recording.URI, [json objectForKey:@"uri"], @"");
    
    STAssertEquals(recording.statusCode, [[json objectForKey:@"status"] integerValue], @"");
    
    STAssertEqualObjects(recording.body, [json objectForKey:@"body"], @"");
}

- (void)testInitWithJSONBody {
    NSMutableDictionary *json = [self.json mutableCopy];
    json[@"body"] = @{ @"foo" : @"bar", @"baz" : @"qux" };
    VCRRecording *recording = [[VCRRecording alloc] initWithJSON:json];
    
    NSString *expected = @"{\"foo\":\"bar\",\"baz\":\"qux\"}";
    STAssertEqualObjects(expected, recording.body, @"");
}

- (void)testIsEqual {
    VCRRecording *recording1 = [[VCRRecording alloc] initWithJSON:self.json];
    VCRRecording *recording2 = [[VCRRecording alloc] initWithJSON:self.json];
    STAssertEqualObjects(recording1, recording2, @"VCRRecording objects should be equal");
}

- (void)testRecordHTTPURLrecording {
    NSString *uri = @"http://foo/bar";
    NSURL *url = [NSURL URLWithString:uri];
    NSDictionary *headerFields = @{ @"X-FOO": @"foo", @"X-BAR": @"bar" };
    NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:url
                                                                  statusCode:200
                                                                 HTTPVersion:@"HTTP/1.1"
                                                                headerFields:headerFields];
    VCRRecording *recording = [[VCRRecording alloc] init];
    [recording recordResponse:response];
    
    STAssertEqualObjects(recording.URI, [url absoluteString], @"VCRRecording should record URL");
    STAssertEqualObjects(recording.headerFields, headerFields, @"VCRRecording should record all header fields");
    STAssertEquals(recording.statusCode, (NSInteger)200, @"VCRRecording should record status code");
}

- (void)testGenerateHTTPURLResponse {
    VCRRecording *recording = [[VCRRecording alloc] initWithJSON:self.json];
    NSHTTPURLResponse *response = [recording HTTPURLResponse];
    
    STAssertEqualObjects([response.URL absoluteString], recording.URI, @"VCRRecording should generate NSURLresponse with URL");
    STAssertEqualObjects([response allHeaderFields], recording.headerFields, @"VCRRecording should generate NSURLresponse with all header fields");
    STAssertEquals(response.statusCode, recording.statusCode, @"VCRRecording should generate NSURLresponse with status code");
}

- (void)testIsText {
    VCRRecording *recording = [[VCRRecording alloc] init];
    recording.headerFields = @{ @"Content-Type": @"text/plain" };
    STAssertTrue([recording isText], @"");
    recording.headerFields = @{ @"Content-Type": @"text/plain; charset=utf-8" };
    STAssertTrue([recording isText], @"");
    recording.headerFields = @{ @"Content-Type": @"image/png" };
    STAssertFalse([recording isText], @"");
}


- (void)testBodyWithImageData {
    VCRRecording *recording = [[VCRRecording alloc] init];
    NSString *imagePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"test" ofType:@"png"];
    NSURL *imageURL = [NSURL fileURLWithPath:imagePath];
    recording.headerFields = @{ @"Content-Type": @"image/png" };
    recording.data = [NSData dataWithContentsOfURL:imageURL];
    STAssertTrue(recording.body != nil, @"VCRRecording body should not be nil");
}

@end
