//
//  VCRCassette.h
//  VCRURLConnectionExample
//
//  Created by Dustin Barker on 11/18/12.
//  Copyright (c) 2012 Dustin Barker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VCRCassette : NSObject

+ (VCRCassette *)cassette;

+ (VCRCassette *)cassetteWithURL:(NSURL *)url;

- (id)initWithData:(NSData *)data;

- (id)initWithJSON:(id)json;

@end
