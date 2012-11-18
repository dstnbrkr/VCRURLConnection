//
//  VCRCassetteManager.h
//  VCRURLConnectionExample
//
//  Created by Dustin Barker on 11/18/12.
//  Copyright (c) 2012 Dustin Barker. All rights reserved.
//

#import "VCRCassette.h"
#import <Foundation/Foundation.h>

@interface VCRURLConnectionCassetteManager : NSObject

+ (VCRURLConnectionCassetteManager *)defaultManager;

- (void)setCassetteLibraryPath:(NSString *)path;

- (void)setCurrentCassette:(NSString *)cassette;

@property (nonatomic, retain) NSString *cassetteLibraryPath;
@property (nonatomic, retain) VCRCassette *cassette;

@end
