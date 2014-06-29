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
    
//    BOOL success = [db insert: @"YFDBPersons" set:@{@"pkName": @"周杰伦1", @"txtLove": @"昆凌1"}];
//    FMResultSet * result = [db get: @"mytable"];
//    // 生成: SELECT * FROM mytable
//    
//    FMResultSet * result = [db get: @"mytable" limit: 10 offset:20];
//    
//    // 生成: SELECT * FROM mytable LIMIT 20, 10
    
//    FMResultSet * result  = [db get: @"mytable"];
//	while ([result next]) {
//		// 检索每个记录的值。
//	}
//    id idValue = nil;
//    
//    FMResultSet * result = [db getWhere: @"mytable" where:@{@"id": idValue}];
//    [db select];
//    FMResultSet * result = [db get: @"mytable" limit:1 offset:0];
//    
//    // 生成: SELECT title, content, date FROM mytable
//    [db where: @{@"title": @"B"}];
    
    
//    [db selectSum: @"age"];
//    FMResultSet * result = [db get: @"members"];
    // 生成: SELECT SUM(age) as age FROM members
    
//    $this->db->select_min('age');
//    $query = $this->db->get('members');
//    // 生成: SELECT MIN(age) as age FROM members
    
//    $this->db->select_max('age');
//    $query = $this->db->get('members');
//    // Produces: SELECT MAX(age) as age FROM members
//    
//    $this->db->select_max('age', 'member_age');
//    $query = $this->db->get('members');
//    // Produces: SELECT MAX(age) as member_age FROM members
    
//    [db select: @"title, content, date"];
//    [db from: @"mytable"];
//    FMResultSet * result = [db get];
//    // 生成: SELECT title, content, date FROM mytable
    
//    $this->db->select('*');
//    $this->db->from('blogs');
//    $this->db->join('comments', 'comments.id = blogs.id');
//    $query = $this->db->get();
    
//    [db select];
//    [db from: @"blogs"];
//    [db join: @"comments" condtion: @"comments.id = blogs.id"];
//    FMResultSet * result = [db get];
    
//    $this->db->join('comments', 'comments.id = blogs.id', 'left');
    
//    [db select];
//    [db from: @"blogs"];
//    [db join: @"comments" condtion: @"comments.id = blogs.id" type: YFDBLeftOuterJoin];
//    FMResultSet * result = [db get];
    // 生成:
    // SELECT * FROM blogs
    // LEFT OUTTER JOIN comments ON comments.id = blogs.id
    
//    $this->db->select('title, content, date');
//    $this->db->from('mytable');
//    $query = $this->db->get();
//    // 生成: SELECT title, content, date FROM mytable
    
//    [db select];
//    [db from: @"blogs"];
//    [db orWhere: @{@"name": @"颜风", @"id > ": [NSNumber numberWithUnsignedInteger: 42]}];
//    FMResultSet * result = [db get];
    // 生成:
    // SELECT * FROM blogs
    // WHERE name = '颜风' OR id > 42
    
    
//    $names = array('Frank', 'Todd', 'James');
//    $this->db->where_in('username', $names);
    
//    $names = array('Frank', 'Todd', 'James');
//    $this->db->or_where_in('username', $names);
    // 生成: OR username IN ('Frank', 'Todd', 'James')
    
//    $this->db->like('title', 'match', 'before');
    
    // 生成: WHERE title LIKE '%match'
    
//    [db like: @{@"title": @"颜风"}];
//    [db orNotLike: @{@"body": @"大爱颜风"}];

//    [db selectMax:@"id" alias: @"数量"];
//    [db groupBy: @"title"];
//    FMResultSet * result = [db get: @"blogs"];
//    // 生成:
//    // SELECT * FROM blogs GROUP BY title, id
    
//    $this->db->distinct();
//    $this->db->get('table');
    
//    $this->db->having(array('title =' => 'My Title', 'id <' => $id));
    
    // 生成: HAVING title = 'My Title' AND id < 45
    
//    [db distinct];
//    FMResultSet * result =  [db get: @"blogs"];
    // 生成: SELECT DISTINCT * FROM blogs
    
    // !!!:迭代至此!
//    $this->db->order_by('title desc, name asc');
//    // 生成: ORDER BY title DESC, name ASC
//    [db orderBy: @"title" direction: YFDBOrderDeault];
//    FMResultSet * result =  [db get: @"blogs"];
//    生成:
//    SELECT *
//    FROM (blogs)
//    ORDER BY title DESC
    
//    [db orderBy: @"title DESC, name ASC"];
    
//    [db like: @{@"title": @"颜风"}];
//    NSLog(@"%lu", [db countAllResults: @"blogs"]);
    
