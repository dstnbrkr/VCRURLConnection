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

#import <Availability.h>
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 50000 || __MAC_OS_X_VERSION_MIN_REQUIRED >= 1090

#import "VCR+NSURLSession.h"
#import "VCRURLSessionDelegate.h"
#import "VCRRecording.h"
#import "VCRCassetteManager.h"
#import <Foundation/Foundation.h>
#import <objc/runtime.h>

typedef NSURLSession *(*URLSessionConstructor)(id, SEL, NSURLSessionConfiguration *, id<NSURLSessionDelegate>, NSOperationQueue *);

typedef NSURLSessionDataTask *(*URLSessionDataTaskWithRequest)(id, SEL, NSURLRequest *, void (^)(NSData *, NSURLResponse *, NSError *));

URLSessionConstructor orig_URLSessionConstructor;

URLSessionDataTaskWithRequest orig_dataTaskWithRequest_completionHandler;

NSURLSession *VCR_URLSessionConstructor(id self,
                                        SEL _cmd,
                                        NSURLSessionConfiguration *configuration,
                                        id<NSURLSessionDelegate> delegate,
                                        NSOperationQueue *delegateQueue) {
    
    VCRURLSessionDelegate *wrappedDelegate = [[VCRURLSessionDelegate alloc] initWithDelegate:delegate];
    return orig_URLSessionConstructor(self, _cmd, configuration, wrappedDelegate, delegateQueue);
}

NSURLSessionDataTask *VCR_dataTaskWithRequest_completionHandler(id self,
                                                                SEL _cmd,
                                                                NSURLRequest *request,
                                                                void(^completionHandler)(NSData *data, NSURLResponse *response, NSError *error)) {
    
    void (^wrappedCompletionHandler)(NSData *, NSURLResponse *, NSError *) = ^(NSData *data, NSURLResponse *response, NSError *error) {
        VCRRecording *recording = [[VCRRecording alloc] init];
        recording.method = request.HTTPMethod;
        recording.URI = [request.URL absoluteString];
        VCRCassette *cassette = [[VCRCassetteManager defaultManager] currentCassette];
        [cassette addRecording:recording];
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response; // FIXME
        recording.headerFields = [httpResponse allHeaderFields];
        recording.data = data;
        recording.error = error;
        
        if (completionHandler) completionHandler(data, response, error);
    };
    
    return orig_dataTaskWithRequest_completionHandler(self, _cmd, request, completionHandler ? wrappedCompletionHandler : nil);
}

Method VCRGetURLSessionConstructorMethod() {
    Class clazz = object_getClass(NSClassFromString(@"NSURLSession"));
    SEL selector = @selector(sessionWithConfiguration:delegate:delegateQueue:);
    return class_getClassMethod(clazz, selector);
}

Method VCRGetDataTaskWithRequest_completionHandlerMethod() {
    Class clazz = [NSURLSession class];
    return class_getInstanceMethod(clazz, @selector(dataTaskWithRequest:completionHandler:));
}

void VCRSwizzleNSURLSession() {
    method_setImplementation(VCRGetURLSessionConstructorMethod(), (IMP)VCR_URLSessionConstructor);
    method_setImplementation(VCRGetDataTaskWithRequest_completionHandlerMethod(), (IMP)VCR_dataTaskWithRequest_completionHandler);
}

void VCRUnswizzleNSURLSession() {
    method_setImplementation(VCRGetURLSessionConstructorMethod(), (IMP)orig_URLSessionConstructor);
    method_setImplementation(VCRGetDataTaskWithRequest_completionHandlerMethod(), (IMP)orig_dataTaskWithRequest_completionHandler);
}

@implementation VCR (NSURLSession)

+ (void)load {
    orig_URLSessionConstructor = (URLSessionConstructor)method_getImplementation(VCRGetURLSessionConstructorMethod());
    orig_dataTaskWithRequest_completionHandler = (URLSessionDataTaskWithRequest)method_getImplementation(VCRGetDataTaskWithRequest_completionHandlerMethod());
}

@end

#else

void VCRSwizzleNSURLSession() {}

void VCRUnswizzleNSURLSession() {}

#endif
