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
    self.cassette = [VCRCassette cassetteWithURL:url];
}

- (VCRCassette *)currentCassette {
    NSAssert(self.cassette != nil, @"VCRCassetteManager: no cassette has been set!");
    return self.cassette;
}

@end
