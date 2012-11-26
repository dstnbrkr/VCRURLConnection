//
//  VCRResponse.h
//  VCRURLConnectionExample
//
//  Created by Dustin Barker on 11/18/12.
//  Copyright (c) 2012 Dustin Barker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VCRResponse : NSObject

- (id)initWithJSON:(id)json;

@property (nonatomic, retain) NSURL *url;

@property (nonatomic, assign) NSInteger statusCode;

@property (nonatomic, retain) NSData *responseData;

@property (nonatomic, retain) NSHTTPURLResponse *URLResponse;

@end
