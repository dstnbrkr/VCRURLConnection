//
//  NSURLConnection+VCR.m
//  VCRURLConnectionExample
//
//  Created by Dustin Barker on 11/18/12.
//  Copyright (c) 2012 Dustin Barker. All rights reserved.
//

#import "NSURLConnection+VCR.h"
#import "VCRCassetteManager.h"
#import "VCRConnectionDelegate.h"
#import "VCRResponse.h"

@implementation NSURLConnection (VCR)

- (id)VCR_original_initWithRequest:(NSURLRequest *)request delegate:(id<NSURLConnectionDelegate>)delegate {
    return nil;
}

- (id)VCR_initWithRequest:(NSURLRequest *)request delegate:(id<NSURLConnectionDataDelegate>)delegate {
    VCRCassette *cassette = [[VCRCassetteManager defaultManager] currentCassette];
    VCRResponse *response = [cassette responseForRequest:request];
    if (response) {
        [self VCR_simulateResponse:response];
        self = nil;
    } else {
        VCRConnectionDelegate *vcrDelegate = [[[VCRConnectionDelegate alloc] initWithDelegate:delegate] autorelease];
        [vcrDelegate setRequest:request];
        vcrDelegate.cassette = cassette;
        self = [self VCR_original_initWithRequest:request delegate:vcrDelegate];
    }
    return self;
}

- (void)VCR_simulateResponse:(VCRResponse *)response {
    NSLog(@"VCR_simulateResponse");
}


@end