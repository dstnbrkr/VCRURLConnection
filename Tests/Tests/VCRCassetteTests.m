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
@property (nonatomic, retain) id json1;
@end

@implementation VCRCassetteTests

- (void)setUp {
    // trivial JSON
    NSDictionary *request = @{ @"url": @"http://foo" };
    NSDictionary *response = @{ @"body": @"Foo Bar Baz" };
    NSDictionary *recording = @{ @"request": request, @"response": response };
    self.recording1 = recording;
    self.json1 = @[ recording ];
}

- (void)tearDown {
    self.json1 = nil;
}

- (void)testVCRCassetteRequestForJSON {
    id json = self.recording1;
    NSURL *url = VCRCassetteURLForJSON(json);
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    STAssertEqualObjects(VCRCassetteRequestForJSON(json), request, @"Should create expected request");
}

- (void)testCassetteWithNilURL {
    //STAssertThrows([VCRCassette cassetteWithURL:nil], @"Should throw exception when URL is nil");
}

// FIXME: test that initWithURL is just a proxy to initWithData

// FIXME: test that initWithData is just a proxy to initWithJSON

// FIXME: test that initWithJSON creates the expected cassette

/*
- (void)testInit {
    VCRCassette *cassette = [VCRCassette cassette];
    STAssertNotNil(cassette.responseDictionary, @"Must have response dictionary");
}
*/

/*
- (void)testCassetteWithURL {
    NSURL *url = [NSURL fileURLWithPath:@"Fixtures/cassette-1.json"];
    VCRCassette *cassette = [VCRCassette cassetteWithURL:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://foo"]];
    //STAssertNotNil([cassette responseForRequest:request], @"Cassette should have response");
}
*/

@end
