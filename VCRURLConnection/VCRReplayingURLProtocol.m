//
//  VCRReplayingURLProtocol.m
//  VCRURLConnection
//
//  Created by Dustin Barker on 1/2/14.
//
//

#import "VCRReplayingURLProtocol.h"
#import "VCRCassette.h"
#import "VCRCassetteManager.h"
#import "VCRRecording.h"

@implementation VCRReplayingURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    return [self recordingForRequest:request] && ([request.URL.scheme isEqualToString:@"https"] || [request.URL.scheme isEqualToString:@"http"]);
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}

+ (VCRRecording *)recordingForRequest:(NSURLRequest *)request {
    VCRCassette *cassette = [[VCRCassetteManager defaultManager] currentCassette];
    return [cassette recordingForRequest:request];
}

- (void)startLoading {
    VCRRecording *recording = [[self class] recordingForRequest:self.request];
    NSURL *url = [NSURL URLWithString:recording.URI];
    NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:url
                                                              statusCode:recording.statusCode
                                                             HTTPVersion:@"HTTP/1.1"
                                                            headerFields:recording.headerFields];
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    [self.client URLProtocol:self didLoadData:recording.data];
    [self.client URLProtocolDidFinishLoading:self];
}

- (void)stopLoading {
    // do nothing
}

@end
