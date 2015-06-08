//
//  DatabaseSectionTruncater.m
//  FMDBMultiThreadingExample
//
//  Created by Hagen Hübel on 08/06/15.
//  Copyright (c) 2015 ITinance GmbH. All rights reserved.
//

#import "DatabaseSectionTruncater.h"
#import "Database.h"
#import "AppDelegate.h"

@interface DatabaseSectionTruncater()
{
    dispatch_source_t _timer;
    Database* _database;
}
@end

@implementation DatabaseSectionTruncater

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
        
        
        // it is stupid to load all sections only to count them
        // but this is an example and i prefer much more traffic on cpu here :)
        
        NSArray* sections = [_database loadAllSections];
        int countSectionsToDelete = arc4random_uniform(sections.count);

        NSString* stmt = [NSString stringWithFormat:@"DELETE FROM section WHERE id IN ("
                           "   SELECT id FROM section ORDER BY created ASC LIMIT %d"
                           ")", countSectionsToDelete];
        
        [_database executeStatement:stmt];
        
        stmt = [NSString stringWithFormat:@"UPDATE stats SET remove_section_count=remove_section_count + %u, last_remove_section=CURRENT_TIMESTAMP WHERE id=1", countSectionsToDelete ];
        [_database executeStatement:stmt];
        
        
    });
    
}


@end
