//
//  VCRConnectionDelegate.h
//  VCRURLConnectionExample
//
//  Created by Dustin Barker on 11/18/12.
//  Copyright (c) 2012 Dustin Barker. All rights reserved.
//

#import "VCRCassette.h"
#import <Foundation/Foundation.h>

@interface VCRConnectionDelegate : NSObject

@property (nonatomic, assign) id<NSURLConnectionDelegate> delegate;
@property (nonatomic, retain) VCRCassette *cassette;

@end
