//
//  VCRURLConnectionTestDelegate.h
//  VCRURLConnection
//
//  Created by Dustin Barker on 12/29/13.
//
//

#import <Foundation/Foundation.h>

@interface VCRURLConnectionTestDelegate : NSObject<NSURLConnectionDataDelegate>
@property (nonatomic, strong, readonly) NSHTTPURLResponse *response;
@property (nonatomic, strong, readonly) NSData *data;
@property (nonatomic, strong, readonly) NSError *error;
@property (nonatomic, getter = isDone, readonly) BOOL done;
@end
