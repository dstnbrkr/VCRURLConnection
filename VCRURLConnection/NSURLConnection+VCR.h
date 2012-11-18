//
//  NSURLConnection+VCR.h
//  VCRURLConnectionExample
//
//  Created by Dustin Barker on 11/18/12.
//  Copyright (c) 2012 Dustin Barker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLConnection (VCR)

- (id)VCR_original_initWithRequest:(NSURLRequest *)request delegate:(id<NSURLConnectionDelegate>)delegate;

@end
