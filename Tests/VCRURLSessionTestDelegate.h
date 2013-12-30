//
//  VCRURLSessionTestDelegate.h
//  VCRURLConnection
//
//  Created by Dustin Barker on 12/30/13.
//
//

#import <Availability.h>
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 50000 || __MAC_OS_X_VERSION_MIN_REQUIRED >= 1090

#import <Foundation/Foundation.h>

@interface VCRURLSessionTestDelegate : NSObject<NSURLSessionDelegate, NSURLSessionDataDelegate>
@property (nonatomic, strong, readonly) NSURLResponse *response;
@property (nonatomic, strong, readonly) NSData *data;
@end

#endif

