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
#import <objc/objc-runtime.h>

@interface VCR_NSURLSessionTests : XCTestCase
@end

@implementation VCR_NSURLSessionTests

- (Method)constructorMethod {
    Class clazz = object_getClass([NSURLSession class]);
    return class_getClassMethod(clazz, @selector(sessionWithConfiguration:delegate:delegateQueue:));
}

- (Method)dataTaskMethod {
    Class clazz = [NSURLSession class];
    return class_getInstanceMethod(clazz, @selector(dataTaskWithRequest:completionHandler:));
}

- (void)testSwizzle {
    VCRSwizzleNSURLSession();
    XCTAssertEqual(method_getImplementation([self constructorMethod]), (IMP)VCR_URLSessionConstructor, @"");
    XCTAssertEqual(method_getImplementation([self dataTaskMethod]), (IMP)VCR_dataTaskWithRequest_completionHandler, @"");
}

- (void)testUnswizzle {
    VCRUnswizzleNSURLSession();
    XCTAssertNotEqual(method_getImplementation([self constructorMethod]), (IMP)VCR_URLSessionConstructor, @"");
    XCTAssertNotEqual(method_getImplementation([self dataTaskMethod]), (IMP)VCR_dataTaskWithRequest_completionHandler, @"");
}

@end

#endif
