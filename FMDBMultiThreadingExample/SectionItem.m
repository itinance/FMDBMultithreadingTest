//
//  SectionItem.m
//  FMDBMultiThreadingExample
//
//  Created by Hagen Hübel on 08/06/15.
//  Copyright (c) 2015 ITinance GmbH. All rights reserved.
//

#import "SectionItem.h"

@implementation SectionItem

@synthesize _id, created, updated, name, dummy;

- (NSString *)debugDescription
{
    return [NSString stringWithFormat:@"#%lld %@ %@ %@ %@ \n", self._id, self.name, self.dummy, self.created, self.updated];
}

@end
