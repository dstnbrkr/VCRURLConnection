# VCRURLConnection
VCRURLConnection is an iOS and OSX API to record and replay HTTP interactions, inspired by [VCR](https://github.com/myronmarston/vcr)

> _VCRURLConnection is still in the very early stages of development, all bug reports, feature requests, and general feedback are greatly appreciated!_

## Recording

``` objective-c
[VCR start];

NSURL *url = [NSURL URLWithString:@"http://example.com/example"];
NSURLRequest *request = [NSURLRequest requestWithURL:url];
[NSURLConnection connectionWithRequest:request delegate:self];

// NSURLConnection makes a real network request and VCRURLConnection
// will record the request/response pair.

NSString *path = [VCR save]; // copy the file at `path` into your project
```

## Replaying

``` objective-c
// Load the cassette saved above
NSString *cassettePath = [[NSBundle mainBundle] pathForResource:@"cassette" ofType:@"json"];
[VCR setCassetteURL:[NSURL fileURLWithPath:cassettePath]];
[VCR start];

NSURL *url;
NSURLRequest *request;

// make the same request
url = [NSURL URLWithString:@"http://example.com/example"];
request = [NSURLRequest requestWithURL:url];
[NSURLConnection connectionWithRequest:request delegate:self];

// The cassette has a recording for this request, so no network request
// is made. Instead NSURLConnectionDelegate methods are called with the
// previously recorded response.

url = [NSURL URLWithString:@"http://iana.org"]
request = [NSURLRequest requestWithURL:url];
[NSURLConnection connectionWithRequest:request delegate:self];

// The cassette does not have a recording for this request, so a real
// network request is made (and VCRURLConnection will record the
// request/response pair).
```

## How to get started
- [Download VCRURLConnection](https://github.com/dstnbrkr/VCRURLConnection/zipball/master) and try out the included example app
- Include the files in the VCRURLConnection folder in your test target
- Run your tests once to record all HTTP interactions
- Copy the recorded json file (the file whose path is returned by `[VCR save]`) into your project
- Subsequent test runs will use the recorded HTTP interactions instead of the network
- All recordings are stored in a single JSON file, which you can edit by hand

## License

VCRURLConnection is released under the MIT license

## Contact

Dustin Barker

dustin.barker@gmail.com

==================================================================
VCRURLConnection uses the following open source components:

[NSData+Base64.h][1] by Matt Gallagher
[SenTestCase+SRTAdditions.h] from SocketRocket by Square

[1]: http://www.cocoawithlove.com/2009/06/base64-encoding-options-on-mac-and.html
[2]: https://github.com/square/SocketRocket
