//
// VCRCassette.m
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

#import "VCRCassette.h"
#import "VCRCassette_Private.h"
#import "VCRResponse.h"
#import "VCRRequestKey.h"


@implementation VCRCassette

+ (VCRCassette *)cassette {
    return [[[VCRCassette alloc] init] autorelease];
}

+ (VCRCassette *)cassetteWithURL:(NSURL *)url {
    NSData *data = [NSData dataWithContentsOfURL:url];
    return [[[VCRCassette alloc] initWithData:data] autorelease];
}

- (id)init {
    if ((self = [super init])) {
        self.responseDictionary = [NSMutableDictionary dictionary];
    }
    return self;
}

- (id)initWithJSON:(id)json {
    NSAssert(json != nil, @"Attempted to intialize VCRCassette with nil JSON");
    if ((self = [self init])) {
        for (id recording in json) {
            NSURLRequest *request = VCRCassetteRequestForJSON(recording);
            VCRResponse *response = [[[VCRResponse alloc] initWithJSON:recording] autorelease];
            [self setResponse:response forRequest:request];
        }
    }
    return self;
}

- (id)initWithData:(NSData *)data {
    NSError *error = nil;
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    NSAssert([error code] == 0, @"Attempted to initialize VCRCassette with invalid JSON");
    return [self initWithJSON:json];
    
}

- (id)JSON {
    NSMutableArray *recordings = [NSMutableArray array];
    for (VCRRequestKey *key in self.responseDictionary.allKeys) {
        VCRResponse *response = [self.responseDictionary objectForKey:key];
        NSDictionary *recording = @{ @"request": [key JSON], @"response": [response JSON] };
        [recordings addObject:recording];
    }
    return recordings;
}

- (NSData *)data {
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:[self JSON]
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:&error];
    if ([error code] != 0) {
        NSLog(@"Error serializing json data %@", error);
    }
    return data;
}

- (void)setResponse:(VCRResponse *)response forRequest:(NSURLRequest *)request {
    VCRRequestKey *key = [VCRRequestKey keyForRequest:request];
    [self.responseDictionary setObject:response forKey:key];
}

- (VCRResponse *)responseForRequest:(NSURLRequest *)request {
    VCRRequestKey *key = [VCRRequestKey keyForRequest:request];
    return [self responseForRequestKey:key];
}

- (BOOL)isEqual:(VCRCassette *)cassette {
    return [self.responseDictionary isEqual:cassette.responseDictionary];
}

- (NSArray *)allKeys {
    return [self.responseDictionary allKeys];
}

- (VCRResponse *)responseForRequestKey:(VCRRequestKey *)key {
    return [self.responseDictionary objectForKey:key];
}

#pragma mark - Private

NSURLRequest *VCRCassetteRequestForJSON(id json) {
    NSURL *url = [NSURL URLWithString:[json objectForKey:@"url"]];
    return [NSURLRequest requestWithURL:url];
}

#pragma mark - Memory

- (void)dealloc {
    self.responseDictionary = nil;
    [super dealloc];
}

@end
