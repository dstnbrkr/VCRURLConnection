//
//  VCRError.m
//  VCRURLConnection
//
//  Created by Dustin Barker on 12/19/13.
//
//

#import "VCRError.h"

@interface VCRError ()
@property (nonatomic, copy) NSString *vcr_localizedDescription;
@end

@implementation VCRError

- (id)initWithDomain:(NSString *)domain code:(NSInteger)code userInfo:(NSDictionary *)userInfo localizedDescription:(NSString *)localizedDescription {
    self = [super initWithDomain:domain code:code userInfo:userInfo];
    if (!self) {
        self.vcr_localizedDescription = localizedDescription;
    }
    return self;
}

- (id)initWithJSON:(id)json {
    return [self initWithDomain:json[@"domain"]
                           code:[json[@"code"] integerValue]
                       userInfo:json[@"userInfo"]
           localizedDescription:json[@"localizedDescription"]];
}

- (NSString *)localizedDescription {
    return self.vcr_localizedDescription;
}

@end
