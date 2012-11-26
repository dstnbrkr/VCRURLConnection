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
    self.json = @{ @"url": @"http://foo", @"statusCode": @200, @"body": @"Foo Bar Baz" };
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

@end
