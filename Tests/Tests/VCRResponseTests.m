//
//  VCRResponseTests.m
//  Tests
//
//  Created by Dustin Barker on 11/25/12.
//
//

#import "VCRResponseTests.h"
#import "VCRResponse.h"

@interface VCRResponseTests ()
@property (nonatomic, retain) id json;
@end

@implementation VCRResponseTests

- (void)setUp {
    [super setUp];
    self.json = @{ @"url": @"http://foo",
                   @"statusCode": @200,
                   @"body": @"Foo Bar Baz",
                   @"headers": @{ @"X-Foo": @"foo" } };
}

- (void)tearDown {
    self.json = nil;
    [super tearDown];
}

- (void)testInitWithJSON {
    id json = self.json;
    VCRResponse *response = [[[VCRResponse alloc] initWithJSON:json] autorelease];
    
    STAssertEqualObjects([response.url absoluteString], [json objectForKey:@"url"], @"");
    
    STAssertEquals(response.statusCode, [[json objectForKey:@"statusCode"] integerValue], @"");
    
    NSData *data = [[json objectForKey:@"body"] dataUsingEncoding:NSUTF8StringEncoding];
    STAssertEqualObjects(response.responseData, data, @"");
}

- (void)testIsEqual {
    VCRResponse *response1 = [[[VCRResponse alloc] initWithJSON:self.json] autorelease];
    VCRResponse *response2 = [[[VCRResponse alloc] initWithJSON:self.json] autorelease];
    STAssertEqualObjects(response1, response2, @"VCRResponse objects should be equal");
}

- (void)testRecordHTTPURLResponse {
    NSURL *url = [NSURL URLWithString:@"http://foo/bar"];
    NSDictionary *headerFields = @{ @"X-FOO": @"foo", @"X-BAR": @"bar" };
    NSHTTPURLResponse *httpResponse = [[NSHTTPURLResponse alloc] initWithURL:url
                                                                  statusCode:200
                                                                 HTTPVersion:@"HTTP/1.1"
                                                                headerFields:headerFields];
    VCRResponse *vcrResponse = [[VCRResponse alloc] init];
    [vcrResponse recordHTTPURLResponse:httpResponse];
    
    STAssertEqualObjects(vcrResponse.url, url, @"VCRResponse should record URL");
    STAssertEqualObjects(vcrResponse.headerFields, headerFields, @"VCRResponse should record all header fields");
    STAssertEquals(vcrResponse.statusCode, (NSInteger)200, @"VCRResponse should record status code");
}

- (void)testGenerateHTTPURLResponse {
    VCRResponse *vcrResponse = [[[VCRResponse alloc] initWithJSON:self.json] autorelease];
    NSHTTPURLResponse *httpResponse = [vcrResponse generateHTTPURLResponse];
    
    STAssertEqualObjects(httpResponse.URL, vcrResponse.url, @"VCRResponse should generate NSURLHTTPResponse with URL");
    STAssertEqualObjects([httpResponse allHeaderFields], vcrResponse.headerFields, @"VCRResponse should generate NSURLHTTPResponse with all header fields");
    STAssertEquals(httpResponse.statusCode, [vcrResponse statusCode], @"VCRResponse should generate NSURLHTTPResponse with status code");
}

@end
