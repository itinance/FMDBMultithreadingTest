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
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _database = [Database sharedDatabase];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
