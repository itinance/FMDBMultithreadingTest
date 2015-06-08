//
//  Database.h
//  LocalInspirationMerchantApp
//
//  Created by Hagen Hübel on 10/06/14.
//  Copyright (c) 2014 Yatego GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SectionItem.h"
#import "RowItem.h"

@interface Database : NSObject

+ (id)sharedDatabase;

- (NSArray*) loadAllSections;

- (bool) executeStatement:(NSString*) statement;
- (bool) addSection:(NSString*)name withDummy:(NSString*)dummy;
- (NSDictionary*) loadDictionaryFromQuery:(NSString*)query withArgs:(NSArray*)args;

@end
