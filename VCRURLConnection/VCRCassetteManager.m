//
//  VCRCassetteManager.m
//  VCRURLConnectionExample
//
//  Created by Dustin Barker on 11/18/12.
//  Copyright (c) 2012 Dustin Barker. All rights reserved.
//

#import "VCRCassetteManager.h"

@implementation VCRURLConnectionCassetteManager

+ (VCRURLConnectionCassetteManager *)defaultManager {
    static VCRURLConnectionCassetteManager *_defaultManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _defaultManager = [[self alloc] init];
    });
    
    return _defaultManager;
}

- (void)setCurrentCassette:(NSString *)cassette {
    NSURL *baseURL = [NSURL fileURLWithPath:self.cassetteLibraryPath];
    NSURL *url = [baseURL URLByAppendingPathComponent:cassette];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[url absoluteString]]) {
        self.cassette = [VCRCassette cassetteWithURL:url];
    } else {
        self.cassette = [VCRCassette cassette];
    }
}

@end
