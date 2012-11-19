//
//  VCRConnectionDelegate.m
//  VCRURLConnectionExample
//
//  Created by Dustin Barker on 11/18/12.
//  Copyright (c) 2012 Dustin Barker. All rights reserved.
//

#import "VCRConnectionDelegate.h"

@interface VCRConnectionDelegateWrapper : NSObject<NSURLConnectionDelegate>
@property (nonatomic, readonly) VCRResponse *response;
@property (nonatomic, retain) id<NSURLConnectionDataDelegate> wrapped;
@end


@interface VCRConnectionDelegate () {
    VCRConnectionDelegateWrapper *_wrapper;
}
@end


@implementation VCRConnectionDelegate

- (id)initWithDelegate:(id<NSURLConnectionDataDelegate>)delegate {
    if ((self = [super init])) {
        _wrapper = [[VCRConnectionDelegateWrapper alloc] init];
        _wrapper.wrapped = delegate;
    }
    return self;
}

- (void)dealloc {
    [_wrapper release];
    [super dealloc];
}

- (BOOL)respondsToSelector:(SEL)selector {
    return [_wrapper respondsToSelector:selector] || [_wrapper.wrapped respondsToSelector:selector];
}

- (id)forwardingTargetForSelector:(SEL)selector {
    return [_wrapper respondsToSelector:selector] ? _wrapper : _wrapper.wrapped;
}

@end
             
@implementation VCRConnectionDelegateWrapper

@synthesize response = _response;
@synthesize wrapped = _wrapped;

- (id)init {
    if ((self = [super init])) {
        _response = [[VCRResponse alloc] init];
    }
    return self;
}

- (void)dealloc {
    [_wrapped release];
    [super dealloc];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [_response setURLResponse:response];
    if ([_wrapped respondsToSelector:@selector(connection:didReceiveResponse:)]) {
        [_wrapped connection:connection didReceiveResponse:response];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if (!_response.responseData) {
        _response.responseData = data;
    } else {
        // FIXME: append data
    }
    if ([_wrapped respondsToSelector:@selector(connection:didReceiveData:)]) {
        [_wrapped connection:connection didReceiveData:data];
    }
}

@end