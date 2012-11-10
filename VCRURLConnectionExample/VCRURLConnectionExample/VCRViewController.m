//
//  VCRViewController.m
//  VCRURLConnectionExample
//
//  Created by Dustin Barker on 11/10/12.
//  Copyright (c) 2012 Dustin Barker. All rights reserved.
//

#import "VCRViewController.h"

@interface VCRViewController () {
    IBOutlet UIWebView *_webView;
}

@end

@implementation VCRViewController

- (void)viewDidAppear:(BOOL)animated {
    NSURL *url = [NSURL URLWithString:@"http://www.iana.org/domains/example/"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
}

@end
