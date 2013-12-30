//
//  VCRURLSessionDelegate.m
//  VCRURLConnection
//
//  Created by Dustin Barker on 12/27/13.
//
//

#if (defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000) || (defined(__MAC_OS_X_VERSION_MAX_ALLOWED) && __MAC_OS_X_VERSION_MAX_ALLOWED >= 1090)

#import "VCRURLSessionDelegate.h"

@interface VCRURLSessionDelegate ()
@property (nonatomic, strong) VCRRecording *recording;
@property (nonatomic, strong) id<NSURLSessionDelegate> wrapped;
@end

@implementation VCRURLSessionDelegate

- (id)initWithDelegate:(id<NSURLSessionDelegate>)delegate recording:(VCRRecording *)recording {
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
    if ([_wrapped respondsToSelector:@selector(session:dataTask:didReceiveData:)]) {
        [_wrapped session:session dataTask:dataTask didReceiveData:data];
    }
}

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    
    self.recording.headerFields = response.allHeaderFields;
    if ([_wrapped respondsToSelector:@selector(session:dataTask:didReceiveResponse:completionHandler:)]) {
        [_wrapped session:session dataTask:dataTask didReceiveResponse:response completionHandler:completionHandler];
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
