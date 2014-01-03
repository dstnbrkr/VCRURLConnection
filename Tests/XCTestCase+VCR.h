//
//  XCTestCase+VCR.h
//  VCRURLConnection
//
//  Created by Dustin Barker on 1/2/14.
//
//

#import <XCTest/XCTest.h>

@class VCRRecording;

@protocol VCRTestDelegate <NSObject>

@optional
- (NSData *)data;
- (NSHTTPURLResponse *)response;
@end

@interface XCTestCase (VCR)

- (void)recordRequest:(NSURLRequest *)request
         requestBlock:(void(^)())requestBlock
       predicateBlock:(BOOL(^)())predicateBlock
           completion:(void(^)(VCRRecording *recording))completion;

- (void)testRecording:(VCRRecording *)recording forRequest:(NSURLRequest *)request;

- (void)testDelegate:(id<VCRTestDelegate>)delegate forRecording:(VCRRecording *)recording;

- (void)replayJSON:(id)json
      requestBlock:(void(^)(NSURLRequest *request))requestBlock
    predicateBlock:(BOOL(^)())predicateBlock
        completion:(void(^)(VCRRecording *))completion;

@end
