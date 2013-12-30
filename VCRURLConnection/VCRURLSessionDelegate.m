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

@interface VCRURLSessionDelegate ()
@property (nonatomic, strong) VCRRecording *recording;
@property (nonatomic, strong) id<NSURLSessionDataDelegate> wrapped;
@end

@implementation VCRURLSessionDelegate

- (id)initWithDelegate:(id<NSURLSessionDataDelegate>)delegate recording:(VCRRecording *)recording {
    if ((self = [super init])) {
        self.wrapped = delegate;
        self.recording = recording;
    }
    return self;
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    if (self.recording.data) {
        NSMutableData *currentData = [NSMutableData dataWithData:self.recording.data];
        [currentData appendData:data];
        self.recording.data = currentData;
    } else {
        self.recording.data = [NSData dataWithData:data];
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
    self.recording.headerFields = httpResponse.allHeaderFields;
    if ([_wrapped respondsToSelector:@selector(URLSession:dataTask:didReceiveResponse:completionHandler:)]) {
        [_wrapped URLSession:session dataTask:dataTask didReceiveResponse:response completionHandler:completionHandler];
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
