//
//  VCRResponseViewController.m
//  VCRURLConnectionExample
//
//  Created by Dustin Barker on 12/9/12.
//  Copyright (c) 2012 Dustin Barker. All rights reserved.
//

#import "VCRResponseViewController.h"

@interface VCRResponseViewController ()

@property (nonatomic, retain) IBOutlet UITextView *textView;

@end

@implementation VCRResponseViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSString *html = [[NSString alloc] initWithData:self.response.responseData encoding:NSUTF8StringEncoding];
    self.textView.text = html;
}

@end
