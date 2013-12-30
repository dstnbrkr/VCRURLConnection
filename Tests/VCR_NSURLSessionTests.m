//
//  VCR_NSURLSessionTests.m
//  VCRURLConnection
//
//  Created by Dustin Barker on 12/29/13.
//
//

#import <Availability.h>
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 50000 || __MAC_OS_X_VERSION_MIN_REQUIRED >= 1090

#import <XCTest/XCTest.h>
#import "VCR+NSURLSession.h"
#import "VCRURLSessionTestDelegate.h"
#import "XCTestCase+VCR.h"
#import <objc/objc-runtime.h>

@interface VCR_NSURLSessionTests : XCTestCase

@end

@implementation VCR_NSURLSessionTests

- (NSURLSession *)defaultSession
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    return session;
}

- (Method)constructorMethod {
    Class clazz = object_getClass(NSClassFromString(@"NSURLSession"));
    return class_getClassMethod(clazz, @selector(sessionWithConfiguration:delegate:delegateQueue:));
}

- (void)testSwizzle {
    VCRSwizzleNSURLSession();
    XCTAssertEqual(method_getImplementation([self constructorMethod]), (IMP)VCR_URLSessionConstructor, @"");
}

- (void)testUnswizzle {
    VCRUnswizzleNSURLSession();
    XCTAssertNotEqual(method_getImplementation([self constructorMethod]), (IMP)VCR_URLSessionConstructor, @"");
}
/*
- (void)testResponseIsRecorded {
    [self testRecordResponseForRequestBlock:^id<VCRTestDelegate>(NSURLRequest *request) {
        VCRURLSessionTestDelegate *delegate = [[VCRURLSessionTestDelegate alloc] init];
        NSURLSession *session = [self defaultSession];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                                completionHandler:nil];
        [task resume];
        return delegate;
    }];
}
*/

@end

#endif
