//
//  VCRCassetteManager.m
//  VCRURLConnectionExample
//
//  Created by Dustin Barker on 11/18/12.
//  Copyright (c) 2012 Dustin Barker. All rights reserved.
//

#import "VCRCassetteManager.h"
#import "VCRCassette.h"

@interface VCRCassetteManager ()

@property (nonatomic, retain) VCRCassette *cassette;

@end

@implementation VCRCassetteManager

+ (VCRCassetteManager *)defaultManager {
    static VCRCassetteManager *_defaultManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _defaultManager = [[self alloc] init];
    });
    
    return _defaultManager;
}

- (void)setCurrentCassetteURL:(NSURL *)url {
    self.cassette = nil;
    [url retain];
    [_currentCassetteURL release];
    _currentCassetteURL = url;
}

- (VCRCassette *)currentCassette {
    VCRCassette *cassette = self.cassette;
    
    NSURL *url = self.currentCassetteURL;
    
    if (cassette) {
        // do nothing
    } else if ([[NSFileManager defaultManager] fileExistsAtPath:[url path]]) {
        NSData *data = [NSData dataWithContentsOfURL:url];
        cassette = [[VCRCassette alloc] initWithData:data];
    } else {
        cassette = [VCRCassette cassette];
    }
    
    self.cassette = cassette;
    
    return cassette;
}

@end
