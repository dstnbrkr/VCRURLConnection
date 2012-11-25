//
//  VCRCassette.m
//  VCRURLConnectionExample
//
//  Created by Dustin Barker on 11/18/12.
//  Copyright (c) 2012 Dustin Barker. All rights reserved.
//

#import "VCRCassette.h"
#import "VCRCassette_Private.h"


@implementation VCRCassette

+ (VCRCassette *)cassette {
    return [[[VCRCassette alloc] init] autorelease];
}

+ (VCRCassette *)cassetteWithURL:(NSURL *)url {
    NSData *data = [NSData dataWithContentsOfURL:url];
    return [[[VCRCassette alloc] initWithData:data] autorelease];
}

- (id)initWithData:(NSData *)data {
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    return [self initWithJSON:json];
    
}

- (id)initWithJSON:(id)json {
    if ((self = [self init])) {
        for (id recording in json) {
            NSURLRequest *request = VCRCassetteRequestForJSON(recording);
            NSURLResponse *response = VCRCassetteResponseForJSON(recording);
            [self.responseDictionary setObject:response forKey:request];
        }
    }
    return self;
}

- (id)init {
    if ((self = [super init])) {
        self.responseDictionary = [NSMutableDictionary dictionary];
    }
    return self;
}

- (VCRResponse *)responseForRequest:(NSURLRequest *)request {
    return [self.responseDictionary objectForKey:request];
}

#pragma mark - Private

NSURL *VCRCassetteURLForJSON(id json) {
    return [NSURL URLWithString:[json objectForKey:@"url"]];
}

NSURLRequest *VCRCassetteRequestForJSON(id json) {
    return [NSURLRequest requestWithURL:VCRCassetteURLForJSON(json)];
}

NSURLResponse *VCRCassetteResponseForJSON(id json) {
    NSURL *url = VCRCassetteURLForJSON(json);
    NSString *mimeType = @"text/plain";
    NSInteger length = -1;
    NSString *encoding = @"utf-8";
    
    return [[[NSURLResponse alloc] initWithURL:url
                                      MIMEType:mimeType
                         expectedContentLength:length
                              textEncodingName:encoding] autorelease];
}

#pragma mark - Memory

- (void)dealloc {
    self.responseDictionary = nil;
    [super dealloc];
}

@end
