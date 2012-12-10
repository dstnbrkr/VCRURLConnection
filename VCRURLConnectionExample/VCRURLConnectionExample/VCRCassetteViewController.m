//
//  VCRCassetteController.m
//  VCRURLConnectionExample
//
//  Created by Dustin Barker on 12/9/12.
//  Copyright (c) 2012 Dustin Barker. All rights reserved.
//

#import "VCRCassetteViewController.h"
#import "VCRResponseViewController.h"

@interface VCRCassetteViewController ()
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) VCRResponseViewController *responseViewController;
@end

@implementation VCRCassetteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.responseViewController = [[[VCRResponseViewController alloc] init] autorelease];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                   target:self
                                                                                   action:@selector(done)];
    [self.navigationItem setRightBarButtonItem:barButtonItem];
    [barButtonItem release];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

#pragma mark - UI Callbacks

- (IBAction)done {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.cassette allKeys] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    VCRRequestKey *key = [[self.cassette allKeys] objectAtIndex:indexPath.row];
    NSString *path = [[key url] absoluteString];
    cell.textLabel.text = path;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    VCRRequestKey *key = [[self.cassette allKeys] objectAtIndex:indexPath.row];
    VCRResponse *response = [self.cassette responseForRequestKey:key];
    self.responseViewController.response = response;
    [self.navigationController pushViewController:self.responseViewController animated:YES];
}

@end
