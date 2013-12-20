//
//  VCRError.m
//  VCRURLConnection
//
//  Created by Dustin Barker on 12/19/13.
//
//

#import "VCRError.h"
#import "NSData+Base64.h"

@interface VCRError ()
@property (nonatomic, copy) NSString *vcr_localizedDescription;
@end

@implementation VCRError

+ (id)JSONForError:(NSError *)error {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary addEntriesFromDictionary:@{ @"code": @(error.code),
                                            @"domain": error.domain,
                                            @"localizedDescription": error.localizedDescription }];
    if ([error.userInfo count] > 0) {
        dictionary[@"userInfo"] = [self serializedUserInfo:error.userInfo];
    }
    return dictionary;
}

+ (NSString *)serializedUserInfo:(NSDictionary *)userInfo {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:userInfo];
    return [data base64EncodedString];
}

+ (NSDictionary *)deserializedUserInfo:(NSString *)string {
    NSData *data = [NSData dataFromBase64String:string];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

- (id)initWithDomain:(NSString *)domain code:(NSInteger)code userInfo:(NSDictionary *)userInfo localizedDescription:(NSString *)localizedDescription {
    self = [super initWithDomain:domain code:code userInfo:userInfo];
    if (self) {
        self.vcr_localizedDescription = localizedDescription;
    }
    return self;
}

- (id)initWithJSON:(id)json {
    return [self initWithDomain:json[@"domain"]
                           code:[json[@"code"] integerValue]
                       userInfo:[[self class] deserializedUserInfo:json[@"userInfo"]]
           localizedDescription:json[@"localizedDescription"]];
}

- (NSString *)localizedDescription {
    return self.vcr_localizedDescription;
}

@end
