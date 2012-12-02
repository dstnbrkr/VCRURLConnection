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
        self = [self init];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self VCR_simulateResponse:response delegate:delegate];
        });
    } else {
        VCRConnectionDelegate *vcrDelegate = [[[VCRConnectionDelegate alloc] initWithDelegate:delegate] autorelease];
        [vcrDelegate setRequest:request];
        vcrDelegate.cassette = cassette;
        self = [self VCR_original_initWithRequest:request delegate:vcrDelegate];
    }
    return self;
}

- (void)VCR_simulateResponse:(VCRResponse *)vcrResponse delegate:(id)delegate {
    if ([delegate respondsToSelector:@selector(connection:didReceiveResponse:)]) {
        NSURLResponse *response = [vcrResponse generateHTTPURLResponse];
        [delegate connection:self didReceiveResponse:response];
    }
    
    if ([delegate respondsToSelector:@selector(connection:didReceiveData:)]) {
        [delegate connection:self didReceiveData:vcrResponse.responseData];
    }
    
    if ([delegate respondsToSelector:@selector(connectionDidFinishLoading:)]) {
        [delegate connectionDidFinishLoading:self];
    }
    
    if ((vcrResponse.statusCode < 200 || 299 < vcrResponse.statusCode) &&
        [delegate respondsToSelector:@selector(connection:didFailWithError:)]) {
        
        // FIXME: store details of NSError in VCRResponse and populate here
        NSError *error = [[[NSError alloc] init] autorelease];
        [delegate connection:self didFailWithError:error];
    }
}

@end