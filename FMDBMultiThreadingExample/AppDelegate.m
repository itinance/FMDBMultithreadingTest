//
//  AppDelegate.m
//  FMDBMultiThreadingExample
//
//  Created by Hagen Hübel on 08/06/15.
//  Copyright (c) 2015 ITinance GmbH. All rights reserved.
//

#import "AppDelegate.h"
#import "DatabaseSectionInserter.h"
#import "DatabaseSectionTruncater.h"

@interface AppDelegate () {
    DatabaseSectionInserter* inserter;
    DatabaseSectionInserter* inserter2;
    DatabaseSectionTruncater* truncater;
    DatabaseSectionTruncater* truncater2;
}


@end

@implementation AppDelegate

dispatch_source_t CreateDispatchTimer(double interval, dispatch_queue_t queue, dispatch_block_t block)
{
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    if (timer)
    {
        dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, interval * NSEC_PER_SEC), interval * NSEC_PER_SEC, (1ull * NSEC_PER_SEC) / 10);
        dispatch_source_set_event_handler(timer, block);
        dispatch_resume(timer);
    }
    return timer;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    inserter = [[DatabaseSectionInserter alloc] initWithInterval:0.0300f];
    truncater = [[DatabaseSectionTruncater alloc] initWithInterval:.300f];

    inserter2 = [[DatabaseSectionInserter alloc] initWithInterval:0.700f];
    truncater2 = [[DatabaseSectionTruncater alloc] initWithInterval:0.783f];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
