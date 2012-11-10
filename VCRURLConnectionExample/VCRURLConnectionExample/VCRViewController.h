//
//  VCRViewController.h
//  VCRURLConnectionExample
//
//  Created by Dustin Barker on 11/10/12.
//  Copyright (c) 2012 Dustin Barker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VCRViewController : UIViewController

- (void)load;

@property (nonatomic, retain) NSString *HTMLString;
@property (readonly) BOOL isLoaded;

@end
