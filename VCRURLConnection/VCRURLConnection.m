//
//  VCRURLConnection.m
//  VCRURLConnectionExample
//
//  Created by Dustin Barker on 11/18/12.
//  Copyright (c) 2012 Dustin Barker. All rights reserved.
//

#import "VCRURLConnection.h"
#import "VCRCassette.h"
#import "VCRCassetteManager.h"


@implementation VCRURLConnection

+ (void)setCassetteLibraryPath:(NSString *)path {
    [[VCRURLConnectionCassetteManager defaultManager] setCassetteLibraryPath:path];
}

+ (void)setCassette:(NSString *)cassette {
    [[VCRURLConnectionCassetteManager defaultManager] setCurrentCassette:cassette];
}

@end
