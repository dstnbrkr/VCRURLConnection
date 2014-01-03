//
//  VCRURLLoader.m
//  VCRURLConnection
//
//  Created by Dustin Barker on 1/3/14.
//
//

#define __VCR_USE_NSURLSESSION 1

#import "VCRURLLoader.h"

@interface VCRURLLoader ()
@property (nonatomic, weak) id<VCRURLLoaderDelegate> delegate;
@property (nonatomic, strong) NSData *data;
@end

@implementation VCRURLLoader

- (id)initWithDelegate:(id<VCRURLLoaderDelegate>)delegate {
    self = [super init];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

- (void)loadURL:(NSURL *)url {
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

#pragma mark NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse *)response {
    [self.delegate URLLoader:self didReceiveResponse:response];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if (self.data) {
        NSMutableData *currentData = [NSMutableData dataWithData:self.data];
        [currentData appendData:data];
        self.data = currentData;
    } else {
        self.data = data;
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self.delegate URLLoader:self didLoadData:self.data];
    [self.delegate URLLoader:self didFailWithError:error];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self.delegate URLLoader:self didLoadData:self.data];
    [self.delegate URLLoaderDidFinishLoading:self];
}

@end
