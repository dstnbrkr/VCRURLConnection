//
//  VCRCassette.m
//  VCRURLConnectionExample
//
//  Created by Dustin Barker on 11/18/12.
//  Copyright (c) 2012 Dustin Barker. All rights reserved.
//

#import "VCRCassette.h"

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
    if ((self = [super init])) {
        // FIXME: init with JSON
    }
    return self;
}

@end
