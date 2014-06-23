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
    self.window.backgroundColor = [UIColor blueColor];
    
    /* 测试数据库 */
    YFDataBase * db = [YFDataBase databaseWithPath: @"/tmp/tmp.db"];
    if (NO == [db open]) {
        [self showAlertViewWithMessage: db.lastErrorMessage];
    }
//    [db select:@"pkName, txtLove" escape: YES];
//    NSString * str = [db YFDBEscapeIdentifiers: @"数据库.表.王列王.颜风"];
//    [db selectAvg: @"pkName" alias: @""];
//    [db selectSum: @"pkName" alias: @""];
//    [db selectMax: @"pkName" alias: @""];
//    [db selectMin: @"pkName" alias: @""];
//    [db join:@"Person" condtion:@"condition"];
    
//    BOOL b = [db YFDBHasOperator: @"a    b"];
//    [db orWhere: (NSDictionary *) @{@"key = ": @"value", @"key2": [NSNull null]}];
//    [db YFDBLike: @{@"fileld1" : @"val%ue1", @"fileld2" : @"value_2"}
//            type: @"AND"
//            side: @"after"
//             not: YES];

    
//    [db OrWhereNotIn:@{@"key2": @"a, b"}];
//    [db OrWhereNotIn:@{@"key2": @"a, b"}];
//    [db OrNotLike:@{@"fileld1" : @"val%ue1", @"fileld2" : @"value_2"} side:@"BOTH"];
//    [db YFDBExplode: @"无与伦比, 为,杰 ,沉,沦,"];
//    [db groupBy: @"pkName  , ,  txtLove"];
//    [db YFDBHaving: @{@"fileld1" : @"val%ue1", @"fileld2" : @"value_2"}
//              type: @"AND"];
//    [db orHaving: @{@"fileld1" : @"val%ue1", @"fileld2" : @"value_2"}];
    [db orderBy:@"txtName" direction: @""];
    [db orderBy:@"txtName" direction: @"random"];
    
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
