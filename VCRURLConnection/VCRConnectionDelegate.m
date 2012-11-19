//
//  VCRConnectionDelegate.m
//  VCRURLConnectionExample
//
//  Created by Dustin Barker on 11/18/12.
//  Copyright (c) 2012 Dustin Barker. All rights reserved.
//

#import "VCRConnectionDelegate.h"

@interface VCRConnectionDelegateWrapper : NSObject<NSURLConnectionDelegate>
@property (nonatomic, retain) id<NSURLConnectionDelegate> wrapped;
@end


@interface VCRConnectionDelegate () {
    VCRConnectionDelegateWrapper *_wrapper;
}
@end


@implementation VCRConnectionDelegate

- (id)initWithDelegate:(id<NSURLConnectionDelegate>)delegate {
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

@synthesize wrapped = _wrapped;

- (void)dealloc {
    [_wrapped release];
    [super dealloc];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // FIXME: record response
    
    [self forwardSelector:@selector(connection:didReceiveResponse:)];
}

- (void)forwardSelector:(SEL)selector {
    if ([_wrapped respondsToSelector:selector]) {
        [_wrapped performSelector:selector];
    }
}

@end