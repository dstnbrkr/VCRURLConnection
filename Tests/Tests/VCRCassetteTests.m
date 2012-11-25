//
//  VCRCassetteTests.m
//  Tests
//
//  Created by Dustin Barker on 11/25/12.
//
//

#import "VCRCassetteTests.h"
#import "VCRCassette.h"
#import "VCRCassette_Private.h"

@interface VCRCassetteTests ()
@property (nonatomic, retain) id recording1;
@property (nonatomic, retain) id recordings;
@end

@implementation VCRCassetteTests

- (void)setUp {
    [super setUp];
    self.recording1 = @{ @"url": @"http://foo", @"body": @"Foo Bar Baz" };
    self.recordings = @[ self.recording1 ];
}

- (void)tearDown {
    self.recording1 = nil;
    self.recordings = nil;
    [super tearDown];
}

- (void)testVCRCassetteRequestForJSON {
    id json = self.recording1;
    NSURL *url = VCRCassetteURLForJSON(json);
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    STAssertEqualObjects(VCRCassetteRequestForJSON(json), request, @"Should create expected request");
}

- (void)testCassetteWithNilURL {
    STAssertThrows([VCRCassette cassetteWithURL:nil], @"Should throw exception when URL is nil");
}

- (void)testInit {
    VCRCassette *cassette = [VCRCassette cassette];
    STAssertNotNil(cassette.responseDictionary, @"Must have response dictionary");
}

- (void)testInitWithNilJSON {
    STAssertThrows([[[VCRCassette alloc] initWithJSON:nil] autorelease], @"Cannot init with nil json");
}

- (void)testInitWithData {
    id json = self.recordings;
    NSData *data = [NSJSONSerialization dataWithJSONObject:json options:0 error:nil];
    VCRCassette *expectedCassette = [[[VCRCassette alloc] initWithJSON:json] autorelease];
    VCRCassette *cassette = [[[VCRCassette alloc] initWithData:data] autorelease];
    STAssertEqualObjects(cassette, expectedCassette, @"");
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

- (void)testCassetteWithURL {
    NSURL *url = [NSURL fileURLWithPath:@"Fixtures/cassette-1.json"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    VCRCassette *expectedCassette = [[[VCRCassette alloc] initWithData:data] autorelease];
    VCRCassette *cassette = [VCRCassette cassetteWithURL:url];
    STAssertEqualObjects(cassette, expectedCassette, @"");
}

- (void)testIsEqual {
    VCRCassette *cassette1 = [[[VCRCassette alloc] initWithJSON:self.recordings] autorelease];
    VCRCassette *cassette2 = [[[VCRCassette alloc] initWithJSON:self.recordings] autorelease];
    STAssertEqualObjects(cassette1, cassette2, @"Cassettes should be equal");
}

@end
