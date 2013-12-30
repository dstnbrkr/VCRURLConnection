//
//  VCRURLSessionDelegate.h
//  VCRURLConnection
//
//  Created by Dustin Barker on 12/27/13.
//
//

#if (defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000) || (defined(__MAC_OS_X_VERSION_MAX_ALLOWED) && __MAC_OS_X_VERSION_MAX_ALLOWED >= 1090)

#import "VCRRecording.h"
#import <Foundation/Foundation.h>

@interface VCRURLSessionDelegate : NSObject<NSURLSessionDelegate>

- (id)initWithDelegate:(id<NSURLSessionDelegate>)delegate recording:(VCRRecording *)recording;

@end

#endif
