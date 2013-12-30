//
//  VCR+NSURLSession.h
//  VCRURLConnection
//
//  Created by Dustin Barker on 12/29/13.
//
//

#import "VCR.h"

@interface VCR (NSURLSession)

void VCRSwizzleNSURLSession();
void VCRUnswizzleNSURLSession();

@end
