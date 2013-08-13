//
// VCRConnectionDelegate.m
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

#import "VCRConnectionDelegate.h"
#import "VCRCassetteManager.h"
#import "VCRRecording.h"
#import "VCR.h"

@interface VCRConnectionDelegateWrapper : NSObject<NSURLConnectionDelegate>
@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, strong) VCRRecording *recording;
@property (nonatomic, strong) id<NSURLConnectionDataDelegate> wrapped;
@end


@interface VCRConnectionDelegate () {
    VCRConnectionDelegateWrapper *_wrapper;
}
@end


@implementation VCRConnectionDelegate

@dynamic request;

- (id)initWithDelegate:(id<NSURLConnectionDataDelegate>)delegate {
    if ((self = [super init])) {
        _wrapper = [[VCRConnectionDelegateWrapper alloc] init];
        _wrapper.wrapped = delegate;
    }
    return self;
}


- (BOOL)respondsToSelector:(SEL)selector {
    return [_wrapper respondsToSelector:selector] || [_wrapper.wrapped respondsToSelector:selector];
}

- (id)forwardingTargetForSelector:(SEL)selector {
    return [_wrapper respondsToSelector:selector] ? _wrapper : _wrapper.wrapped;
}

@end
             
@implementation VCRConnectionDelegateWrapper

@synthesize request = _request;
@synthesize wrapped = _wrapped;

- (id)init {
    if ((self = [super init])) {
        self.recording = [[VCRRecording alloc] init];
    }
    return self;
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse *)response {
    _recording.method = self.request.HTTPMethod;
    [_recording recordResponse:response];
    if ([_wrapped respondsToSelector:@selector(connection:didReceiveResponse:)]) {
        [_wrapped connection:connection didReceiveResponse:response];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if (self.recording.data) {
        NSMutableData *currentData = [NSMutableData dataWithData:self.recording.data];
        [currentData appendData:data];
        self.recording.data = currentData;
    } else {
        self.recording.data = data;
    }
    if ([_wrapped respondsToSelector:@selector(connection:didReceiveData:)]) {
        [_wrapped connection:connection didReceiveData:data];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [[VCR cassette] addRecording:self.recording];
        
    if ([_wrapped respondsToSelector:@selector(connectionDidFinishLoading:)]) {
        [_wrapped connectionDidFinishLoading:connection];
    }
}

@end