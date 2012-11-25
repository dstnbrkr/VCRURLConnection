//
//  VCRResponse.h
//  VCRURLConnectionExample
//
//  Created by Dustin Barker on 11/18/12.
//  Copyright (c) 2012 Dustin Barker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VCRResponse : NSObject

- (id)initWithJSON:(id)json;

@property (nonatomic, retain) NSURL *url;

@property (nonatomic, retain) NSData *responseData;

// FIXME: readonly
@property (nonatomic, retain) NSURLResponse *URLResponse;

@end
