//
//  VCRRequest.h
//  Tests
//
//  Created by Dustin Barker on 12/2/12.
//
//

#import <Foundation/Foundation.h>

@interface VCRRequestKey : NSObject <NSCopying>

+ (VCRRequestKey *)keyForRequest:(NSURLRequest *)request;

@property (nonatomic, retain, readonly) NSURL *url;
@property (nonatomic, retain, readonly) NSString *method;

@end
