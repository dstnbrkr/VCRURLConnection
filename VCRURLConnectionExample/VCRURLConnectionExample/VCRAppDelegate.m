//
//  VCRAppDelegate.m
//  VCRURLConnectionExample
//
//  Created by Dustin Barker on 11/10/12.
//  Copyright (c) 2012 Dustin Barker. All rights reserved.
//

#import "VCRAppDelegate.h"

#import "VCRViewController.h"
#import "VCR.h"

@implementation VCRAppDelegate

- (void)dealloc {
    [_window release];
    [_viewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    [VCR start];
    NSString *cassettePath = [[NSBundle mainBundle] pathForResource:@"cassette" ofType:@"json"];
    [VCR setCassetteURL:[NSURL fileURLWithPath:cassettePath]];
    
    self.viewController = [[[VCRViewController alloc] initWithNibName:@"VCRViewController" bundle:nil] autorelease];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];

    return YES;
}

@end
