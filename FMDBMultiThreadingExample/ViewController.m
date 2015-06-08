//
//  ViewController.m
//  FMDBMultiThreadingExample
//
//  Created by Hagen Hübel on 08/06/15.
//  Copyright (c) 2015 ITinance GmbH. All rights reserved.
//

#import "ViewController.h"
#import "Database.h"

@interface ViewController () {
    Database* _database;
    NSTimer* _timer;
    NSTimer* _timerStats;
}
@property (weak, nonatomic) IBOutlet UITextView *txtResult;
@property (weak, nonatomic) IBOutlet UITextView *txtStatus;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _database = [Database sharedDatabase];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                              target:self selector:@selector(timerMethod)
                                            userInfo:nil repeats:YES];
    
    
    _timerStats = [NSTimer scheduledTimerWithTimeInterval:0.3
                                                      target:self selector:@selector(updateStats)
                                                    userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) updateStats {

    NSDictionary* stats =
    [_database loadDictionaryFromQuery:@"SELECT *, (SELECT COUNT(*) FROM section) AS sections FROM stats WHERE id=1" withArgs:nil];
   
    
    NSMutableString* s = [@"" mutableCopy];
    for(NSString* key in stats.allKeys) {
        [s appendFormat:@"%@: %@   |    ", key, [stats valueForKey:key] ];
    }
    
    self.txtStatus.text = s;
    
}

- (void) timerMethod {
    
    NSArray* sections = [_database loadAllSections];
    
    NSMutableString* s = [@"" mutableCopy];
    
    for(SectionItem* section in sections) {
        [s appendString: section.debugDescription];
        [s appendString:@"\n"];
    }
    
    self.txtResult.text = s;
}

@end
