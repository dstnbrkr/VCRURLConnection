//
// VCRRequest.m
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

#import "VCRRequestKey.h"

@interface VCRRequestKey ()
@property (nonatomic, retain, readwrite) NSURL *url;
@property (nonatomic, retain, readwrite) NSString *method;
@end

@implementation VCRRequestKey

+ (VCRRequestKey *)keyForRequest:(NSURLRequest *)request {
    VCRRequestKey *key = [[[VCRRequestKey alloc] init] autorelease];
    key.url = request.URL;
    key.method = request.HTTPMethod;
    return key;
}

- (id)JSON {
    return @{ @"url": [self.url absoluteString] };
}

- (BOOL)isEqual:(VCRRequestKey *)key {
    return self.hash == key.hash && [self.url isEqual:key.url];
}

- (NSUInteger)hash {
    return [self.method hash] ^ [self.url hash];
}

- (id)copyWithZone:(NSZone *)zone {
    VCRRequestKey *key = [[[self class] alloc] init];
    if (key) {
        key.url = [[self.url copyWithZone:zone] autorelease];
        key.method = [[self.method copyWithZone:zone] autorelease];
    }
    return key;
}

@end
