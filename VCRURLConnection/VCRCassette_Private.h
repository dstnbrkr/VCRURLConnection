//
//  VCRCassette_Private.h
//  Tests
//
//  Created by Dustin Barker on 11/25/12.
//
//

#import "VCRCassette.h"

@interface VCRCassette ()

NSURL *VCRCassetteURLForJSON(id json);

NSURLRequest *VCRCassetteRequestForJSON(id json);

NSURLResponse *VCRCassetteResponseForJSON(id json);

@property (nonatomic, retain) NSMutableDictionary *responseDictionary;

@end
