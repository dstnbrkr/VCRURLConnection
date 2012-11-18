//
//  VCRURLConnection.m
//  VCRURLConnectionExample
//
//  Created by Dustin Barker on 11/18/12.
//  Copyright (c) 2012 Dustin Barker. All rights reserved.
//

#import "VCRURLConnection.h"
#import "VCRCassette.h"

@interface VCRURLConnectionCassetteManager : NSObject

+ (VCRURLConnectionCassetteManager *)defaultManager;
- (void)setCassetteLibraryPath:(NSString *)path;
- (void)setCurrentCassette:(NSString *)cassette;

@property (nonatomic, retain) NSString *cassetteLibraryPath;
@property (nonatomic, retain) VCRCassette *cassette;

@end

@implementation VCRURLConnection

+ (void)setCassetteLibraryPath:(NSString *)path {
    [[VCRURLConnectionCassetteManager defaultManager] setCassetteLibraryPath:path];
}

+ (void)setCassette:(NSString *)cassette {
    [[VCRURLConnectionCassetteManager defaultManager] setCurrentCassette:cassette];
}

@end

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
