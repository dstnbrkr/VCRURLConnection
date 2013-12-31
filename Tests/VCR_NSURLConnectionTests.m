//
//  VCR_NSURLConnectionTests.m
//  VCRURLConnection
//
//  Created by Dustin Barker on 12/29/13.
//
//

#import <XCTest/XCTest.h>
#import "VCR+NSURLConnection.h"
#import "VCRCassetteManager.h"
#import <objc/objc-runtime.h>

@interface VCR_NSURLConnectionTests : XCTestCase

@end

@implementation VCR_NSURLConnectionTests

- (void)setUp {
    [super setUp];
    [[VCRCassetteManager defaultManager] setCurrentCassette:nil];
}

- (void)enumerateImplementationsWithBlock:(void(^)(NSUInteger index, IMP imp))block {
    SEL selectors[2];
    selectors[0] = @selector(initWithRequest:delegate:startImmediately:);
    selectors[1] = @selector(initWithRequest:delegate:);
    
    Class clazz = [NSURLConnection class];
    for (NSUInteger i = 0; i < 2; i++) {
        Method method = class_getInstanceMethod(clazz, selectors[i]);
        block(i, method_getImplementation(method));
    }
}

- (void)testSwizzle {
    IMP *imps = calloc(2, sizeof(IMP));
    imps[0] = (IMP)VCR_URLConnectionInitializer1;
    imps[1] = (IMP)VCR_URLConnectionInitializer2;
    
    VCRSwizzleNSURLConnection();
    
    [self enumerateImplementationsWithBlock:^(NSUInteger index, IMP imp) {
        XCTAssertEqual(imp, imps[index], @"");
    }];
    
    free(imps), imps = NULL;
}

- (void)testUnswizzle {
    IMP *imps = calloc(2, sizeof(IMP));
    imps[0] = (IMP)VCR_URLConnectionInitializer1;
    imps[1] = (IMP)VCR_URLConnectionInitializer2;
    
    VCRUnswizzleNSURLConnection();
    
    [self enumerateImplementationsWithBlock:^(NSUInteger index, IMP imp) {
        XCTAssertNotEqual(imp, imps[index], @"");
    }];
    
    free(imps), imps = NULL;
}

@end
