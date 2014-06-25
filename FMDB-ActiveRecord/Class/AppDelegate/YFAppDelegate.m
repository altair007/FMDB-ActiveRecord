//
//  YFAppDelegate.m
//  FMDB-ActiveRecord
//
//  Created by   颜风 on 14-6-20.
//  Copyright (c) 2014年 Shadow. All rights reserved.
//

#import "YFAppDelegate.h"
#import "FMDB.h"
#import "YFDataBase.h"

@implementation YFAppDelegate
-(void)dealloc
{
    self.window = nil;
    
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor grayColor];
    
    /* 测试数据库 */
    YFDataBase * db = [YFDataBase databaseWithPath: @"/tmp/tmp.sqlite"];
    if (NO == [db open]) {
        [self showAlertViewWithMessage: db.lastErrorMessage];
    }

//    FMResultSet * result = [db get:@"YFDBPerson"];
//    while ([result next]) {
//        NSString * name = [result stringForColumn: @"pkName"];
//        NSUInteger age = [result intForColumn: @"intAge"];
//        [self showAlertViewWithMessage: [name stringByAppendingFormat:@"%@", [NSNumber numberWithUnsignedInteger: age]]];
//    }
//    [self showAlertViewWithMessage: db.lastErrorMessage];
    
//    NSString * str = [db YFDBInsert: @"YFDBPerson"
//                               keys: @[@"pkName", @"intAge"]
//                             values: @[@"'颜风'", @"'18'"]];
//
//    [db getWhere: @"YFDBPerson" where:@{@"intAge >":@"100"} limit: 3 offset:0];
//    BOOL b = [db insert: @"YFDBPerson" set: @{@"pkName": @"jayChou", @"pkName": [NSNumber numberWithUnsignedInteger: 42]}];
//    
    
//    [db YFDBSetInsertBatch: @[@{@"A":@"a1", @"B": @"b1", @"C":@"c1"}, @{@"B":@"b2", @"A": @"a2", @"C":@"c2"}, @{@"C":@"c3", @"B": @"b3", @"A":@"a3"}]];
    
//    BOOL b = [db insertBatch: @"YFDBPersons" set: @[@{@"pkName": @"桂纶镁", @"intAge": [NSNumber numberWithUnsignedInteger: 10]}, @{@"pkName": @"昆凌", @"intAge": [NSNumber numberWithUnsignedInteger: 10]}]];
    
//    NSString * str = [db YFDBReplaceBatch: @"YFDBPersons"
//                                    keys: @[@"pkName", @"intAge"]
//                                   values: @[@"('颜风', '21')", @"('Jay', '32')"]];
    
//    BOOL b = [db replace:@"YFDBPersons"
//                             set:@{@"pkName": @"周杰伦", @"intAge": @"111"}];
    
//    BOOL b = [db replaceBatch: @"YFDBPersons" set: @[@{@"pkName": @"桂纶镁", @"intAge": [NSNumber numberWithUnsignedInteger: 212]}, @{@"pkName": @"昆凌", @"intAge": [NSNumber numberWithUnsignedInteger: 12123]}]];

    NSString * str =  [db YFDBUpdate: @"YFDBPersons"
                           values: @{@"pkName":@"'昆凌'"}
                            where: @[@"pkName = '桂纶镁'", @"intAge = '212'"]
                          orderby: nil
                            limit: NSUIntegerMax];
    [self showAlertViewWithMessage: db.lastErrorMessage];
    
    [db close];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void) showAlertViewWithMessage: (NSString *) message
{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"数据库测试:" message: message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alertView show];
    [alertView release];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
