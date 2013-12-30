//
//  VCRURLConnectionTestDelegate.m
//  VCRURLConnection
//
//  Created by Dustin Barker on 12/29/13.
//
//

#import "VCRURLConnectionTestDelegate.h"

@interface VCRURLConnectionTestDelegate () {
    BOOL _done;
}
@property (nonatomic, strong, readwrite) NSHTTPURLResponse *response;
@property (nonatomic, strong, readwrite) NSData *data;
@property (nonatomic, strong, readwrite) NSError *error;
@property (nonatomic, readwrite) BOOL done;
@end

@implementation VCRURLConnectionTestDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse *)response {
    self.response = response;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSMutableData *currentData = [NSMutableData dataWithData:self.data];
    [currentData appendData:data];
    self.data = currentData;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    _done = YES;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    _error = error;
}

@end
