# VCRURLConnection
VCRURLConnection is an API to record and replay HTTP interactions, inspired by [VCR](https://github.com/myronmarston/vcr)

> _VCRURLConnection is still in the very early stages of development, all bug reports, feature requests, and general feedback are greatly appreciated!_

## Example
``` objective-c
// load up a cassette
NSString *cassettePath = [[NSBundle mainBundle] pathForResource:@"cassette" ofType:@"json"];
[VCR setCassetteURL:[NSURL fileURLWithPath:cassettePath]];
[VCR start];

NSURL *url = [NSURL URLWithString:@"http://example.com/example"];
[NSURLRequest requestWithURL:url];

// record the request
[NSURLConnection connectionWithRequest:request delegate:self]; // records real HTTP response
[VCR save]; // persist recording to cassette.json

// repeat the request, VCRURLConnection will replay the recorded response
[NSURLConnection connectionWithRequest:request delegate:self];

[VCR stop];
```

## How to get started
- [Download VCRURLConnection](https://github.com/dstnbrkr/VCRURLConnection/zipball/master) and try out the included example app
- Include the files in the VCRURLConnection folder in your test target
- Run your tests once to record all HTTP interactions
- Subsequent test runs will use the recorded HTTP interactions instead of the network
- You can edit the recorded HTTP interactions by hand, the recordings are all stored in a simple JSON file format






