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
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    VCRCassette *expectedCassette = [[[VCRCassette alloc] initWithData:data] autorelease];
    [self.manager setCurrentCassetteURL:url];
    
    STAssertEqualObjects(self.manager.currentCassette, expectedCassette, @"Should set cassette with URL");
}

- (void)testSetCurrentCassetteWithNonExistentURL {
    NSTimeInterval timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *path = [NSString stringWithFormat:@"/tmp/cassette-%f.json", timestamp];
    NSURL *url = [NSURL fileURLWithPath:path];
    
    STAssertFalse([[NSFileManager defaultManager] fileExistsAtPath:path], @"File should not exist");
    
    [self.manager setCurrentCassetteURL:url];
    STAssertNotNil(self.manager.currentCassette, @"Cassette should be set");
}

- (void)testSetCurrentCassetteWithUnwritableURL {
    NSURL *url = [NSURL fileURLWithPath:@"/unwritable.json"];
    STAssertThrows([self.manager setCurrentCassetteURL:url], @"Should not be able to set unwritable URL");
}

@end
