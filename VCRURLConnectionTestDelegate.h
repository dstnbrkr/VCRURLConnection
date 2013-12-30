//
//  VCRURLConnectionTestDelegate.h
//  VCRURLConnection
//
//  Created by Dustin Barker on 12/29/13.
//
//

#import "VCRTestDelegate.h"
#import <Foundation/Foundation.h>

@interface VCRURLConnectionTestDelegate : NSObject<VCRTestDelegate, NSURLConnectionDataDelegate>
@property (nonatomic, strong, readonly) NSError *error;
@end
