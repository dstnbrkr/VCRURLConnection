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

@implementation NSURLConnection (VCR)

- (id)VCR_initWithRequest:(NSURLRequest *)request
                 delegate:(id<NSURLConnectionDelegate>)delegate {
    
    return [self VCR_original_initWithRequest:request delegate:delegate];
}

#pragma mark - Original implementations

- (id)VCR_original_initWithRequest:(NSURLRequest *)request
                         delegate:(id<NSURLConnectionDelegate>)delegate {
    return nil;
}

/*
    id self = nil;
    
    VCRCassette *cassette = [[VCRCassetteManager defaultManager] cassette];
    VCRResponse *response = [cassette responseForRequest:request];
    if (response) {
        [self VCR_simulateResponse:response];
    } else {
        VCRConnectionDelegate *vcrDelegate = [[VCRConnectionDelegate alloc] init];
        vcrDelegate.delegate = delegate;
        vcrDelegate.cassette = cassette;
    }
*/
/*
- (void)VCR_simulateResponse:(VCRResponse *)response {
    // FIXME: call the delegate methods
}
*/

@end
