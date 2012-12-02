//
//  VCRResponse.m
//  VCRURLConnectionExample
//
//  Created by Dustin Barker on 11/18/12.
//  Copyright (c) 2012 Dustin Barker. All rights reserved.
//

#import "VCRResponse.h"

@interface VCRResponse ()

@property (nonatomic, retain, readwrite) NSDictionary *headerFields;

@end

@implementation VCRResponse

- (id)initWithJSON:(id)json {
    if ((self = [self init])) {
        self.url = [NSURL URLWithString:[json objectForKey:@"url"]];
        self.statusCode = [[json objectForKey:@"statusCode"] intValue];
        self.responseData = [[json objectForKey:@"body"] dataUsingEncoding:NSUTF8StringEncoding];
        self.headerFields = [json objectForKey:@"headers"];
        if (!self.headerFields) {
            self.headerFields = [NSDictionary dictionary];
        }
    }
    return self;
}

- (BOOL)isEqual:(VCRResponse *)response {
    return [self.url isEqual:response.url] && [self.responseData isEqual:response.responseData];
}

- (void)recordHTTPURLResponse:(NSHTTPURLResponse *)response {
    self.url = response.URL;
    self.headerFields = [response allHeaderFields];
    self.statusCode = response.statusCode;
}

- (NSHTTPURLResponse *)generateHTTPURLResponse {
    return [[[NSHTTPURLResponse alloc] initWithURL:self.url
                                        statusCode:self.statusCode
                                       HTTPVersion:@"HTTP/1.1"         // FIXME: don't hardcode, but make default
                                      headerFields:nil] autorelease];
}

- (void)dealloc {
    self.url = nil;
    self.headerFields = nil;
    [super dealloc];
}

@end
