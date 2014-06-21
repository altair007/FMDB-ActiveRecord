//
//  FMDatabase+ActiveRecord.m
//  DBActiveRecord
//
//  Created by   颜风 on 14-6-20.
//  Copyright (c) 2014年 Shadow. All rights reserved.
//

#import "FMDatabase+ActiveRecord.h"

@implementation FMDatabase (ActiveRecord)
#pragma mark - 核心方法.
- (FMResultSet *) getTable: (NSString *) table
{
    // ???:此方法有无必要建立在getTable: limit: offset:之上.
    NSString * sql = [NSString stringWithFormat: @"SELECT * FROM %@", table];
    return [self executeQuery: sql];
}

- (FMResultSet *) getTable: (NSString *) table
                     limit: (NSUInteger) limit
                    offset: (NSUInteger) offset
{
    // !!!:每个方法都是这两句,可以进一步封装!
    NSString * sql = [NSString stringWithFormat:@"SELECT * FROM %@ LIMIT %lu, %lu", table, offset, limit];
    return [self executeQuery: sql];
}

- (FMResultSet *) getTable: (NSString *) table
                     where: (NSDictionary *) where
{
    __block NSString * columnName = nil;
    __block id columnValue = nil;
    
    [where enumerateKeysAndObjectsUsingBlock:^(NSString * key, id obj, BOOL *stop) {
        columnName = key;
        columnValue = obj;
    }];
    
    NSString * sql = [NSString stringWithFormat: @"SELECT * FROM %@ WHERE %@ = %@", table, columnName, columnValue];
    return [self executeQuery: sql];
}

- (FMResultSet *) getTable: (NSString *) table
                     where: (NSDictionary *) where
                     limit: (NSUInteger) limit
                    offset: (NSUInteger) offset
{
    __block NSString * columnName = nil;
    __block id columnValue = nil;
    
    [where enumerateKeysAndObjectsUsingBlock:^(NSString * key, id obj, BOOL *stop) {
        columnName = key;
        columnValue = obj;
    }];
    
    NSString * sql = [NSString stringWithFormat: @"SELECT * FROM %@ WHERE %@ = %@ LIMIT %lu, %lu", table, columnName, columnValue, offset, limit];
    return [self executeQuery: sql];
}

- (FMResultSet *) select: (NSString *) select
                    from: (NSString *) table
{
    NSString * sql = [NSString stringWithFormat:@"SELECT %@ FROM %@", select, table];
    return [self executeQuery: sql];
}

// !!!:最大,最小,求和,平均的方法非常相似,仅一处不同.请合并!
- (FMResultSet *) selectMax: (NSString *) field
                      alias: (NSString *) alias
                       from: (NSString *) table
{
    NSString * sql = [NSString stringWithFormat:@"SELECT MAX(%@) as %@ FROM %@", field, alias, table];
    return [self executeQuery: sql];
}

- (FMResultSet *) selectMax: (NSString *) field
                       from: (NSString *) table
{
    return [self selectMax: field alias: field from: table];
}

- (FMResultSet *) selectMin: (NSString *) field
                      alias: (NSString *) alias
                       from: (NSString *) table;
{
    NSString * sql = [NSString stringWithFormat:@"SELECT MIN(%@) as %@ FROM %@", field, alias, table];
    return [self executeQuery: sql];
}

- (FMResultSet *) selectMin: (NSString *) field
                       from: (NSString *) table
{
    return [self selectMin: field alias: field from: table];
}

- (FMResultSet *) selectAvg: (NSString *) field
                      alias: (NSString *) alias
                       from: (NSString *) table;
{
    NSString * sql = [NSString stringWithFormat:@"SELECT AVG(%@) as %@ FROM %@", field, alias, table];
    return [self executeQuery: sql];
}

- (FMResultSet *) selectAvg: (NSString *) field
                       from: (NSString *) table
{
    return [self selectAvg: field alias: field from: table];
}

- (FMResultSet *) selectSum: (NSString *) field
                      alias: (NSString *) alias
                       from: (NSString *) table
{
    NSString * sql = [NSString stringWithFormat:@"SELECT SUM(%@) as %@ FROM %@", field, alias, table];
    return [self executeQuery: sql];
}

- (FMResultSet *) selectSum: (NSString *) field
                       from: (NSString *) table
{
    return [self selectSum: field alias: field from: table];
}
#pragma mark - 工具方法.

@end
