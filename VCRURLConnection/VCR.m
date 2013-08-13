//
// VCR.m
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

#import "VCR.h"
#import "VCRCassette.h"
#import "VCRCassetteManager.h"
#import "NSURLConnection+VCR.h"
#import <objc/runtime.h>

static void VCRStoreOriginalImplentation(SEL selector);

static void VCRSwizzle(SEL selector, SEL altSelector);

@implementation VCR

+ (NSArray *)selectors {
    return @[ NSStringFromSelector(@selector(initWithRequest:delegate:)),
              NSStringFromSelector(@selector(initWithRequest:delegate:startImmediately:)) ];
}

+ (NSArray *)originalSelectors {
    return @[ NSStringFromSelector(@selector(initWithRequest_VCR_original_:delegate:)),
              NSStringFromSelector(@selector(initWithRequest_VCR_original_:delegate:startImmediately:)) ];
}

+ (NSArray *)alternateSelectors {
    return @[ NSStringFromSelector(@selector(initWithRequest_VCR_:delegate:)),
              NSStringFromSelector(@selector(initWithRequest_VCR_:delegate:startImmediately:)) ];
}

+ (void)swizzleSelectors:(NSArray *)originalSelectors withSelectors:(NSArray *)alternateSelectors {
    [originalSelectors enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        SEL originalSelector = NSSelectorFromString(obj);
        SEL alternateSelector = NSSelectorFromString(alternateSelectors[idx]);
        VCRSwizzle(originalSelector, alternateSelector);
    }];
}

+ (void)initialize {
    // store original implementations so we can unswizzle later
    [self swizzleSelectors:[self originalSelectors] withSelectors:[self selectors]];
}

+ (void)loadCassetteWithContentsOfURL:(NSURL *)url {
    [[VCRCassetteManager defaultManager] setCurrentCassetteURL:url];
}

+ (VCRCassette *)cassette {
    return [[VCRCassetteManager defaultManager] currentCassette];
}

+ (void)start {
    [self swizzleSelectors:[self selectors] withSelectors:[self alternateSelectors]];
}

+ (void)stop {
    [self swizzleSelectors:[self selectors] withSelectors:[self originalSelectors]];
}

+ (void)save:(NSString *)path {
    return [[VCRCassetteManager defaultManager] save:path];
}

@end

static void VCRSwizzle(SEL selector, SEL altSelector) {
    Method altMethod = class_getInstanceMethod([NSURLConnection class], altSelector);
    IMP altIMP = method_getImplementation(altMethod);
    Method originalMethod = class_getInstanceMethod([NSURLConnection class], selector);
    method_setImplementation(originalMethod, altIMP);
}
