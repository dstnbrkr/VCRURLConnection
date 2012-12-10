//
// VCRResponseTests.m
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
