//
//  VCRRecordingURLProtocol.m
//  VCRURLConnection
//
//  Created by Dustin Barker on 12/31/13.
//
//

#import "VCRRecordingURLProtocol.h"
#import "VCRRecording.h"
#import "VCRCassette.h"
#import "VCRCassetteManager.h"

static NSString * const VCRIsRecordingRequestKey = @"VCR_recording";

@interface VCRRecordingURLProtocol ()
@property (nonatomic, strong) VCRRecording *recording;
@end

@implementation VCRRecordingURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    BOOL isAlreadyRecordingRequest = [[self propertyForKey:VCRIsRecordingRequestKey inRequest:request] boolValue];
    BOOL isHTTP = [request.URL.scheme isEqualToString:@"https"] || [request.URL.scheme isEqualToString:@"http"];
    return !isAlreadyRecordingRequest && isHTTP;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}

- (id)initWithRequest:(NSURLRequest *)request cachedResponse:(NSCachedURLResponse *)cachedResponse client:(id<NSURLProtocolClient >)client {
    return [super initWithRequest:request cachedResponse:nil client:client];
}

- (void)startLoading {
    NSURLRequest *request = self.request;
    VCRRecording *recording = [[VCRRecording alloc] init];
    recording.method = request.HTTPMethod;
    recording.URI = [[request URL] absoluteString];
    self.recording = recording;
    
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    [[self class] setProperty:@(YES) forKey:VCRIsRecordingRequestKey inRequest:mutableRequest];
    [NSURLConnection connectionWithRequest:mutableRequest delegate:self];
}

- (void)stopLoading {
    // do nothing
}

#pragma mark = NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse *)response {
    self.recording.headerFields = response.allHeaderFields;
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if (self.recording.data) {
        NSMutableData *currentData = [NSMutableData dataWithData:self.recording.data];
        [currentData appendData:data];
        self.recording.data = currentData;
    } else {
        self.recording.data = data;
    }
    [self.client URLProtocol:self didLoadData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    self.recording.error = error;
    [[[VCRCassetteManager defaultManager] currentCassette] addRecording:self.recording];
    [self.client URLProtocol:self didFailWithError:error];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [[[VCRCassetteManager defaultManager] currentCassette] addRecording:self.recording];
    [self.client URLProtocolDidFinishLoading:self];
}

@end


