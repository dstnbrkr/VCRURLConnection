//
//  VCRConnectionDelegate.h
//  VCRURLConnectionExample
//
//  Created by Dustin Barker on 11/18/12.
//  Copyright (c) 2012 Dustin Barker. All rights reserved.
//

#import "VCRCassette.h"
#import <Foundation/Foundation.h>

/**
 * A VCRConnectionDelegate intercepts messages from an NSURLConnection to it's delegate
 * and records the response to the current VCRCassette.
 */
@interface VCRConnectionDelegate : NSObject<NSURLConnectionDelegate>

- (id)initWithDelegate:(id<NSURLConnectionDataDelegate>)delegate;

@property (nonatomic, retain) NSURLRequest *request;
@property (nonatomic, retain) VCRCassette *cassette;

@end
