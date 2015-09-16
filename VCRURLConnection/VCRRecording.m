//
// VCRRecording.m
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

#import "VCRRecording.h"
#import "VCROrderedMutableDictionary.h"
#import "VCRError.h"
#import <MobileCoreServices/MobileCoreServices.h>

// For -[NSData initWithBase64Encoding:] and -[NSData base64Encoding]
// Remove when targetting iOS 7+, use -[NSData initWithBase64EncodedString:options:] and -[NSData base64EncodedStringWithOptions:] instead
#pragma clang diagnostic ignored "-Wdeprecated"

@implementation VCRRecording

- (id)initWithJSON:(id)json {
    if ((self = [self init])) {
        
        self.method = json[@"method"];
        NSAssert(self.method, @"VCRRecording: method is required");
        
        self.URI = json[@"uri"];
        NSAssert(self.URI, @"VCRRecording: uri is required");

        self.statusCode = [json[@"status"] intValue];

        self.headerFields = json[@"headers"];
        if (!self.headerFields) {
            self.headerFields = [NSDictionary dictionary];
        }
        
        NSString *responseBody = json[@"responseBody"];
        [self setResponseBody:responseBody];

        NSString *requestBody = json[@"requestBody"];
        [self setRequestBody:requestBody];

        if (json[@"error"]) {
            self.error = [[VCRError alloc] initWithJSON:json[@"error"]];
        }
    }
    return self;
}

- (BOOL)isEqual:(VCRRecording *)recording {
    return  [self.method isEqualToString:recording.method] &&
            [self.URI isEqualToString:recording.URI] &&
            ((self.requestBodyData == nil && recording.requestBodyData == nil) || [self.requestBodyData isEqualToData:recording.requestBodyData]);
}

- (NSUInteger)hash {
    const NSUInteger prime = 17;
    NSUInteger hash = 1;
    hash = prime * hash + [self.method hash];
    hash = prime * hash + [self.URI hash];
    hash = prime * hash + [self.requestBodyData hash];
    return hash;
}

- (BOOL)isText {
    NSString *type = [[self HTTPURLResponse] MIMEType] ?: @"text/plain";
    if ([@[ @"application/x-www-form-urlencoded" ] containsObject:type]) {
        return YES;
    }
    CFStringRef uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, (__bridge CFStringRef)type, NULL);
    BOOL isText = UTTypeConformsTo(uti, kUTTypeText);
    if (uti) {
        CFRelease(uti);
    }
    return isText;
}

- (void)setResponseBody:(NSString * _Nullable)responseBody
{
    if ([responseBody isKindOfClass:[NSDictionary class]]) {
        self.responseBodyData = [NSJSONSerialization dataWithJSONObject:responseBody options:0 error:nil];
    } else if ([self isText]) {
        self.responseBodyData = [responseBody dataUsingEncoding:NSUTF8StringEncoding];
    } else if ([responseBody isKindOfClass:[NSString class]]) {
        self.responseBodyData = [[NSData alloc] initWithBase64Encoding:responseBody];
    }
}

- (NSString *)responseBody {
    if ([self isText]) {
        return [[NSString alloc] initWithData:self.responseBodyData encoding:NSUTF8StringEncoding];
    } else {
        return [self.responseBodyData base64Encoding];
    }
}

- (void)setRequestBody:(NSString * _Nullable)requestBody
{
    if ([requestBody isKindOfClass:[NSDictionary class]]) {
        self.requestBodyData = [NSJSONSerialization dataWithJSONObject:requestBody options:0 error:nil];
    } else if ([self isText]) {
        self.requestBodyData = [requestBody dataUsingEncoding:NSUTF8StringEncoding];
    } else if ([requestBody isKindOfClass:[NSString class]]) {
        self.requestBodyData = [[NSData alloc] initWithBase64Encoding:requestBody];
    }
}

- (NSString *)requestBody {
    if ([self isText]) {
        return [[NSString alloc] initWithData:self.requestBodyData encoding:NSUTF8StringEncoding];
    } else {
        return [self.requestBodyData base64Encoding];
    }
}

- (id)JSON {
    NSDictionary *infoDict = @{@"method": self.method, @"status": @(self.statusCode), @"uri": self.URI};
    VCROrderedMutableDictionary *dictionary = [VCROrderedMutableDictionary dictionaryWithDictionary:infoDict];
    
    if (self.headerFields) {
        dictionary[@"headers"] = self.headerFields;
    }
    
    if (self.responseBody) {
        dictionary[@"responseBody"] = self.responseBody;
    }
    
    if (self.requestBody) {
        dictionary[@"requestBody"] = self.requestBody;
    }
    
    NSError *error = self.error;
    if (error) {
        dictionary[@"error"] = [VCRError JSONForError:error];
    }
    
    VCROrderedMutableDictionary *sortedDict = [VCROrderedMutableDictionary dictionaryWithCapacity:[infoDict count]];
    [[dictionary sortedKeys] enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        sortedDict[key] = dictionary[key];
    }];
    
    return sortedDict;
}


- (NSString *)description {
    return [NSString stringWithFormat:@"<VCRRecording %@ %@, request data length %li>", self.method, self.URI, (unsigned long)[self.requestBodyData length]];
}

- (NSHTTPURLResponse *)HTTPURLResponse {
    NSURL *url = [NSURL URLWithString:_URI];
    return [[NSHTTPURLResponse alloc] initWithURL:url
                                       statusCode:_statusCode
                                      HTTPVersion:@"HTTP/1.1"
                                     headerFields:_headerFields];
}

@end

