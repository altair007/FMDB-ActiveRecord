//
//  YFAppDelegate.m
//  FMDB-ActiveRecord
//
//  Created by   颜风 on 14-6-20.
//  Copyright (c) 2014年 Shadow. All rights reserved.
//

#import "YFAppDelegate.h"
#import "FMDB.h"
#import "FMDatabase+ActiveRecord.h"

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
    self.window.backgroundColor = [UIColor blueColor];
    
    // !!!:最终应提供一个可视化的demo.
    // !!!:应该提供对自定义表前缀的支持吗?
    /* 测试数据库 */
    FMDatabase * db = [FMDatabase databaseWithPath: @"/tmp/tmp.db"];
    if (NO == [db open]) {
        [self showAlertViewWithMessage: db.lastErrorMessage];
    }
    
//    NSMutableString * resultStr =  [NSMutableString stringWithString:@"姓名\t性别\t年龄\n"];
//    FMResultSet * result = nil;
    // 测试 getTalbe: limit: offset方法.
//    result = [db getTable: @"persons" limit: 10 offset:0];
    
    // 测试getTable:方法.
//    result = [db getTable: @"persons"];
    
    //  测试getTable:where:limit:offset:方法.
//    result = [db getTable:@"persons" where:@{@"intSex": [NSNumber numberWithBool:NO]} limit:1 offset:0];
    
    // 测试getTable:where:
//    result = [db getTable:@"persons" where: @{@"intSex": [NSNumber numberWithBool: NO]}];
    
    // 测试 select:from:
//    result = [db select:@"*" from:@"persons"];
//    
//    result = [db selectMax:@"intAge" alias:@"age" from: @"persons"];
//    NSString *temp = nil;
//    while ([result next]) {
//        temp = [NSString stringWithFormat:@"年龄: %lu", [result  longForColumn: @"age"]];
//    }
//    [self showAlertViewWithMessage: temp];
//    
//    
//    result = [db selectMax: @"intAge" from: @"persons"];
//    NSString *temp = nil;
//    while ([result next]) {
//        temp = [NSString stringWithFormat:@"年龄: %lu", [result  longForColumn: @"intAge"]];
//    }
//    [self showAlertViewWithMessage: temp];

    
//    result = [db selectMin:@"intAge" alias:@"age" from: @"persons"];
//    NSString *temp = nil;
//    while ([result next]) {
//        temp = [NSString stringWithFormat:@"年龄: %lu", [result  longForColumn: @"age"]];
//    }
//    [self showAlertViewWithMessage: temp];
//    
//    
//    result = [db selectMin: @"intAge" from: @"persons"];
//    NSString *temp = nil;
//    while ([result next]) {
//        temp = [NSString stringWithFormat:@"年龄: %lu", [result  longForColumn: @"intAge"]];
//    }
//    [self showAlertViewWithMessage: temp];
    
    
//    result = [db selectAvg:@"intAge" alias:@"age" from: @"persons"];
//    NSString *temp = nil;
//    while ([result next]) {
//        temp = [NSString stringWithFormat:@"年龄: %g", [result  doubleForColumn: @"age"]];
//    }
//    [self showAlertViewWithMessage: temp];
//    
//    
//    result = [db selectAvg: @"intAge" from: @"persons"];
//    NSString *temp = nil;
//    while ([result next]) {
//        temp = [NSString stringWithFormat:@"年龄: %g", [result  doubleForColumn: @"intAge"]];
//    }
//    [self showAlertViewWithMessage: temp];
//    result = [db selectSum:@"intAge" alias:@"age" from: @"persons"];
//    NSString *temp = nil;
//    while ([result next]) {
//        temp = [NSString stringWithFormat:@"年龄: %g", [result  doubleForColumn: @"age"]];
//    }
//    [self showAlertViewWithMessage: temp];
    
    
//    result = [db selectSum: @"intAge" from: @"persons"];
//    NSString *temp = nil;
//    while ([result next]) {
//        temp = [NSString stringWithFormat:@"年龄: %g", [result  doubleForColumn: @"intAge"]];
//    }
//    [self showAlertViewWithMessage: temp];
    
//    [db insert: @"persons" data: @{@"pkName": @"颜风3", @"intAge": [NSNumber numberWithInteger: 20], @"intSex": [NSNumber numberWithBool:NO]}];
    
//    [db insert: @"persons" batch:@[@{@"pkName": @"颜风3", @"intAge": [NSNumber numberWithInteger: 20], @"intSex": [NSNumber numberWithBool:NO]}]];
//    [db update: @"persons" data:@{ @"intAge": [NSNumber numberWithInteger: 180], @"intSex": [NSNumber numberWithBool:NO]} where:@{@"intAge": [NSNumber numberWithInteger: 200]}];
    
//    [db update: @"persons" batch:@[@{ @"intAge": [NSNumber numberWithInteger: 190], @"intSex": [NSNumber numberWithBool:NO]}] where:@{@"intAge": [NSNumber numberWithInteger: 180]}];
    
//    [db remove:@[@"persons", @"TTAnimals"] where:@{@"pkName":@"s"}];
    
    
//    while ([result next]) {
//        [resultStr appendString:[NSString stringWithFormat:@"%@\t%d\t%lu\n", [result stringForColumn: @"pkName"], [result boolForColumn: @"intSex"], [result longForColumn: @"intAge"]]];
//    }
//    [self showAlertViewWithMessage: resultStr];
    
//    [db empty: @"TTAnimals"];
//    [db truncate: @"TTAnimals"];
    
    
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
