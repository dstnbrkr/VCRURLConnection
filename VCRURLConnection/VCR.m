//
//  VCR.m
//  VCRURLConnectionExample
//
//  Created by Dustin Barker on 11/18/12.
//  Copyright (c) 2012 Dustin Barker. All rights reserved.
//

#import "VCR.h"
#import "VCRCassette.h"
#import "VCRCassetteManager.h"
#import "NSURLConnection+VCR.h"
#import <objc/runtime.h>

static void VCRStoreOriginalImplentation(SEL selector);

static void VCRURLConnectionSwizzle(SEL selector);
static void VCRURLConnectionUnswizzle(SEL selector);

@implementation VCR

+ (void)initialize {
    VCRStoreOriginalImplentation(@selector(initWithRequest:delegate:));
    VCRStoreOriginalImplentation(@selector(initWithRequest:delegate:startImmediately:));
}

+ (void)setCassetteURL:(NSURL *)url {
    [[VCRCassetteManager defaultManager] setCurrentCassetteURL:url];
}

+ (void)start {
    VCRURLConnectionSwizzle(@selector(initWithRequest:delegate:));
    VCRURLConnectionSwizzle(@selector(initWithRequest:delegate:startImmediately:));
}

+ (void)stop {
    VCRURLConnectionUnswizzle(@selector(initWithRequest:delegate:));
    VCRURLConnectionUnswizzle(@selector(initWithRequest:delegate:startImmediately:));
}

@end

static Method VCRMethodWithPrefix(NSString *prefix, SEL selector) {
    NSString *name = NSStringFromSelector(selector);
    NSString *prefixedName = [NSString stringWithFormat:@"%@_%@", prefix, name];
    SEL prefixedSEL = NSSelectorFromString(prefixedName);
    return class_getInstanceMethod([NSURLConnection class], prefixedSEL);
}

static void VCRStoreOriginalImplentation(SEL selector) {
    Method originalMethod = class_getInstanceMethod([NSURLConnection class], selector);
    IMP originalIMP = method_getImplementation(originalMethod);
    Method placeholderMethod = VCRMethodWithPrefix(@"VCR_original", selector);
    method_setImplementation(placeholderMethod, originalIMP);
}

static void VCRURLConnectionSwizzle(SEL selector) {
    Method altMethod = VCRMethodWithPrefix(@"VCR", selector);
    IMP altIMP = method_getImplementation(altMethod);
    Method originalMethod = class_getInstanceMethod([NSURLConnection class], selector);
    method_setImplementation(originalMethod, altIMP);
}

static void VCRURLConnectionUnswizzle(SEL selector) {
    Method placeholderMethod = VCRMethodWithPrefix(@"VCR_original", selector);
    IMP placeholderIMP = method_getImplementation(placeholderMethod);
    Method originalMethod = class_getInstanceMethod([NSURLConnection class], selector);
    method_setImplementation(originalMethod, placeholderIMP);
}
