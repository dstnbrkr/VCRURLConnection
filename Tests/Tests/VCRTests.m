//
//  VCRTests.m
//  Tests
//
//  Created by Dustin Barker on 12/2/12.
//
//

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
    imp = NSURLConnectionImplementationForSelector(@selector(VCR_initWithRequest:delegate:startImmediately:));
    self.newConstructorIMP1 = imp;
    STAssertFalse(self.originalConstructorIMP1 == self.newConstructorIMP1, @"Implementations should differ");
    
    // store old and new imps of initWithRequest:delegate:
    imp = NSURLConnectionImplementationForSelector(@selector(initWithRequest:delegate:));
    self.originalConstructorIMP2 = imp;
    imp = NSURLConnectionImplementationForSelector(@selector(VCR_initWithRequest:delegate:));
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
    oldImp = NSURLConnectionImplementationForSelector(@selector(VCR_original_initWithRequest:delegate:startImmediately:));
    STAssertEquals(oldImp, self.originalConstructorIMP1, @"Original implementation should be accessible");
    
    // test new and old imps of initWithRequest:delegate:
    newImp = NSURLConnectionImplementationForSelector(@selector(initWithRequest:delegate:));
    STAssertEquals(newImp, self.newConstructorIMP2, @"Implementation should be swizzled");
    oldImp = NSURLConnectionImplementationForSelector(@selector(VCR_original_initWithRequest:delegate:));
    STAssertEquals(oldImp, self.originalConstructorIMP2, @"Original implementation should be accessible");
}

- (void)tearDown {
    [VCR stop];
    [super tearDown];
}

@end
