//
// VCR+NSURLSession.m
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

#import "VCR+NSURLSession.h"
#import "VCRURLSessionDelegate.h"
#import <Foundation/Foundation.h>
#import <objc/runtime.h>

typedef NSURLSession *(*URLSessionConstructor)(id, SEL, NSURLSessionConfiguration *, id<NSURLSessionDelegate>, NSOperationQueue *);

URLSessionConstructor orig_URLSessionConstructor;

NSURLSession *VCR_URLSessionConstructor(id self,
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
