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
#import "NSURLConnection+VCR.h"
#import <objc/runtime.h>

IMP NSURLConnectionImplementationForSelector(SEL selector) {
    Method method = class_getInstanceMethod([NSURLConnection class], selector);
    return method_getImplementation(method);
}

@interface VCRTests ()

@property (nonatomic, assign) IMP originalConstructorIMP1;
@property (nonatomic, assign) IMP newConstructorIMP1;

@property (nonatomic, assign) IMP originalConstructorIMP2;
@property (nonatomic, assign) IMP newConstructorIMP2;

@end

@implementation VCRTests

- (void)setUp {
    [super setUp];
    
    IMP imp;

    // store old and new imps of initWithRequest:delegate:startImmediately:
    imp = NSURLConnectionImplementationForSelector(@selector(initWithRequest:delegate:startImmediately:));
    self.originalConstructorIMP1 = imp;
    imp = NSURLConnectionImplementationForSelector(@selector(initWithRequest_VCR_:delegate:startImmediately:));
    STAssertTrue(imp != nil, @"");
    self.newConstructorIMP1 = imp;
    STAssertFalse(self.originalConstructorIMP1 == self.newConstructorIMP1, @"Implementations should differ");
    
    // store old and new imps of initWithRequest:delegate:
    imp = NSURLConnectionImplementationForSelector(@selector(initWithRequest:delegate:));
    self.originalConstructorIMP2 = imp;
    imp = NSURLConnectionImplementationForSelector(@selector(initWithRequest_VCR_:delegate:));
    STAssertTrue(imp != nil, @"");
    self.newConstructorIMP2 = imp;
    STAssertFalse(self.originalConstructorIMP2 == self.newConstructorIMP2, @"Implementations should differ");
    
}

- (void)testStart {
    [VCR start];
    
    IMP newImp;
    IMP oldImp;

    // test new and old imps of initWithRequest:delegate:startImmediately:
    newImp = NSURLConnectionImplementationForSelector(@selector(initWithRequest:delegate:startImmediately:));
    STAssertEquals(newImp, self.newConstructorIMP1, @"Implementation should be swizzled");
    oldImp = NSURLConnectionImplementationForSelector(@selector(initWithRequest_VCR_original_:delegate:startImmediately:));
    STAssertEquals(oldImp, self.originalConstructorIMP1, @"Original implementation should be accessible");
    
    // test new and old imps of initWithRequest:delegate:
    newImp = NSURLConnectionImplementationForSelector(@selector(initWithRequest:delegate:));
    STAssertEquals(newImp, self.newConstructorIMP2, @"Implementation should be swizzled");
    oldImp = NSURLConnectionImplementationForSelector(@selector(initWithRequest_VCR_original_:delegate:));
    STAssertEquals(oldImp, self.originalConstructorIMP2, @"Original implementation should be accessible");
}

- (void)testStartStop {
    [VCR start];
    
    SEL sel1 = @selector(initWithRequest:delegate:startImmediately:);
    SEL sel2 = @selector(initWithRequest:delegate:);
    IMP imp;
    
    imp = NSURLConnectionImplementationForSelector(sel1);
    STAssertEquals(imp, self.newConstructorIMP1, @"Implementation should be swizzled");
    imp = NSURLConnectionImplementationForSelector(sel2);
    STAssertEquals(imp, self.newConstructorIMP2, @"Implementation should be swizzled");
    
    [VCR stop];
    
    imp = NSURLConnectionImplementationForSelector(sel1);
    STAssertEquals(imp, self.originalConstructorIMP1, @"Implementation should be swizzled");
    imp = NSURLConnectionImplementationForSelector(sel2);
    STAssertEquals(imp, self.originalConstructorIMP2, @"Implementation should be swizzled");
}

- (void)tearDown {
    [VCR stop];
    [super tearDown];
}

@end
