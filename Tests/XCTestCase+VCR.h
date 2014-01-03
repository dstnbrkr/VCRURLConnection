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

@end

@interface XCTestCase (VCR)

- (void)recordRequestBlock:(void(^)(NSURLRequest *request))requestBlock
            predicateBlock:(BOOL(^)())predicateBlock
           assertionsBlock:(void(^)(NSURLRequest *request, VCRRecording *recording))assertionsBlock;

- (void)testRecording:(VCRRecording *)recording forRequest:(NSURLRequest *)request;

- (void)testDelegate:(id<VCRTestDelegate>)delegate forRecording:(VCRRecording *)recording;

@end
