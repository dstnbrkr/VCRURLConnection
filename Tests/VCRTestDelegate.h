//
//  VCRTestDelegate.h
//  VCRURLConnection
//
//  Created by Dustin Barker on 12/30/13.
//
//

#import <Foundation/Foundation.h>

@protocol VCRTestDelegate <NSObject>

@property (nonatomic, strong, readonly) NSHTTPURLResponse *response;
@property (nonatomic, strong, readonly) NSData *data;
@property (nonatomic, getter = isDone, readonly) BOOL done;

@end
