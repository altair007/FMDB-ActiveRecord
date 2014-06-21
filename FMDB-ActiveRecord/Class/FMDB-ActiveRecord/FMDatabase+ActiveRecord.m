//
//  FMDatabase+ActiveRecord.m
//  DBActiveRecord
//
//  Created by   颜风 on 14-6-20.
//  Copyright (c) 2014年 Shadow. All rights reserved.
//

// TODO:实现使用类目模拟出一个属性的核心:
/*
 
 #import <objc/runtime.h>
 
 static NSString *RI_BUTTON_ASS_KEY = @"com.random-ideas.BUTTONS";
 
 NSArray *buttonsArray = objc_getAssociatedObject(self, (__bridge const void *)RI_BUTTON_ASS_KEY);
 
objc_setAssociatedObject(self, (__bridge const void *)RI_BUTTON_ASS_KEY, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

objc_setAssociatedObject(self, (__bridge const void *)RI_BUTTON_ASS_KEY, buttonItems, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
 */

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
    NSString * sql = [NSString stringWithFormat:@"SELECT * FROM %@ LIMIT %lu, %lu", table, offset, limit];
    return [self executeQuery: sql];
}

- (FMResultSet *) getTable: (NSString *) table
                     where: (NSDictionary *) where
{
    NSMutableString * whereClause = [NSMutableString stringWithCapacity: 42];
    [where enumerateKeysAndObjectsUsingBlock:^(NSString * key, id obj, BOOL *stop) {
        [whereClause appendString: [NSString stringWithFormat:@"`%@` = \'%@\'", key, obj]];
        * stop = YES;
    }];
    
    NSString * sql = [NSString stringWithFormat: @"SELECT * FROM %@ WHERE %@", table, whereClause];
    return [self executeQuery: sql];
}

- (FMResultSet *) getTable: (NSString *) table
                     where: (NSDictionary *) where
                     limit: (NSUInteger) limit
                    offset: (NSUInteger) offset
{
    NSMutableString * whereClause = [NSMutableString stringWithCapacity: 42];
    [where enumerateKeysAndObjectsUsingBlock:^(NSString * key, id obj, BOOL *stop) {
        [whereClause appendString: [NSString stringWithFormat:@"`%@` = \'%@\'", key, obj]];
        * stop = YES;
    }];
    
    NSString * sql = [NSString stringWithFormat: @"SELECT * FROM %@ WHERE %@ LIMIT %lu, %lu", table, whereClause, offset, limit];
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

// !!!:插入,更新,删除,似乎也只是block不一样而已,进一步封装?
- (BOOL) insert: (NSString *) table
           data: (id) data
{
    InsertSingleBlock insertBlock = ^(NSString * table, NSDictionary * data){
        NSMutableString * fields = [NSMutableString stringWithCapacity: 42];
        NSMutableString * values = [NSMutableString stringWithCapacity: 42];
        
        [data enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            // !!!:此处给所有的字段添加``修饰,给所有的值添加''修饰,是否推广?
            [fields appendString:[NSString stringWithFormat:@"`%@`,", key]];
            [values appendString: [NSString stringWithFormat: @"'%@',", obj]];
        }];
        
        [fields deleteCharactersInRange:NSMakeRange(fields.length - 1, 1)];
        [values deleteCharactersInRange:NSMakeRange(values.length - 1, 1)];
        
        NSString * sql = [NSString stringWithFormat: @"INSERT INTO %@ (%@) VALUES (%@)", table, fields, values];
        return [self executeUpdate: sql];
    };
    
    if ([data isKindOfClass: [NSDictionary class]]) {
        return insertBlock(table, data);
    }
    
    if (NO == [data isKindOfClass: [NSArray class]]) {// ???:当传入的数据类型不对,在返回NO的同时,有无必要设置lastErrorMessage.?
        return NO;
    }
    
    __block BOOL success = YES;
    [(NSArray *)data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (NO == insertBlock(table, obj)) {
            success = NO;
            * stop = YES;
        }
    }];
    return success;
}

- (BOOL) update: (NSString *) table
           data: (id) data
          where: (id) where
{
    if(NO == [data isKindOfClass:[where class]]){
        return NO;
    }
    
    UpdateSingleBlock updateBlock = ^(NSString * table, NSDictionary * data, NSDictionary * where){
        // !!!:应该把这些生成子句的方法,封装成方法.
        NSMutableString * setClause = [NSMutableString stringWithCapacity: 42];
        [data enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [setClause appendString:[NSMutableString stringWithFormat:@"`%@` = '%@',", key, obj]];
        }];
        [setClause deleteCharactersInRange:NSMakeRange(setClause.length - 1, 1)];
        
        NSMutableString * whereClause = [NSMutableString stringWithCapacity: 42];
        [where enumerateKeysAndObjectsUsingBlock:^(NSString * key, id obj, BOOL *stop) {
            [whereClause appendString: [NSString stringWithFormat:@"`%@` = \'%@\'", key, obj]];
            * stop = YES;
        }];
        
        NSString * sql = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE %@", table, setClause, whereClause];
        return [self executeUpdate: sql];
    };
    
    if ([data isKindOfClass: [NSDictionary class]]) {
        return updateBlock(table, data, where);
    }
    
    if (NO == [data isKindOfClass: [NSArray class]]) {// ???:当传入的数据类型不对,在返回NO的同时,有无必要设置lastErrorMessage.?
        return NO;
    }
    
    __block BOOL success = YES;
    [(NSArray *)data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (NO == updateBlock(table, obj, [(NSArray *)where objectAtIndex: idx])) {
            success = NO;
            * stop = YES;
        }
    }];
    return success;
}


- (BOOL) remove: (id) table
          where: (NSDictionary *) where
{
    RemoveSingleBlock removeBlock  = ^(NSString * table, NSDictionary * where){
        NSMutableString * whereClause = [NSMutableString stringWithCapacity: 42];
        [where enumerateKeysAndObjectsUsingBlock:^(NSString * key, id obj, BOOL *stop) {
            [whereClause appendString: [NSString stringWithFormat:@"`%@` = \'%@\'", key, obj]];
            * stop = YES;
        }];
        
        NSString * sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@", table, whereClause];
        return [self executeUpdate: sql];
    };
    
    if ([table isKindOfClass: [NSString class]]) {
        return removeBlock(table, where);
    }
    
    if (NO == [table isKindOfClass:[NSArray class]]) {
        return NO;
    }
    
    __block BOOL success = YES;
    [(NSArray *)table enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (NO == removeBlock(obj, where)) {
            success = NO;
            * stop = YES;
        }
    }];
    
    return success;
}

- (BOOL) empty: (NSString *)table
{
    NSString * sql = [NSString stringWithFormat: @"DELETE FROM %@", table];
    return [self executeUpdate: sql];
}

#pragma mark - 工具方法.

@end
