//
//  VCRURLConnectionExampleTests.m
//  VCRURLConnectionExampleTests
//
//  Created by Dustin Barker on 11/10/12.
//  Copyright (c) 2012 Dustin Barker. All rights reserved.
//

#import "VCRURLConnectionExampleTests.h"
#import "VCRViewController.h"

@interface VCRURLConnectionExampleTests () {
    VCRViewController *_viewController;
}
@end

@implementation VCRURLConnectionExampleTests

- (void)setUp {
    [super setUp];
    _viewController = [[VCRViewController alloc] initWithNibName:@"VCRViewController" bundle:[NSBundle mainBundle]];
}

- (void)tearDown {
    [super tearDown];
    [_viewController release]; _viewController = nil;
}

- (void)testExample {
    [_viewController.webView.
}

@end
