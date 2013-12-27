//
// VCRTests.m
//
// Copyright (c) 2012 Dustin Barker
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "VCRTests.h"
#import "VCR.h"
#import <objc/runtime.h>

@interface VCRTests ()
@end

@implementation VCRTests

- (void)setUp {
    [super setUp];
}

- (void)testStart {
    
    Class clazz = [NSURLConnection class];
    
    Method method1 = class_getInstanceMethod(clazz, @selector(initWithRequest:delegate:startImmediately:));
    IMP imp1 = method_getImplementation(method1);
    
    Method method2 = class_getInstanceMethod(clazz, @selector(initWithRequest:delegate:));
    IMP imp2 = method_getImplementation(method2);
    
    [VCR start];
    
    XCTAssertFalse(imp1 == method_getImplementation(method1), @"Implementation should be swizzled");
    XCTAssertFalse(imp2 == method_getImplementation(method2), @"Implementation should be swizzled");
    
    [VCR stop];
}

- (void)testStop {
    
    Class clazz = [NSURLConnection class];
    
    Method method1 = class_getInstanceMethod(clazz, @selector(initWithRequest:delegate:startImmediately:));
    Method method2 = class_getInstanceMethod(clazz, @selector(initWithRequest:delegate:));
    
    [VCR start];
    
    IMP imp1 = method_getImplementation(method1);
    IMP imp2 = method_getImplementation(method2);
    
    [VCR stop];
    
    XCTAssertFalse(imp1 == method_getImplementation(method1), @"Implementation should be unswizzled");
    XCTAssertFalse(imp2 == method_getImplementation(method2), @"Implementation should be unswizzled");
}

- (void)tearDown {
    [super tearDown];
}

@end
