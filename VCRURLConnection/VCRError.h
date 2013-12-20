//
//  VCRError.h
//  VCRURLConnection
//
//  Created by Dustin Barker on 12/19/13.
//
//

#import <Foundation/Foundation.h>

@interface VCRError : NSError

+ (id)JSONForError:(NSError *)error;

- (id)initWithDomain:(NSString *)domain code:(NSInteger)code userInfo:(NSDictionary *)dictionary localizedDescription:(NSString *)localizedDescription;

- (id)initWithJSON:(id)json;

@end
