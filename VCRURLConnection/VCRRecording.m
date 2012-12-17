//
// VCRRecording.m
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

#import "VCRRecording.h"

@implementation VCRRecording

+ (VCRRecording *)recordingFromResponse:(NSHTTPURLResponse *)response {
    VCRRecording *recording = [[[VCRRecording alloc] init] autorelease];
    recording.URI = [response.URL absoluteString];
    recording.headerFields = [response allHeaderFields];
    recording.statusCode = response.statusCode;
    return recording;
}

- (id)JSON {
    return nil;
}

- (void)dealloc {
    self.method = nil;
    self.URI = nil;
    self.data = nil;
    self.headerFields = nil;
    self.httpVersion = nil;
    [super dealloc];
}

@end

@implementation NSHTTPURLResponse (VCRRecording)

+ (NSHTTPURLResponse *)responseFromRecording:(VCRRecording *)recording {
    NSURL *url = [NSURL URLWithString:recording.URI];
    return [[[NSHTTPURLResponse alloc] initWithURL:url
                                        statusCode:recording.statusCode
                                       HTTPVersion:recording.httpVersion
                                      headerFields:recording.headerFields] autorelease];
}

@end
