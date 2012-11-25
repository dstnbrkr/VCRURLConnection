//
//  VCRCassette.m
//  VCRURLConnectionExample
//
//  Created by Dustin Barker on 11/18/12.
//  Copyright (c) 2012 Dustin Barker. All rights reserved.
//

#import "VCRCassette.h"

@interface VCRCassette ()
@property (nonatomic, retain) NSMutableDictionary *responseDictionary;
@end

@implementation VCRCassette

+ (VCRCassette *)cassette {
    return [[[VCRCassette alloc] init] autorelease];
}

+ (VCRCassette *)cassetteWithURL:(NSURL *)url {
    NSData *data = [NSData dataWithContentsOfURL:url];
    return [[[VCRCassette alloc] initWithData:data] autorelease];
}

- (id)initWithData:(NSData *)data {
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    return [self initWithJSON:json];
    
}

- (id)initWithJSON:(id)json {
    if ((self = [self init])) {
        NSArray *recordings = [json valueForKeyPath:@"cassette.recordings"];
        
        for (id recording in recordings) {
            NSURL *url = [NSURL URLWithString:[recording valueForKeyPath:@"request.url"]];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            NSURLResponse *response = [[NSURLResponse alloc] initWithURL:url
                                                                MIMEType:@"text/plain"
                                                   expectedContentLength:-1
                                                        textEncodingName:@"utf8"];
            [self.responseDictionary setObject:response forKey:request];
        }
    }
    return self;
}

- (id)init {
    if ((self = [super init])) {
        self.responseDictionary = [NSMutableDictionary dictionary];
    }
    return self;
}

- (VCRResponse *)responseForRequest:(NSURLRequest *)request {
    return [self.responseDictionary objectForKey:request];
}

#pragma mark - Memory

- (void)dealloc {
    self.responseDictionary = nil;
    [super dealloc];
}

@end
