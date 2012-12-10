//
//  VCRConnectionDelegate.m
//  VCRURLConnectionExample
//
//  Created by Dustin Barker on 11/18/12.
//  Copyright (c) 2012 Dustin Barker. All rights reserved.
//

#import "VCRConnectionDelegate.h"
#import "VCRCassetteManager.h"

@interface VCRConnectionDelegateWrapper : NSObject<NSURLConnectionDelegate>
@property (nonatomic, retain) NSURLRequest *request;
@property (nonatomic, retain) VCRResponse *response;
@property (nonatomic, retain) id<NSURLConnectionDataDelegate> wrapped;
@end


@interface VCRConnectionDelegate () {
    VCRConnectionDelegateWrapper *_wrapper;
}
@end


@implementation VCRConnectionDelegate

@dynamic request;

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

@synthesize request = _request;
@synthesize wrapped = _wrapped;

- (id)init {
    if ((self = [super init])) {
        self.response = [[[VCRResponse alloc] init] autorelease];
    }
    return self;
}

- (void)dealloc {
    [_wrapped release];
    self.response = nil;
    [super dealloc];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse *)response {
    [_response recordHTTPURLResponse:response];
    if ([_wrapped respondsToSelector:@selector(connection:didReceiveResponse:)]) {
        [_wrapped connection:connection didReceiveResponse:response];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if (self.response.responseData) {
        NSMutableData *currentData = [NSMutableData dataWithData:self.response.responseData];
        [currentData appendData:data];
        self.response.responseData = currentData;
    } else {
        self.response.responseData = data;
    }
    if ([_wrapped respondsToSelector:@selector(connection:didReceiveData:)]) {
        [_wrapped connection:connection didReceiveData:data];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [[[VCRCassetteManager defaultManager] currentCassette] setResponse:self.response forRequest:self.request];
        
    if ([_wrapped respondsToSelector:@selector(connectionDidFinishLoading:)]) {
        [_wrapped connectionDidFinishLoading:connection];
    }
}

@end