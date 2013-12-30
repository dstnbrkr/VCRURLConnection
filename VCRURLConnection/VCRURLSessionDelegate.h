//
//  VCRURLSessionDelegate.h
//  VCRURLConnection
//
//  Created by Dustin Barker on 12/27/13.
//
//

#import <Availability.h>
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 50000 || __MAC_OS_X_VERSION_MIN_REQUIRED >= 1090

#import "VCRRecording.h"
#import <Foundation/Foundation.h>

@interface VCRURLSessionDelegate : NSObject<NSURLSessionDataDelegate>

- (id)initWithDelegate:(id<NSURLSessionDelegate>)delegate recording:(VCRRecording *)recording;

@end

#endif