//    NSDictionary * set = @{@"title": @"My title",
//                           @"name": @"My Name",
//                           @"date": @"My Date"};
    
//    [db emptyTable: @"mytable"];
    
//[db set: @{@"name": @"my name", @"title": @"my title", @"status": @"my status"}];
//[db insert: @"mytable"];
    
//    [db emptyTable: @"mytable"];
//    [db insert:@"mytable" set: @{@"name": @"my name", @"title": @"my title", @"status": @"my status"}];
//    [db insert:@"mytable" set: @{@"name": @"my name", @"title": @"my title", @"status": @"my status"}];
//    [db insert:@"mytable" set: @{@"name": @"my name", @"title": @"my title", @"status": @"my status"}];
//    [db insert:@"mytable" set: @{@"name": @"my name", @"title": @"my title", @"status": @"my status"}];
    
//NSArray * data = @[@{@"title": @"My title",
//                     @"name": @"My name",
//                     @"date": @"My date"},
//                   @{@"title": @"Another title",
//                     @"name": @"My name2",
//                     @"date": @"My date2"}];
//[db update: @"mytable" batch: data index: @"title"];

//[db where: @{@"id": @"6aKc6aOO"}];
//[db remove: @"mytable1, mytable2, mytable3"];
//    for (int i = 0; i < 100; i++) {
//        [db insert:@"mytable" set: @{@"id": @"6aKc6aOO", @"title": [NSNumber numberWithUnsignedInteger: i]}];
//    }
//    
//    
//[[[[db select: @"title"] from: @"mytable"] where: @{@"id": @"6aKc6aOO"}] limit:5 offset:15];
//FMResultSet * result =  [db get];
// 生成:
// SELECT title
// FROM mytable
// WHERE  id = '6aKc6aOO'
// LIMIT 15, 5
    
    [db startCache];
    [db select: @"field1"];
    [db stopCache];
    FMResultSet * result = [db get: @"tablename"];
    // 生成:
//    SELECT field1
//    FROM tablename
    [db select: @"field2"];
    [db get: @"tablename"];
    // 生成:
//    SELECT field1, field2
//    FROM tablename
//    LIMIT 0, 0
    // ???:迭代至此!为什么会出现 LIMIT 0,0?
    [db flushCache];
    [db select: @"field2"];
    [db get: @"tablename"];
    // 生成:
//    SELECT field2
//    FROM tablename
//    LIMIT 0, 0
    
//    $this->db->start_cache();
//    $this->db->select('field1');
//    $this->db->stop_cache();
//    $this->db->get('tablename');
//    //Generates: SELECT `field1` FROM (`tablename`)
//    $this->db->select('field2');
//    $this->db->get('tablename');
//    //Generates: SELECT `field1`, `field2` FROM (`tablename`)
//    $this->db->flush_cache();
//    $this->db->select('field2');
//    $this->db->get('tablename');
//    //Generates: SELECT `field2` FROM (`tablename`)
    
//    [db emptyTable: @"mytable"];
// 生成: DELETE FROM mytable
// 生成:
// DELETE FROM mytable
// WHERE  id = '6aKc6aOO'

// 生成:
// UPDATE mytable
// SET date = CASE
// WHEN title = 'My title' THEN 'My date'
// WHEN title = 'Another title' THEN 'My date2'
// ELSE date END,
// name = CASE
// WHEN title = 'My title' THEN 'My name'
// WHEN title = 'Another title' THEN 'My name2'
// ELSE name END
// WHERE title IN ('My title', 'Another title')
    
    
//    [db update: @"mytable" set: @{@"name": @"my name", @"title": @"my title", @"status": @"my status"} where: @{@"id": @"6aKc6aOO"}];
// 生成:UPDATE mytable SET title = 'my title', name = 'my name', status = 'my status' WHERE  id = '6aKc6aOO'
    
// 生成:
// SELECT *
// FROM (blogs)
// LIMIT 0, 5
    
    
    NSMutableString * message = [NSMutableString stringWithCapacity: 42];
    
    while ([result next]) {
        [message appendFormat: @"%@\n", [result stringForColumn: @"title"]];
    }
    
    [self showAlertViewWithMessage: message];
    [self showAlertViewWithMessage: db.lastErrorMessage];
    
//    BOOL success = NO;
//    success = [db insert: @"YFDBPersons" batch: @[@{@"pkName": @"周杰伦5", @"intAge": [NSNumber numberWithUnsignedLong: 10]}, @{@"pkName": @"周杰伦6", @"intAge": [NSNumber numberWithUnsignedLong: 10]}]];
//    
//    if (YES != success) {
//        [self showAlertViewWithMessage: db.lastErrorMessage];
//    }
    
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
