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
#import "VCRConnectionDelegate.h"
#import <objc/runtime.h>


@implementation VCR

typedef id(*URLConnectionInitializer1)(id, SEL, NSURLRequest *, id<NSURLConnectionDelegate>, BOOL);
typedef id(*URLConnectionInitializer2)(id, SEL, NSURLRequest *, id<NSURLConnectionDelegate>);

static BOOL recordingDuplicates = NO;

static URLConnectionInitializer1 orig_initWithRequest1;
static URLConnectionInitializer2 orig_initWithRequest2;

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

static id VCR_initWithRequest1(id self, SEL _cmd, NSURLRequest *request, id<NSURLConnectionDataDelegate> delegate, BOOL startImmediately) {
    VCRCassette *cassette = [[VCRCassetteManager defaultManager] currentCassette];
    VCRRecording *recording = [cassette recordingForRequest:request];
    if (recording && !VCR.recordingDuplicates) {
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
        self = orig_initWithRequest1(self, _cmd, request, vcrDelegate, startImmediately);
    }
    return self;
}

static id VCR_initWithRequest2(id self, SEL _cmd, NSURLRequest *request, id<NSURLConnectionDataDelegate> delegate) {
    return VCR_initWithRequest1(self, _cmd, request, delegate, YES);
}

static BOOL VCRIsSwizzled(SEL selector, IMP impl) {
    Method method = class_getInstanceMethod([NSURLConnection class], selector);
    return method_getImplementation(method) == impl;
}

static IMP VCRSwizzle(SEL selector, IMP newImpl) {
    Class clazz = [NSURLConnection class];
    
    Method method = class_getInstanceMethod(clazz, selector);
    IMP originalImpl = method_getImplementation(method);
    
    class_replaceMethod(clazz, selector, (IMP)newImpl, method_getTypeEncoding(method));
    
    return originalImpl;
}

+ (void)loadCassetteWithContentsOfURL:(NSURL *)url {
    [[VCRCassetteManager defaultManager] setCurrentCassetteURL:url];
}

+ (VCRCassette *)cassette {
    return [[VCRCassetteManager defaultManager] currentCassette];
}

+ (void)start {
    recordingDuplicates = NO;
    SEL sel1 = @selector(initWithRequest:delegate:startImmediately:);
    SEL sel2 = @selector(initWithRequest:delegate:);
    
    IMP imp1 = (IMP)VCR_initWithRequest1;
    IMP imp2 = (IMP)VCR_initWithRequest2;

    if (!VCRIsSwizzled(sel1, imp1)) {
        orig_initWithRequest1 = (URLConnectionInitializer1)VCRSwizzle(sel1, imp1);
    }
    
    if (!VCRIsSwizzled(sel2, imp2)) {
        orig_initWithRequest2 = (URLConnectionInitializer2)VCRSwizzle(sel2, imp2);
    }
}

+ (void)startRecordingDuplicates {
    [VCR start];
    recordingDuplicates = YES;
}

+ (void)stop {
    VCRSwizzle(@selector(initWithRequest:delegate:startImmediately:), (IMP)orig_initWithRequest1);
    VCRSwizzle(@selector(initWithRequest:delegate:), (IMP)orig_initWithRequest2);
}

+ (void)save:(NSString *)path {
    return [[VCRCassetteManager defaultManager] save:path];
}

+ (BOOL)recordingDuplicates {
    return recordingDuplicates;
}

@end
