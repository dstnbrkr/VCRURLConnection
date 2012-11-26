//
//  VCRCassetteManagerTests.m
//  Tests
//
//  Created by Dustin Barker on 11/25/12.
//
//

#import "VCRCassetteManagerTests.h"
#import "VCRCassetteManager.h"
#import "VCRCassette.h"


@interface VCRCassetteManagerTests ()
@property (nonatomic, retain) VCRCassetteManager *manager;
@end


@implementation VCRCassetteManagerTests

- (void)setUp {
    [super setUp];
    self.manager = [[[VCRCassetteManager alloc] init] autorelease];
}

- (void)tearDown {
    self.manager = nil;
    [super tearDown];
}

- (void)testCurrentCassetteWhenNil {
    STAssertThrows([self.manager currentCassette], @"Cannot access currentCassette when it's not set");
}

- (void)testSetCurrentCassetteWithURL {
    NSURL *url = [NSURL fileURLWithPath:@"Fixtures/cassette-1.json"];
    
    VCRCassette *expectedCassette = [VCRCassette cassetteWithURL:url];
    [self.manager setCurrentCassetteURL:url];
    
    STAssertEqualObjects(self.manager.currentCassette, expectedCassette, @"Should set cassette with URL");
}

@end
