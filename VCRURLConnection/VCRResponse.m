//
//  VCRResponse.m
//  VCRURLConnectionExample
//
//  Created by Dustin Barker on 11/18/12.
//  Copyright (c) 2012 Dustin Barker. All rights reserved.
//

#import "VCRResponse.h"

@implementation VCRResponse

- (id)initWithJSON:(id)json {
    if ((self = [self init])) {
        self.url = [NSURL URLWithString:[json objectForKey:@"url"]];
        self.statusCode = [[json objectForKey:@"statusCode"] intValue];
        self.responseData = [[json objectForKey:@"body"] dataUsingEncoding:NSUTF8StringEncoding];
    }
    return self;
}

- (BOOL)isEqual:(VCRResponse *)response {
    return [self.url isEqual:response.url] && [self.responseData isEqual:response.responseData];
}

- (NSHTTPURLResponse *)URLResponse {
    return [[[NSHTTPURLResponse alloc] initWithURL:self.url
                                        statusCode:self.statusCode
                                       HTTPVersion:@"HTTP/1.1"         // FIXME: don't hardcode, but make default
                                      headerFields:nil] autorelease];
}

@end
