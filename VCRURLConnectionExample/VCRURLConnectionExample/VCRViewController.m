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

    NSURL *_url;
    NSMutableData *_responseData;
}
@end

@implementation VCRViewController

- (void)viewDidAppear:(BOOL)animated {
    _url = [[NSURL alloc] initWithString:@"http://www.iana.org/domains/example/"];
    NSURLRequest *request = [NSURLRequest requestWithURL:_url];
    self.HTMLString = nil;
    [_responseData release]; _responseData = nil;
    [NSURLConnection connectionWithRequest:request delegate:self];
}

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if (!_responseData) {
        _responseData = [[NSMutableData alloc] initWithData:data];
    } else {
        [_responseData appendData:data];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    self.HTMLString = [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
    [_webView loadHTMLString:_HTMLString baseURL:_url];
}

@end
