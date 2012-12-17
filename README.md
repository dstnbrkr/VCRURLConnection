# VCRURLConnection
VCRURLConnection is an iOS and OS X API to record and replay HTTP interactions, inspired by [VCR](https://github.com/myronmarston/vcr)

> _VCRURLConnection is still in the very early stages of development, all bug reports, feature requests, and general feedback are greatly appreciated!_

## Recording
``` objective-c
[VCR start];

NSURL *url = [NSURL URLWithString:@"http://example.com/example"];
[NSURLRequest requestWithURL:url];
[NSURLConnection connectionWithRequest:request delegate:self];

// response will be result of real network request

NSString *path = [VCR save]; // copy the file at `path` into your project
```

# Replaying

NSString *cassettePath = [[NSBundle mainBundle] pathForResource:@"cassette" ofType:@"json"]; // use the file created above
[VCR setCassetteURL:[NSURL fileURLWithPath:cassettePath]];
[VCR start];

// now all requests recorded on cassette.json will be used in place of real network requests

// make the same request
NSURL *url = [NSURL URLWithString:@"http://example.com/example"];
[NSURLRequest requestWithURL:url];
[NSURLConnection connectionWithRequest:request delegate:self];

// will use previously recorded response, no network request will be made
```

## How to get started
- [Download VCRURLConnection](https://github.com/dstnbrkr/VCRURLConnection/zipball/master) and try out the included example app
- Include the files in the VCRURLConnection folder in your test target
- Run your tests once to record all HTTP interactions
- Copy the recorded json file (the file whose path is returned by `[VCR save]`) into your project
- Subsequent test runs will use the recorded HTTP interactions instead of the network
- You can edit the recorded HTTP interactions by hand, the recordings are all stored in a simple JSON file format

## License

VCRURLConnection is released under the MIT license

## Contact

Dustin Barker

dustin.barker@gmail.com





