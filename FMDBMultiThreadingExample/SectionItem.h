//
//  SectionItem.h
//  FMDBMultiThreadingExample
//
//  Created by Hagen Hübel on 08/06/15.
//  Copyright (c) 2015 ITinance GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SectionItem : NSObject

@property (nonatomic, assign) int64_t _id;
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* dummy;
@property (nonatomic, copy) NSString* created;
@property (nonatomic, copy) NSString* updated;

@end
