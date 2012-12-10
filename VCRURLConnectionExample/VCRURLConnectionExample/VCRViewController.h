//
//  VCRViewController.h
//  VCRURLConnectionExample
//
//  Created by Dustin Barker on 11/10/12.
//  Copyright (c) 2012 Dustin Barker. All rights reserved.
//

#import "VCRCassetteViewController.h"
#import <UIKit/UIKit.h>

@interface VCRViewController : UIViewController

- (void)load;

@property (nonatomic, retain) VCRCassetteViewController *cassetteViewController;
@property (nonatomic, retain) NSString *HTMLString;
@property (readonly, getter = isFinishedLoading) BOOL finishedLoading;

@end
