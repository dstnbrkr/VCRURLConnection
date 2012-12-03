//
//  VCR.h
//  VCRURLConnectionExample
//
//  Created by Dustin Barker on 11/18/12.
//  Copyright (c) 2012 Dustin Barker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VCR : NSObject

+ (void)setCassetteURL:(NSURL *)url;

+ (void)start;
+ (void)stop;

@end
