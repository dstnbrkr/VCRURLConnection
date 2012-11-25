//
//  VCRCassetteTests.m
//  Tests
//
//  Created by Dustin Barker on 11/25/12.
//
//

#import "VCRCassetteTests.h"
#import "VCRCassette.h"

@implementation VCRCassetteTests

- (void)testCassetteWithNilURL {
    STAssertThrows([VCRCassette cassetteWithURL:nil], @"Should throw exception when URL is nil");
}

- (void)testCassetteWithURL {
    NSURL *url = [NSURL fileURLWithPath:@"Fixtures/cassette-1.json"];
    VCRCassette *cassette = [VCRCassette cassetteWithURL:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://foo"]];
    STAssertNotNil([cassette responseForRequest:request], @"Cassette should have response");
}

@end
