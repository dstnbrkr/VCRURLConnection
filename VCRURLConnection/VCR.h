//
//  VCR.h
//  VCRURLConnectionExample
//
//  Created by Dustin Barker on 11/18/12.
//  Copyright (c) 2012 Dustin Barker. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VCRCassette;

@interface VCR : NSObject

+ (void)setCassetteURL:(NSURL *)url;
+ (VCRCassette *)cassette;

+ (void)start;
+ (void)stop;

@end
