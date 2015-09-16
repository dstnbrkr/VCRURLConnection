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
        @"requestBody": @"Foo Bar Baz",
        @"responseBody": @"Foo Bar Baz",
        @"headers": @{ @"X-Foo": @"foo" },
        @"error": @{ @"code": @(1001),
                     @"domain": @"NSURLConnectionErrorDomain",
                     @"localizedDescription": @"An error occurred" }};
}

- (void)tearDown {
    self.json = nil;
    [super tearDown];
}

- (void)testInitWithJSON {
    id json = self.json;
    VCRRecording *recording = [[VCRRecording alloc] initWithJSON:json];
    
    XCTAssertEqualObjects(recording.URI, [json objectForKey:@"uri"], @"");
    
    XCTAssertEqual(recording.statusCode, [[json objectForKey:@"status"] integerValue], @"");
    
    XCTAssertEqualObjects(recording.requestBody, [json objectForKey:@"requestBody"], @"");
    XCTAssertEqualObjects(recording.responseBody, [json objectForKey:@"responseBody"], @"");
    
    XCTAssertEqual(recording.error.code, [json[@"error"][@"code"] integerValue], @"");
    XCTAssertTrue([recording.error.userInfo isKindOfClass:[NSDictionary class]], @"");
}

- (void)testJSON {
    VCRRecording *recording = [[VCRRecording alloc] initWithJSON:self.json];
    id json = [recording JSON];
    XCTAssertEqualObjects(json, self.json, @"");
}

- (void)testInitWithJSONRequestBody {
    NSMutableDictionary *json = [self.json mutableCopy];
    json[@"requestBody"] = @{ @"foo" : @"bar", @"baz" : @"qux" };
    VCRRecording *recording = [[VCRRecording alloc] initWithJSON:json];
    
    NSString *expected = @"{\"foo\":\"bar\",\"baz\":\"qux\"}";
    XCTAssertEqualObjects(expected, recording.requestBody, @"");
}

- (void)testInitWithJSONResponseBody {
    NSMutableDictionary *json = [self.json mutableCopy];
    json[@"responseBody"] = @{ @"foo" : @"bar", @"baz" : @"qux" };
    VCRRecording *recording = [[VCRRecording alloc] initWithJSON:json];
    
    NSString *expected = @"{\"foo\":\"bar\",\"baz\":\"qux\"}";
    XCTAssertEqualObjects(expected, recording.responseBody, @"");
}

- (void)testIsEqual {
    VCRRecording *recording1 = [[VCRRecording alloc] initWithJSON:self.json];
    VCRRecording *recording2 = [[VCRRecording alloc] initWithJSON:self.json];
    XCTAssertEqualObjects(recording1, recording2, @"VCRRecording objects should be equal");
}

- (void)testGenerateHTTPURLResponse {
    VCRRecording *recording = [[VCRRecording alloc] initWithJSON:self.json];
    NSHTTPURLResponse *response = [recording HTTPURLResponse];
    
    XCTAssertEqualObjects([response.URL absoluteString], recording.URI, @"VCRRecording should generate NSURLresponse with URL");
    XCTAssertEqualObjects([response allHeaderFields], recording.headerFields, @"VCRRecording should generate NSURLresponse with all header fields");
    XCTAssertEqual(response.statusCode, recording.statusCode, @"VCRRecording should generate NSURLresponse with status code");
}

- (void)testIsText {
    VCRRecording *recording = [[VCRRecording alloc] init];
    recording.headerFields = @{ @"Content-Type": @"text/plain" };
    XCTAssertTrue([recording isText], @"");
    recording.headerFields = @{ @"Content-Type": @"text/plain; charset=utf-8" };
    XCTAssertTrue([recording isText], @"");
    recording.headerFields = @{ @"Content-Type": @"image/png" };
    XCTAssertFalse([recording isText], @"");
}

- (void)testBodyWithImageData {
    VCRRecording *recording = [[VCRRecording alloc] init];
    NSString *imagePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"test" ofType:@"png"];
    NSURL *imageURL = [NSURL fileURLWithPath:imagePath];
    recording.headerFields = @{ @"Content-Type": @"image/png" };
    recording.responseBodyData = [NSData dataWithContentsOfURL:imageURL];
    XCTAssertTrue(recording.responseBody != nil, @"VCRRecording body should not be nil");
}

@end
