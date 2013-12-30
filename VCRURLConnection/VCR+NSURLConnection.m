//
// VCR+NSURLConnection.m
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

#import "VCR+NSURLConnection.h"
#import "VCRCassette.h"
#import "VCRCassetteManager.h"
#import "VCRConnectionDelegate.h"
#import <objc/objc-runtime.h>

//
// Note: Both of the NSURLConnection initializers must be swizzled as initWithRequest:delegate: apparently does not call
// initWithRequest:delegate:startImmediately:
//

typedef id(*URLConnectionInitializer1)(id, SEL, NSURLRequest *, id<NSURLConnectionDelegate>, BOOL);
typedef id(*URLConnectionInitializer2)(id, SEL, NSURLRequest *, id<NSURLConnectionDelegate>);

static URLConnectionInitializer1 orig_URLConnectionInitializer1;
static URLConnectionInitializer2 orig_URLConnectionInitializer2;

static void VCRURLConnectionPlayback(id self, VCRRecording *recording, id delegate) {
    if ([delegate respondsToSelector:@selector(connection:didReceiveResponse:)]) {
        NSURLResponse *response = [recording HTTPURLResponse];
        [delegate connection:self didReceiveResponse:response];
    }
    
    if ([delegate respondsToSelector:@selector(connection:didReceiveData:)]) {
        [delegate connection:self didReceiveData:recording.data];
    }
    
    if ([delegate respondsToSelector:@selector(connectionDidFinishLoading:)]) {
        [delegate connectionDidFinishLoading:self];
    }
    
    if (recording.error && [delegate respondsToSelector:@selector(connection:didFailWithError:)]) {
        [delegate connection:self didFailWithError:recording.error];
    }
}

id VCR_URLConnectionInitializer1(id self, SEL _cmd, NSURLRequest *request, id<NSURLConnectionDataDelegate> delegate, BOOL startImmediately) {
    VCRCassette *cassette = [[VCRCassetteManager defaultManager] currentCassette];
    VCRRecording *recording = [cassette recordingForRequest:request];
    if (recording) {
        self = [self init];
        dispatch_async(dispatch_get_main_queue(), ^{
            VCRURLConnectionPlayback(self, recording, delegate);
        });
    } else {
        VCRRecording *recording = [[VCRRecording alloc] init];
        recording.URI = [request.URL absoluteString];
        recording.method = request.HTTPMethod;
        
        VCRConnectionDelegate *vcrDelegate = [[VCRConnectionDelegate alloc] initWithDelegate:delegate recording:recording];
        [vcrDelegate setRequest:request];
        vcrDelegate.cassette = cassette;
        self = orig_URLConnectionInitializer1(self, _cmd, request, vcrDelegate, startImmediately);
    }
    return self;
}

id VCR_URLConnectionInitializer2(id self, SEL _cmd, NSURLRequest *request, id<NSURLConnectionDataDelegate> delegate) {
    return VCR_URLConnectionInitializer1(self, _cmd, request, delegate, YES);
}

Method VCRGetURLConnectionMethod(SEL selector) {
    Class clazz = [NSURLConnection class];
    return class_getInstanceMethod(clazz, selector);
}

Method VCRGetURLConnectionInitializerMethod1() {
    return VCRGetURLConnectionMethod(@selector(initWithRequest:delegate:startImmediately:));
}

Method VCRGetURLConnectionInitializerMethod2() {
    return VCRGetURLConnectionMethod(@selector(initWithRequest:delegate:));
}

void VCRSwizzleNSURLConnection() {
    method_setImplementation(VCRGetURLConnectionInitializerMethod1(), (IMP)VCR_URLConnectionInitializer1);
    method_setImplementation(VCRGetURLConnectionInitializerMethod2(), (IMP)VCR_URLConnectionInitializer2);
}

void VCRUnswizzleNSURLConnection() {
    method_setImplementation(VCRGetURLConnectionInitializerMethod1(), (IMP)orig_URLConnectionInitializer1);
    method_setImplementation(VCRGetURLConnectionInitializerMethod2(), (IMP)orig_URLConnectionInitializer2);
}

@implementation VCR (NSURLConnection)

+ (void)load {
    orig_URLConnectionInitializer1 = (URLConnectionInitializer1)method_getImplementation(VCRGetURLConnectionInitializerMethod1());
    orig_URLConnectionInitializer2 = (URLConnectionInitializer2)method_getImplementation(VCRGetURLConnectionInitializerMethod2());
}

@end
