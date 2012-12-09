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
    // Override point for customization after application launch.
    self.viewController = [[[VCRViewController alloc] initWithNibName:@"VCRViewController" bundle:nil] autorelease];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    [VCR start];
    NSString *cassettePath = [[NSBundle mainBundle] pathForResource:@"cassette" ofType:@"json"];
    NSLog(@"bundle path: %@", cassettePath);
    [VCR setCassetteURL:[NSURL fileURLWithPath:cassettePath]];
    return YES;
}

@end
