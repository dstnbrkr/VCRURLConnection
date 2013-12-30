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

@end

#endif
