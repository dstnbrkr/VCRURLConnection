//
// VCRViewController.m
//
// Copyright (c) 2012 Dustin Barker
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "VCRViewController.h"

@interface VCRViewController () {
    IBOutlet UITextField *_textField;
    IBOutlet UIWebView *_webView;
    IBOutlet UIButton *_reloadButton;

    NSMutableData *_responseData;
}
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSString *mimeType;
@end

@implementation VCRViewController

@synthesize finishedLoading = _isLoaded;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *path = @"http://example.com";
    self.url = [NSURL URLWithString:path];
    _textField.text = path;
    [self load];
}

- (void)load {
    NSURLRequest *request = [NSURLRequest requestWithURL:_url];
    self.HTMLString = nil;
    _responseData = nil;
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
    self.url = [NSURL URLWithString:textField.text];
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
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self.cassetteViewController];
    [self presentViewController:navigationController animated:YES completion:NULL];
}

@end
