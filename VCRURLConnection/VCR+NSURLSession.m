//
//  VCR+NSURLSession.m
//  VCRURLConnection
//
//  Created by Dustin Barker on 12/29/13.
//
//

#import "VCR+NSURLSession.h"
#import "VCRURLSessionDelegate.h"
#import <Foundation/Foundation.h>
#import <objc/runtime.h>

typedef NSURLSession *(*URLSessionConstructor)(id, SEL, NSURLSessionConfiguration *, id<NSURLSessionDelegate>, NSOperationQueue *);

URLSessionConstructor orig_URLSessionConstructor;

static NSURLSession *VCR_URLSessionConstructor(id self,
                                               SEL _cmd,
                                               NSURLSessionConfiguration *configuration,
                                               id<NSURLSessionDelegate> delegate,
                                               NSOperationQueue *delegateQueue) {
    
    //VCRURLSessionDelegate *wrappedDelegate = [[VCRURLSessionDelegate alloc] init];
    return orig_URLSessionConstructor(self, _cmd, configuration, delegate, delegateQueue);
}

Method VCRGetURLSessionConstructorMethod() {
    Class clazz = object_getClass([NSURLSession class]);
    SEL selector = @selector(sessionWithConfiguration:delegate:delegateQueue:);
    return class_getClassMethod(clazz, selector);
}

void VCRSwizzleNSURLSession() {
    Method method = VCRGetURLSessionConstructorMethod();
    method_setImplementation(method, (IMP)VCR_URLSessionConstructor);
}

void VCRUnswizzleNSURLSession() {
    Method method = VCRGetURLSessionConstructorMethod();
    method_setImplementation(method, (IMP)orig_URLSessionConstructor);
}

@implementation VCR (NSURLSession)

+ (void)load {
    Method method = VCRGetURLSessionConstructorMethod();
    orig_URLSessionConstructor = (URLSessionConstructor)method_getImplementation(method);
}

@end
