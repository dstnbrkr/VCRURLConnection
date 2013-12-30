//
//  VCRURLSessionTestDelegate.m
//  VCRURLConnection
//
//  Created by Dustin Barker on 12/30/13.
//
//

#import <Availability.h>
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 50000 || __MAC_OS_X_VERSION_MIN_REQUIRED >= 1090

#import "VCRURLSessionTestDelegate.h"

@interface VCRURLSessionTestDelegate ()
@property (nonatomic, strong, readwrite) NSURLResponse *response;
@property (nonatomic, strong, readwrite) NSData *data;
@end

@implementation VCRURLSessionTestDelegate

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    
    self.response = response;
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    NSMutableData *currentData = [NSMutableData dataWithData:self.data];
    [currentData appendData:data];
    self.data = currentData;
}

@end

#endif

