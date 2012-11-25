//
//  VCRCassette_Private.h
//  Tests
//
//  Created by Dustin Barker on 11/25/12.
//
//

#import "VCRCassette.h"

@interface VCRCassette ()

NSURLRequest *VCRCassetteRequestForJSON(id json);

@property (nonatomic, retain) NSMutableDictionary *responseDictionary;

@end
