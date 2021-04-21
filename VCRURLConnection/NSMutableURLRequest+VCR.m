//
//  NSMutableURLRequest+VCR.m
//  VCRURLConnection
//
//  Created by Mike Akers on 4/20/21.
//

#import "NSMutableURLRequest+VCR.h"
#import "VCRRecordingURLProtocol.h"

//#import "OHHTTPStubsMethodSwizzling.h"

#import <objc/runtime.h>

IMP OHHTTPStubsReplaceMethod(SEL selector,
                             IMP newImpl,
                             Class affectedClass,
                             BOOL isClassMethod)
{
    Method origMethod = isClassMethod ? class_getClassMethod(affectedClass, selector) : class_getInstanceMethod(affectedClass, selector);
    IMP origImpl = method_getImplementation(origMethod);
    
    if (!class_addMethod(isClassMethod ? object_getClass(affectedClass) : affectedClass, selector, newImpl, method_getTypeEncoding(origMethod)))
    {
        method_setImplementation(origMethod, newImpl);
    }

    return origImpl;
}


NSString * const OHHTTPStubs_HTTPBodyKey = @"HTTPBody";

@implementation NSURLRequest (CustomHTTPBody)

- (NSData*)OHHTTPStubs_HTTPBody
{
    return [NSURLProtocol propertyForKey:OHHTTPStubs_HTTPBodyKey inRequest:self];
}

@end

typedef void(*OHHHTTPStubsSetterIMP)(id, SEL, id);
static OHHHTTPStubsSetterIMP orig_setHTTPBody;

static void OHHTTPStubs_setHTTPBody(id self, SEL _cmd, NSData* HTTPBody)
{
    // store the http body via NSURLProtocol
    if (HTTPBody) {
//        [NSURLProtocol setProperty:HTTPBody forKey:OHHTTPStubs_HTTPBodyKey inRequest:self];
        [[VCRRecordingURLProtocol foo] setObject:HTTPBody forKey:@"foo"];
    } else {
        // unfortunately resetting does not work properly as the NSURLSession also uses this to reset the property
    }

    orig_setHTTPBody(self, _cmd, HTTPBody);
}

/**
 *   Swizzles setHTTPBody: in order to maintain a copy of the http body for later
 *   reference and calls the original implementation.
 *
 *   @warning Should not be used in production, testing only.
 */
@interface NSMutableURLRequest (HTTPBodyTesting) @end

@implementation NSMutableURLRequest (HTTPBodyTesting)

+ (void)load
{
    orig_setHTTPBody = (OHHHTTPStubsSetterIMP)OHHTTPStubsReplaceMethod(@selector(setHTTPBody:),
                                                                       (IMP)OHHTTPStubs_setHTTPBody,
                                                                       [NSMutableURLRequest class],
                                                                       NO);
}

@end
