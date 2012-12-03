//
//  VCRRequestKeyTests.m
//  Tests
//
//  Created by Dustin Barker on 12/2/12.
//
//

#import "VCRRequestKeyTests.h"
#import "VCRRequestKey.h"

@interface VCRRequestKeyTests ()
@property (nonatomic, retain) VCRRequestKey *key1;
@property (nonatomic, retain) VCRRequestKey *key2;
@end

@implementation VCRRequestKeyTests

- (void)setUp {
    NSURL *url = [NSURL URLWithString:@"http://foo/bar"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    self.key1 = [VCRRequestKey keyForRequest:request];
    self.key2 = [VCRRequestKey keyForRequest:request];
}

- (void)testIsEqual {
    STAssertEqualObjects(self.key1, self.key2, @"Key objects should be equal");
}

- (void)testHash {
    STAssertEquals([self.key1 hash], [self.key2 hash], @"Key hashes should be equal");
}

- (void)testAsDictionaryKey {
    NSDictionary *dictionary = @{ self.key1: @"Foo" };    
    STAssertEqualObjects([dictionary objectForKey:self.key2], @"Foo", @"Can lookup with equivalent key");
}

@end
