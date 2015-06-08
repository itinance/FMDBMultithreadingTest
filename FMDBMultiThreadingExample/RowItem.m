//
//  RowItem.m
//  FMDBMultiThreadingExample
//
//  Created by Hagen Hübel on 08/06/15.
//  Copyright (c) 2015 ITinance GmbH. All rights reserved.
//

#import "RowItem.h"

@implementation RowItem

@synthesize _id, created, count_updates, dummy, name, updated, random_float;

- (instancetype) initRowItemWithId:(int64_t) aId forSection:(SectionItem*) section {
    if(self = [self init]) {
        self._id = aId;
        self.section = section;
    }
    return self;
}

@end
