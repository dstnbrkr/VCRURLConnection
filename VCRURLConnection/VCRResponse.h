//
//  VCRResponse.h
//  VCRURLConnectionExample
//
//  Created by Dustin Barker on 11/18/12.
//  Copyright (c) 2012 Dustin Barker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VCRResponse : NSObject

@property (nonatomic, retain) NSURLResponse *URLResponse;
@property (nonatomic, retain) NSData *responseData;

@end
