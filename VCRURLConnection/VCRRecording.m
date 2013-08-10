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
#import "NSData+Base64.h"

@implementation VCRRecording

- (id)initWithJSON:(id)json {
    if ((self = [self init])) {
        
        self.method = [json objectForKey:@"method"];
        NSAssert(self.method, @"VCRRecording: method is required");
        
        self.URI = [json objectForKey:@"uri"];
        NSAssert(self.URI, @"VCRRecording: uri is required");

        self.statusCode = [[json objectForKey:@"status"] intValue];

        self.headerFields = [json objectForKey:@"headers"];
        if (!self.headerFields) {
            self.headerFields = [NSDictionary dictionary];
        }
        
        NSString *body = [json objectForKey:@"body"];
        if ([self isText]) {
            self.data = [body dataUsingEncoding:NSUTF8StringEncoding];
        } else {
            self.data = [NSData dataFromBase64String:body];
        }
    }
    return self;
}

- (BOOL)isEqual:(VCRRecording *)recording {
    return [self.method isEqualToString:recording.method] &&
           [self.URI isEqualToString:recording.URI] &&
           [self.body isEqualToString:recording.body];
}

- (void)recordResponse:(NSHTTPURLResponse *)response {
    self.URI = [response.URL absoluteString];
    self.headerFields = [response allHeaderFields];
    self.statusCode = response.statusCode;
}

- (BOOL)isText {
    NSString *type = [self.headerFields objectForKey:@"Content-Type"] ?: @"text/plain";
    NSArray *types = @[ @"text/plain", @"text/html", @"application/json", @"application/xml" ];
    for (NSString *textType in types) {
        if ([type rangeOfString:textType].location != NSNotFound) return YES;
    }
    return NO;
}

- (NSString *)body {
    if ([self isText]) {
        return [[[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding] autorelease];
    } else {
        return [self.data base64EncodedString];
    }
}

- (id)JSON {
    NSDictionary *infoDict = @{@"method": self.method, @"status": @(self.statusCode), @"uri": self.URI};
    VCROrderedMutableDictionary *dictionary = [VCROrderedMutableDictionary dictionaryWithDictionary:infoDict];
    
    if (self.headerFields) {
        dictionary[@"headers"] = self.headerFields;
    }
    
    if (self.body) {
        dictionary[@"body"] = self.body;
    }
    
    VCROrderedMutableDictionary *sortedDict = [VCROrderedMutableDictionary dictionaryWithCapacity:[infoDict count]];
    [[dictionary sortedKeys] enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        sortedDict[key] = dictionary[key];
    }];
    
    return sortedDict;
}

- (void)dealloc {
    self.method = nil;
    self.URI = nil;
    self.data = nil;
    self.headerFields = nil;
    [super dealloc];
}

@end

@implementation NSHTTPURLResponse (VCRRecording)

+ (NSHTTPURLResponse *)responseFromRecording:(VCRRecording *)recording {
    NSURL *url = [NSURL URLWithString:recording.URI];
    return [[[NSHTTPURLResponse alloc] initWithURL:url
                                        statusCode:recording.statusCode
                                       HTTPVersion:@"HTTP/1.1"
                                      headerFields:recording.headerFields] autorelease];
}

@end
