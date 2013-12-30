//
//  VCR_NSURLSessionTests.m
//  VCRURLConnection
//
//  Created by Dustin Barker on 12/29/13.
//
//

#import <XCTest/XCTest.h>
#import "VCR+NSURLSession.h"
#import <objc/objc-runtime.h>

@interface VCR_NSURLSessionTests : XCTestCase

@end

@implementation VCR_NSURLSessionTests

- (void)testSwizzle {
    Class clazz = object_getClass([NSURLSession class]);
    Method method = class_getClassMethod(clazz, @selector(sessionWithConfiguration:delegate:delegateQueue:));
    VCRSwizzleNSURLSession();
    XCTAssertEqual(method_getImplementation(method), (IMP)VCR_URLSessionConstructor, @"");
}

- (void)testStop {
    Class clazz = object_getClass([NSURLSession class]);
    Method method = class_getClassMethod(clazz, @selector(sessionWithConfiguration:delegate:delegateQueue:));
    VCRUnswizzleNSURLSession();
    XCTAssertNotEqual(method_getImplementation(method), (IMP)VCR_URLSessionConstructor, @"");
}

@end
