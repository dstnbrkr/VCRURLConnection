//
//  VCRCassetteManager.h
//  VCRURLConnectionExample
//
//  Created by Dustin Barker on 11/18/12.
//  Copyright (c) 2012 Dustin Barker. All rights reserved.
//

#import "VCRCassette.h"
#import <Foundation/Foundation.h>

@interface VCRCassetteManager : NSObject

+ (VCRCassetteManager *)defaultManager;

- (void)setCassetteLibraryPath:(NSString *)path;

// FIXME: these are named like symmetrical methods, but aren't

- (void)setCurrentCassette:(NSString *)name;

- (VCRCassette *)currentCassette;

@property (nonatomic, retain) NSString *cassetteLibraryPath;

@end
