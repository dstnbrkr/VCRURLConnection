//
//  VCRURLSessionDelegate.m
//  VCRURLConnection
//
//  Created by Dustin Barker on 12/27/13.
//
//

#import <Availability.h>
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 50000 || __MAC_OS_X_VERSION_MIN_REQUIRED >= 1090

#import "VCRURLSessionDelegate.h"
#import "VCRRecording.h"
#import "VCRCassette.h"
#import "VCRCassetteManager.h"

@interface VCRURLSessionDelegate ()
@property (nonatomic, strong) NSMutableDictionary *recordingDictionary;
@property (nonatomic, strong) id<NSURLSessionDelegate, NSURLSessionDataDelegate, NSURLSessionTaskDelegate> wrapped;
@end

@implementation VCRURLSessionDelegate

- (id)initWithDelegate:(id<NSURLSessionDelegate, NSURLSessionDataDelegate>)delegate {
    if ((self = [super init])) {
        self.wrapped = delegate;
        self.recordingDictionary = [NSMutableDictionary dictionary];
    }
    return self;
}

- (VCRRecording *)recordingForRequest:(NSURLRequest *)request {
    VCRRecording *recording = [self.recordingDictionary objectForKey:request];
    if (!recording) {
        recording = [[VCRRecording alloc] init];
        recording.method = request.HTTPMethod;
        recording.URI = [request.URL absoluteString];
        VCRCassette *cassette = [[VCRCassetteManager defaultManager] currentCassette];
        [cassette addRecording:recording];
        [self.recordingDictionary setObject:recording forKey:request];
    }
    return recording;
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    VCRRecording *recording = [self recordingForRequest:dataTask.currentRequest];
    if (recording.data) {
        NSMutableData *currentData = [NSMutableData dataWithData:recording.data];
        [currentData appendData:data];
        recording.data = currentData;
    } else {
        recording.data = [NSData dataWithData:data];
    }
    if ([_wrapped respondsToSelector:@selector(URLSession:dataTask:didReceiveData:)]) {
        [_wrapped URLSession:session dataTask:dataTask didReceiveData:data];
    }
}

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    VCRRecording *recording = [self recordingForRequest:dataTask.currentRequest];
    recording.headerFields = httpResponse.allHeaderFields;
    if ([_wrapped respondsToSelector:@selector(URLSession:dataTask:didReceiveResponse:completionHandler:)]) {
        [_wrapped URLSession:session dataTask:dataTask didReceiveResponse:response completionHandler:completionHandler];
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    VCRRecording *recording = [self recordingForRequest:task.currentRequest];
    recording.error = error;
    
    if ([_wrapped respondsToSelector:@selector(URLSession:task:didCompleteWithError:)]) {
        [_wrapped URLSession:session task:task didCompleteWithError:error];
    }
}

- (BOOL)respondsToSelector:(SEL)selector {
    return [self methodForSelector:selector] || [_wrapped respondsToSelector:selector];
}

- (id)forwardingTargetForSelector:(SEL)selector {
    return [self methodForSelector:selector] ? self : _wrapped;
}

@end

#endif
