//
//  VCRURLConnection.m
//  VCRURLConnectionExample
//
//  Created by Dustin Barker on 11/18/12.
//  Copyright (c) 2012 Dustin Barker. All rights reserved.
//

#import "VCRURLConnection.h"
#import "VCRCassette.h"
#import "VCRCassetteManager.h"
#import <objc/runtime.h>

static void VCRURLConnectionSwizzle(SEL selector);

@implementation VCRURLConnection

+ (void)setCassetteLibraryPath:(NSString *)path {
    [[VCRURLConnectionCassetteManager defaultManager] setCassetteLibraryPath:path];
}

+ (void)setCassette:(NSString *)cassette {
    [[VCRURLConnectionCassetteManager defaultManager] setCurrentCassette:cassette];
}

+ (void)start {
    VCRURLConnectionSwizzle(@selector(initWithRequest:delegate:));
}

+ (void)stop {
    
}

#pragma mark - NSURLConnection original methods

- (id)old_initWithRequest:(NSURLRequest *)request delegate:(id<NSURLConnectionDelegate>)delegate {
    return nil;
}

#pragma mark - NSURLConnection replacement methods

- (id)new_initWithRequest:(NSURLRequest *)request delegate:(id<NSURLConnectionDelegate>)delegate {
    NSLog(@"WTF!");
}

@end

static void VCRURLConnectionSwizzle(SEL selector) {
    Method currMethod = class_getInstanceMethod([NSURLConnection class], selector);
    IMP currImplementation = method_getImplementation(currMethod);

    NSString *selectorString = NSStringFromSelector(selector);
    
    // store original implementation
    SEL oldSelector = NSSelectorFromString([NSString stringWithFormat:@"old_%@", selectorString]);
    Method oldMethod = class_getInstanceMethod([VCRURLConnection class], oldSelector);    
    method_setImplementation(oldMethod, currImplementation);
    
    // replace current implementation
    SEL newSelector = NSSelectorFromString([NSString stringWithFormat:@"new_%@", selectorString]);
    Method newMethod = class_getInstanceMethod([VCRURLConnection class], newSelector);
    IMP newImplementation = method_getImplementation(newMethod);
    method_setImplementation(currMethod, newImplementation);
}
