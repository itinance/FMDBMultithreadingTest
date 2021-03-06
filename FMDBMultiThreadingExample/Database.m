//
//  Database.m
//  LocalInspirationMerchantApp
//
//  Created by Hagen Hübel on 10/06/14.
//  Copyright (c) 2014 Yatego GmbH. All rights reserved.
//

#import "Database.h"
#import <FMDB/FMDB.h>

@interface Database() {
    
    FMDatabaseQueue* _fmDatabaseQueue;
    NSString* _filename;
    
}

@property (nonatomic, strong, readwrite) NSMutableSet* delegates;

@end

@implementation Database


- (id) init {
    if (self = [super init]) {
        [self openSqliteDb];
    }
    return self;
}

- (NSString*) getFileName {
    
    NSString* docsDir;
    NSString* baseName;
    NSArray* dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    
    baseName = @"multithreadtest.sqlite";
    return [docsDir stringByAppendingPathComponent: baseName];
}

- (void) openSqliteDb {
    
    NSString* filename = [self getFileName];
    
    NSLog(@"Open database at: %@", filename);
    _fmDatabaseQueue = [FMDatabaseQueue databaseQueueWithPath:filename];
    NSLog(@"Is SQLite compiled with it's thread safe options turned on? %@!", [FMDatabase isSQLiteThreadSafe] ? @"Yes" : @"No");
    
    [_fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT name FROM sqlite_master WHERE type='table' AND name='section';"];
        
        bool exists = rs != nil ? [rs next] : false;
        [rs close];
        
        if(!exists) {
            [self buildDatabaseSchema:db];
        }
        
    }];
}

- (void) destroy {
    NSString* filename = [self getFileName];
    NSError* error = nil;
    
    if(_fmDatabaseQueue) {
        [_fmDatabaseQueue close];
        _fmDatabaseQueue = nil;
    }
    [[NSFileManager defaultManager] removeItemAtPath:filename error:&error];
}

- (bool) buildDatabaseSchema:(FMDatabase*) db {
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"schema" ofType:@"sql"];
    
    NSError* error;
    NSString *content = [NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:&error];
    
    if(error) {
        NSLog(@"Error while reading sql-file: %@", error.localizedDescription);
    }
    
    bool success = [db executeStatements:content];
    
    if(db.hadError) {
        NSLog(@"Sqlite-Error while migration: %@", [db lastErrorMessage] );
    }
    
    return success;
}


+ (id)sharedDatabase {
    static Database *sharedDatabase = nil;
    
    @synchronized(self) {
        if (sharedDatabase == nil)
            sharedDatabase = [[self alloc] init];
    }
    
    return sharedDatabase;
}

- (NSDictionary*) loadDictionaryFromQuery:(NSString*)query withArgs:(NSArray*)args {

    __block NSDictionary* result = nil;
    [_fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        result = [self loadDictionaryFromQuery:query withArgs:args fromDatabase:db];
    }];
    return result;
}

- (NSDictionary*) loadDictionaryFromQuery:(NSString*)query withArgs:(NSArray*)args fromDatabase:(FMDatabase*)db {
    NSDictionary* result = nil;
    FMResultSet* rs = [db executeQuery:query withArgumentsInArray: args];
    
    if(rs == nil) {
        NSLog(@"Database Error: %@", [db lastErrorMessage]);
        return result;
    }
    
    if ([rs next]) {
        result = [[rs resultDictionary] copy];
    }
    [rs close];
    return result;
}

- (int) getIntColumnFromQuery:(NSString*)query forColumn:(NSString*) columnName withArgs:(NSArray*)args fromDatabase:(FMDatabase*)db {
    int result = 0;
    FMResultSet* rs = [db executeQuery:query withArgumentsInArray: args];
    
    if(rs == nil) {
        NSLog(@"Database Error: %@", [db lastErrorMessage]);
        return result;
    }
    
    if ([rs next]) {
        result = [rs intForColumn:columnName];
    }
    [rs close];
    return result;
}

- (NSArray*) loadAllSections {
    
    __block NSMutableArray* result = [NSMutableArray new];
    
    [_fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        
        FMResultSet *rs = [db executeQuery:@"SELECT *, (SELECT COUNT(*) FROM rows WHERE rows.section_id=section.id) AS count_rows FROM section"];
        
        while([rs next]) {
            
            SectionItem* section = [[SectionItem alloc] init];
            section._id = [rs intForColumn:@"id"];
            section.name = [rs stringForColumn:@"name"];
            section.dummy = [rs stringForColumn:@"dummy"];
            section.created = [rs stringForColumn:@"created"];
            section.updated = [rs stringForColumn:@"updated"];
            
            [result addObject:section];
        }
        
        [rs close];
        
    }];
    
    return result;
}


- (bool) addSection:(NSString*)name withDummy:(NSString*)dummy {
    __block bool success = false;
    [_fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        
        NSString* query = @"INSERT INTO section (name, dummy) VALUES (?, ?)";
        
        success = [db executeUpdate:query withArgumentsInArray:@[name, dummy]];
        if(!success) {
            NSLog(@"Database::addSection: %@", db.lastErrorMessage);
        }
        
//        int countSections = [self getIntColumnFromQuery:@"SELECT insert_section_count FROM stats LIMIT 1" forColumn:@"insert_section_count" withArgs:nil fromDatabase:db];
       
//        countSections++;
        
        query = @"UPDATE stats SET insert_section_count=insert_section_count + 1, last_insert_section=CURRENT_TIMESTAMP WHERE id=1";
        success = [db executeUpdate:query];
        if(!success) {
            NSLog(@"Database::update stats: %@", db.lastErrorMessage);
        }
        
    }];
    return success;
}

- (bool) executeStatement:(NSString*) statement {
    __block bool success = false;
    [_fmDatabaseQueue inDatabase:^(FMDatabase *db) {
        
        success = [db executeUpdate:statement];
        if(!success) {
            NSLog(@"Database::executeStatement: %@", db.lastErrorMessage);
        }
    }];
    return success;
    
}

@end
