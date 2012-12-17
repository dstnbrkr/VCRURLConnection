//
// VCRCassetteController.m
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

#import "VCRCassetteViewController.h"
#import "VCRResponseViewController.h"
#import "VCR.h"

@interface VCRCassetteViewController ()
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) VCRResponseViewController *responseViewController;
@property (nonatomic, retain) NSString *path;
@end

@implementation VCRCassetteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.responseViewController = [[[VCRResponseViewController alloc] init] autorelease];
    
    UIBarButtonItem *barButtonItem;
    
    barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                  target:self
                                                                  action:@selector(save)];
    [self.navigationItem setLeftBarButtonItem:barButtonItem];
    [barButtonItem release];
    
    barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
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

- (IBAction)save {
    self.path = [VCR save];
    UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"Saved Cassette"
                                                         message:self.path
                                                        delegate:self
                                               cancelButtonTitle:nil
                                               otherButtonTitles:@"Copy", @"OK", nil] autorelease];
    [alertView show];
}

- (IBAction)done {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [UIPasteboard generalPasteboard].string = self.path;
            break;
        default:
            break;
    }
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
