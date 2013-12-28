//
//  VCRURLConnection+NSURLSession.m
//  VCRURLConnection
//
//  Created by Dustin Barker on 12/27/13.
//
//

#import "VCRURLSessionDelegate.h"
#import <Foundation/Foundation.h>
#import <objc/runtime.h>

typedef NSURLSession *(*URLSessionConstructor1)(id, SEL, NSURLSessionConfiguration *, id<NSURLSessionDelegate>, NSOperationQueue *);

URLSessionConstructor1 orig_sessionWithConfigurationAndDelegateAndDelegateQueue;

static NSURLSession *VCR_sessionWithConfigurationAndDelegateAndDelegateQueue (id self,
                                                                              SEL _cmd,
                                                                              NSURLSessionConfiguration *configuration,
                                                                              id<NSURLSessionDelegate> delegate,
                                                                              NSOperationQueue *delegateQueue) {
    
    //VCRURLSessionDelegate *wrappedDelegate = [[VCRURLSessionDelegate alloc] init];
    return orig_sessionWithConfigurationAndDelegateAndDelegateQueue(self, _cmd, configuration, delegate, delegateQueue);
}



