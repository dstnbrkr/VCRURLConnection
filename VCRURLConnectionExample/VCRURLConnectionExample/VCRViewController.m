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
    IBOutlet UIButton *_reloadButton;

    NSURL *_url;
    NSMutableData *_responseData;
}
@end

@implementation VCRViewController

@synthesize finishedLoading = _isLoaded;

- (void)viewDidAppear:(BOOL)animated {
    [self load];
}

- (void)load {
    _url = [[NSURL alloc] initWithString:@"http://localhost:4567/"];
    NSURLRequest *request = [NSURLRequest requestWithURL:_url];
    self.HTMLString = nil;
    [_responseData release]; _responseData = nil;
    [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)loadHTMLString:(NSString *)HTMLString {
    self.HTMLString = HTMLString;
    [_webView loadHTMLString:HTMLString baseURL:_url];
    _isLoaded = YES;
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
    NSString *HTMLString = [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
    [self loadHTMLString:HTMLString];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self loadHTMLString:nil];
}

#pragma mark - UI Callbacks

- (IBAction)didPressReloadButton:(id)sender {
    [self load];
}

@end
