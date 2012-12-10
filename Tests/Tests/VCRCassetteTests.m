//
// VCRCassetteTests.m
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

#import "VCRCassetteTests.h"
#import "VCRCassette.h"
#import "VCRCassette_Private.h"
#import "VCRRequestKey.h" // FIXME: don't import

@interface VCRCassetteTests ()
@property (nonatomic, retain) id recording1;
@property (nonatomic, retain) id recordings;
@property (nonatomic, retain) VCRCassette *cassette;
@end

@implementation VCRCassetteTests

- (void)setUp {
    [super setUp];
    self.recording1 = @{ @"url": @"http://foo", @"body": @"Foo Bar Baz" };
    self.recordings = @[ self.recording1 ];
    self.cassette = [VCRCassette cassette];
}

- (void)tearDown {
    self.recording1 = nil;
    self.recordings = nil;
    self.cassette = nil;
    [super tearDown];
}

- (void)testVCRCassetteRequestForJSON {
    id json = self.recording1;
    NSURL *url = [NSURL URLWithString:[json objectForKey:@"url"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    STAssertEqualObjects(VCRCassetteRequestForJSON(json), request, @"Should create expected request");
}

- (void)testInit {
    VCRCassette *cassette = [VCRCassette cassette];
    STAssertNotNil(cassette.responseDictionary, @"Must have response dictionary");
}

- (void)testInitWithData {
    id json = self.recordings;
    NSData *data = [NSJSONSerialization dataWithJSONObject:json options:0 error:nil];
    VCRCassette *expectedCassette = [[[VCRCassette alloc] initWithJSON:json] autorelease];
    VCRCassette *cassette = [[[VCRCassette alloc] initWithData:data] autorelease];
    STAssertEqualObjects(cassette, expectedCassette, @"");
}

- (void)testInitWithJSON {
    NSURLRequest *request = VCRCassetteRequestForJSON(self.recording1);
    VCRResponse *expectedResponse = [[[VCRResponse alloc] initWithJSON:self.recording1] autorelease];
    VCRCassette *cassette = [[[VCRCassette alloc] initWithJSON:self.recordings] autorelease];
    VCRResponse *actualResponse = [cassette responseForRequest:request];
    STAssertEqualObjects(actualResponse, expectedResponse, @"Should get expected response");
}

- (void)testInitWithNilJSON {
    STAssertThrows([[[VCRCassette alloc] initWithJSON:nil] autorelease], @"Cannot init with nil json");
}

- (void)testInitWithNilData {
    STAssertThrows([[[VCRCassette alloc] initWithData:nil] autorelease], @"Cannot init with nil data");
}

- (void)testInitWithInvalidData {
    NSString *invalidJSON = @"{";
    NSData *data = [invalidJSON dataUsingEncoding:NSUTF8StringEncoding];
    STAssertThrows([[[VCRCassette alloc] initWithData:data] autorelease], @"Cannot init with invalid data");
}

// FIXME: test with image data

- (void)testIsEqual {
    VCRCassette *cassette1 = [[[VCRCassette alloc] initWithJSON:self.recordings] autorelease];
    VCRCassette *cassette2 = [[[VCRCassette alloc] initWithJSON:self.recordings] autorelease];
    STAssertEqualObjects(cassette1, cassette2, @"Cassettes should be equal");
}

- (void)testResponseForRequest {
    VCRCassette *cassette = self.cassette;
    NSString *path = @"http://foo";
    NSURL *url = [NSURL URLWithString:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    id json = @{ @"url": path, @"body": @"GET Foo Bar Baz" };
    VCRResponse *response = [[[VCRResponse alloc] initWithJSON:json] autorelease];
    
    [cassette setResponse:response forRequest:request];
    STAssertEqualObjects([cassette responseForRequest:request], response, @"");
    
    // can retrieve with equivalent mutable request
    NSMutableURLRequest *request1 = [NSMutableURLRequest requestWithURL:url];
    STAssertEqualObjects([cassette responseForRequest:request1], response, @"");
}

- (void)testResponseForRequest_DifferentiateRequestsByMethod {

}

@end
