//
//  VCR_NSURLSessionDataTaskTests.m
//  VCRURLConnection
//
//  Created by Dustin Barker on 12/31/13.
//
//

#import <Availability.h>
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 50000 || __MAC_OS_X_VERSION_MIN_REQUIRED >= 1090

#import <XCTest/XCTest.h>
#import "VCR+NSURLSession.h"
#import "XCTestCase+VCR.h"
#import "VCRURLSessionTestDelegate.h"
#import "VCRCassetteManager.h"

@interface VCR_NSURLSessionDataTaskTests : XCTestCase
@property (nonatomic, strong) VCRURLSessionTestDelegate *delegate;
@property (nonatomic, strong) NSURLSession *session;
@end

@implementation VCR_NSURLSessionDataTaskTests

- (void)setUp {
    [[VCRCassetteManager defaultManager] setCurrentCassette:nil];
    VCRSwizzleNSURLSession();
    self.delegate = [[VCRURLSessionTestDelegate alloc] init];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.session = [NSURLSession sessionWithConfiguration:configuration delegate:self.delegate delegateQueue:[NSOperationQueue mainQueue]];
}

- (void)tearDown {
    VCRUnswizzleNSURLSession();
    [super tearDown];
}

- (void)testResponseIsRecordedForDataTaskWithRequest {
    self.delegate.responseDisposition = NSURLSessionResponseAllow;
    __weak typeof(self) weakSelf = self;
    [self testRecordResponseForRequestBlock:^(NSURLRequest *request) {
        NSURLSessionDataTask *task = [weakSelf.session dataTaskWithRequest:request];
        [task resume];
    } predicateBlock:^BOOL{
        return weakSelf.delegate.isDone;
    }];
}

- (void)testResponseIsRecordedForDataTaskWithRequestNilCompletionHandler {
    self.delegate.responseDisposition = NSURLSessionResponseAllow;
    __weak typeof(self) weakSelf = self;
    [self testRecordResponseForRequestBlock:^(NSURLRequest *request) {
        NSURLSessionDataTask *task = [weakSelf.session dataTaskWithRequest:request completionHandler:nil];
        [task resume];
    } predicateBlock:^BOOL{
        return weakSelf.delegate.isDone;
    }];
}

- (void)testResponseIsRecordedForDataTaskWithRequestCompletionHandler {
    __weak typeof(self) weakSelf = self;
    __block BOOL completed = NO;
    [self testRecordResponseForRequestBlock:^(NSURLRequest *request) {
        NSURLSessionDataTask *task = [weakSelf.session
                                      dataTaskWithRequest:request
                                      completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                          completed = YES;
                                      }];
        [task resume];
    } predicateBlock:^BOOL{
        return completed;
    }];
}

- (void)testResponseIsRecordedForDataTaskWithURL {
    self.delegate.responseDisposition = NSURLSessionResponseAllow;
    __weak typeof(self) weakSelf = self;
    [self testRecordResponseForRequestBlock:^(NSURLRequest *request) {
        NSURLSessionDataTask *task = [weakSelf.session dataTaskWithURL:request.URL];
        [task resume];
    } predicateBlock:^BOOL{
        return weakSelf.delegate.isDone;
    }];
}

- (void)testResponseIsRecordedForDataTaskWithURLCompletionHandler {
    __weak typeof(self) weakSelf = self;
    __block BOOL completed = NO;
    [self testRecordResponseForRequestBlock:^(NSURLRequest *request) {
        NSURLSessionDataTask *task = [weakSelf.session
                                      dataTaskWithURL:request.URL
                                      completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                          completed = YES;
                                      }];
        [task resume];
    } predicateBlock:^BOOL{
        return completed;
    }];
}

@end

#endif
