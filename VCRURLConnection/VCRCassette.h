//
//  VCRCassette.h
//  VCRURLConnectionExample
//
//  Created by Dustin Barker on 11/18/12.
//  Copyright (c) 2012 Dustin Barker. All rights reserved.
//

#import "VCRResponse.h"
#import <Foundation/Foundation.h>

@interface VCRCassette : NSObject

+ (VCRCassette *)cassette;

- (id)initWithData:(NSData *)data;

- (id)initWithJSON:(id)json;

- (void)setResponse:(VCRResponse *)response forRequest:(NSURLRequest *)request;

- (VCRResponse *)responseForRequest:(NSURLRequest *)request;

@end
