//
//  DatabaseInserter.m
//  FMDBMultiThreadingExample
//
//  Created by Hagen Hübel on 08/06/15.
//  Copyright (c) 2015 ITinance GmbH. All rights reserved.
//

#import "DatabaseSectionInserter.h"
#import "Database.h"
#import "AppDelegate.h"

@interface DatabaseSectionInserter() {
    dispatch_source_t _timer;
    Database* _database;
}
@end

@implementation DatabaseSectionInserter

- (instancetype) initWithInterval:(float) seconds {

    if(self = [super init]) {
        
        _database = [Database sharedDatabase];
        
        [self initThread:seconds];
    }
    
    return self;
}

- (void) initThread:(float) seconds {
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    double secondsToFire = seconds;
    
    _timer = CreateDispatchTimer(secondsToFire, queue, ^{
        
        NSString *alphabet  = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXZY0123456789";
        NSMutableString *s = [NSMutableString stringWithCapacity:20];
        for (NSUInteger i = 0U; i < 20; i++) {
            u_int32_t r = arc4random() % [alphabet length];
            unichar c = [alphabet characterAtIndex:r];
            [s appendFormat:@"%C", c];
        }
        
        NSString* dummy = [[NSProcessInfo processInfo] globallyUniqueString];
        NSString* name = s;
        
        [_database addSection:name withDummy:dummy];
        
    });
    
}

@end
