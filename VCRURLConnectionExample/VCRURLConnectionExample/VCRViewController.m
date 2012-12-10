//
//  VCRViewController.m
//  VCRURLConnectionExample
//
//  Created by Dustin Barker on 11/10/12.
//  Copyright (c) 2012 Dustin Barker. All rights reserved.
//

#import "VCRViewController.h"

@interface VCRViewController () {
    IBOutlet UITextField *_textField;
    IBOutlet UIWebView *_webView;
    IBOutlet UIButton *_reloadButton;

    NSMutableData *_responseData;
}
@property (nonatomic, retain) NSURL *url;
@property (nonatomic, retain) NSString *mimeType;
@end

@implementation VCRViewController

@synthesize finishedLoading = _isLoaded;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *path = @"http://example.com/example";
    self.url = [NSURL URLWithString:path];
    _textField.text = path;
    [self load];
}

- (void)load {
    NSURLRequest *request = [NSURLRequest requestWithURL:_url];
    self.HTMLString = nil;
    [_responseData release]; _responseData = nil;
    [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)loadData:(NSData *)data {
    NSString *HTMLString = [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
    self.HTMLString = HTMLString;
    [_webView loadData:data MIMEType:self.mimeType textEncodingName:@"utf-8" baseURL:_url];
    _isLoaded = YES;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    self.url = [[NSURL alloc] initWithString:textField.text];
    [self load];
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        NSString *text = [request.URL absoluteString];
        _textField.text = text;
        self.url = request.URL;
        [self load];
        return NO;
    } else {
        return YES;
    }
}

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse *)response {
    self.mimeType = [response MIMEType];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if (!_responseData) {
        _responseData = [[NSMutableData alloc] initWithData:data];
    } else {
        [_responseData appendData:data];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self loadData:_responseData];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self loadData:_responseData];
}

#pragma mark - UI Callbacks

- (IBAction)didPressReloadButton:(id)sender {
    [self load];
}

- (IBAction)didPressPageCurlButton:(id)sender {
    UINavigationController *navigationController = [[[UINavigationController alloc] initWithRootViewController:self.cassetteViewController] autorelease];
    [self presentViewController:navigationController animated:YES completion:NULL];
}

@end
