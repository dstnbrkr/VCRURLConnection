//
// NSURLConnection+VCR.m
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

#import "NSURLConnection+VCR.h"
#import "VCRCassetteManager.h"
#import "VCRConnectionDelegate.h"
#import "VCRResponse.h"

@implementation NSURLConnection (VCR)

- (id)VCR_original_initWithRequest:(NSURLRequest *)request delegate:(id<NSURLConnectionDelegate>)delegate {
    return nil;
}

- (id)VCR_original_initWithRequest:(NSURLRequest *)request delegate:(id<NSURLConnectionDelegate>)delegate startImmediately:(BOOL)startImmediately {
    return nil;
}

- (id)VCR_initWithRequest:(NSURLRequest *)request delegate:(id<NSURLConnectionDataDelegate>)delegate {
    return [self VCR_initWithRequest:request delegate:delegate startImmediately:YES];
}

- (id)VCR_initWithRequest:(NSURLRequest *)request delegate:(id<NSURLConnectionDataDelegate>)delegate startImmediately:(BOOL)startImmediately {
    VCRCassette *cassette = [[VCRCassetteManager defaultManager] currentCassette];
    VCRResponse *response = [cassette responseForRequest:request];
    if (response) {
        self = [self init];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self VCR_simulateResponse:response delegate:delegate];
        });
    } else {
        VCRConnectionDelegate *vcrDelegate = [[[VCRConnectionDelegate alloc] initWithDelegate:delegate] autorelease];
        [vcrDelegate setRequest:request];
        vcrDelegate.cassette = cassette;
        self = [self VCR_original_initWithRequest:request delegate:vcrDelegate startImmediately:startImmediately];
    }
    return self;
}

- (void)VCR_simulateResponse:(VCRResponse *)vcrResponse delegate:(id)delegate {
    if ([delegate respondsToSelector:@selector(connection:didReceiveResponse:)]) {
        NSURLResponse *response = [vcrResponse generateHTTPURLResponse];
        [delegate connection:self didReceiveResponse:response];
    }
    
    if ([delegate respondsToSelector:@selector(connection:didReceiveData:)]) {
        [delegate connection:self didReceiveData:vcrResponse.responseData];
    }
    
    if ([delegate respondsToSelector:@selector(connectionDidFinishLoading:)]) {
        [delegate connectionDidFinishLoading:self];
    }
    
    if ((vcrResponse.statusCode < 200 || 299 < vcrResponse.statusCode) &&
        [delegate respondsToSelector:@selector(connection:didFailWithError:)]) {
        
        // FIXME: store details of NSError in VCRResponse and populate here
        NSError *error = [[[NSError alloc] init] autorelease];
        [delegate connection:self didFailWithError:error];
    }
}

@end