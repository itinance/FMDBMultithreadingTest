//
//  RowItem.h
//  FMDBMultiThreadingExample
//
//  Created by Hagen Hübel on 08/06/15.
//  Copyright (c) 2015 ITinance GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SectionItem;

@interface RowItem : NSObject

@property (nonatomic, assign) int64_t _id;

@property (nonatomic, strong) SectionItem* section;


@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* dummy;

@property (nonatomic, assign) double random_float;
@property (nonatomic, assign) int64_t count_updates;

@property (nonatomic, copy) NSString* created;
@property (nonatomic, copy) NSString* updated;

- (instancetype) initRowItemWithId:(int64_t) aId forSection:(SectionItem*) section;

@end
