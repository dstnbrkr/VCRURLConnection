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

@end
