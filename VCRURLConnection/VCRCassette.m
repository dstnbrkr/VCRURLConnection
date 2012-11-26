//
//  VCRCassette.m
//  VCRURLConnectionExample
//
//  Created by Dustin Barker on 11/18/12.
//  Copyright (c) 2012 Dustin Barker. All rights reserved.
//

#import "VCRCassette.h"
#import "VCRCassette_Private.h"
#import "VCRResponse.h"


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
            [self.responseDictionary setObject:response forKey:request];
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

- (void)setResponse:(VCRResponse *)response forRequest:(NSURLRequest *)request {
    [self.responseDictionary setObject:response forKey:request];
}

- (VCRResponse *)responseForRequest:(NSURLRequest *)request {
    return [self.responseDictionary objectForKey:request];
}

- (BOOL)isEqual:(VCRCassette *)cassette {
    return [self.responseDictionary isEqual:cassette.responseDictionary];
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
