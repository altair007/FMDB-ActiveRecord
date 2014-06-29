//
//  YFDataBase.h
//  FMDB-ActiveRecord
//
//  Created by   颜风 on 14-6-21.
//  Copyright (c) 2014年 Shadow. All rights reserved.
//

#import "FMDatabase.h"

/* 同时提供对 ARC 和 MRC 的支持 */
#if ! __has_feature(objc_arc)
#define YFDBAutorelease(__v) ([__v autorelease]);
#define YFDBReturnAutoreleased YFDBAutorelease

#define YFDBRetain(__v) ([__v retain]);
#define YFDBReturnRetained YFDBRetain

#define YFDBRelease(__v) ([__v release]);
#else
// -fobjc-arc
#define YFDBAutorelease(__v)
#define YFDBReturnAutoreleased(__v) (__v)

#define YFDBRetain(__v)
#define YFDBReturnRetained(__v) (__v)

#define YFDBRelease(__v)
#endif

/**
 *  sqltie支持的join类型.
 */
typedef enum {
    YFDBLeftOuterJoin, //!< 左外连接.
    YFDBInnerJoin //!< 内连接.
} YFDBJoinType;

/**
 *  like子句的通配符添加位置.
 */
typedef enum{
    YFDBLikeSideNone, //!< 不添加通配符.
    YFDBLikeSideBefore,//!< 在前面添加通配符 % .
    YFDBLikeSideAfter,//!< 在后面添加通配符 % .
    YFDBLikeSideBoth //!< 在两端添加通配符 % .
} YFDBLikeSide;

/**
 *  排序方向.
 */
typedef enum{
    YFDBOrderRandom, //!< 随机顺序.
    YFDBOrderAsc, //!< 升序排列.
    YFDBOrderDesc, //!< 降序排列.
    YFDBOrderDeault //!< 默认排序.
} YFDBOrderDirection;

/**
 *  支持Active Record模式的数据库类.
 */
@interface YFDataBase : FMDatabase
#pragma mark - 方法

/**
 *  生成一个查询的 SELECT 部分.
 *
 *  @param field  字段.多个字段,请用","符号分隔.
 *
 *  @return 实例对象自身.
 */
- (YFDataBase *) select: (NSString *) field;

/**
 *  生成一个查询的 SELECT 部分.如果你要查询表中所有的列，可以直接使用这个方法。
 *
 *  @return 实例对象自身。
 */
- (YFDataBase *) select;

/**
 *  生成一个查询的 SELECT MAX(字段) 部分.
 *
 *  @param field  字段.
 *  @param alias  别名.
 *
 *  @return 实例对象自身.
 */
- (YFDataBase *) selectMax: (NSString *) field
                     alias: (NSString *) alias;

/**
 *  生成一个查询的 SELECT MIN(字段) 部分.
 *
 *  @param field  字段.
 *  @param alias  别名.
 *
 *  @return 实例对象自身.
 */
- (YFDataBase *) selectMin: (NSString *) field
                     alias: (NSString *) alias;

/**
 *  生成一个查询的 SELECT AVG(字段) 部分.
 *
 *  @param field  字段.
 *  @param alias  别名.
 *
 *  @return 实例对象自身.
 */
- (YFDataBase *) selectAvg: (NSString *) field
                     alias: (NSString *) alias;

/**
 *  生成一个查询的 SELECT SUM(字段) 部分.
 *
 *  @param field  字段.
 *  @param alias  别名.
 *
 *  @return 实例对象自身.
 */
- (YFDataBase *) selectSum: (NSString *) field
                     alias: (NSString *) alias;

/**
 *  生成一个查询的 SELECT MAX(字段) 部分.
 *
 *  @param field  字段.
 *
 *  @return 实例对象自身.
 */
- (YFDataBase *) selectMax: (NSString *) field;

/**
 *  生成一个查询的 SELECT MIN(字段) 部分.
 *
 *  @param field  字段.
 *
 *  @return 实例对象自身.
 */
- (YFDataBase *) selectMin: (NSString *) field;

/**
 *  生成一个查询的 SELECT AVG(字段) 部分.
 *
 *  @param field  字段.
 *
 *  @return 实例对象自身.
 */
- (YFDataBase *) selectAvg: (NSString *) field;

/**
 *  生成一个查询的 SELECT SUM(字段) 部分.
 *
 *  @param field  字段.
 *
 *  @return 实例对象自身.
 */
- (YFDataBase *) selectSum: (NSString *) field;

/**
 *  为查询语句添加 "DISTINCT" 关键字.
 *
 *  @return 实例对象自身.
 */
- (YFDataBase *) distinct;

/**
 *  生成一个查询的 FROM 部分.
 *
 *  @param table 表名,多个,请用','符号隔开.
 *
 *  @return 实例对象自身.
 */
- (YFDataBase *) from: (NSString *) table;

/**
 *  生成一个查询的 JOIN 部分.
 *
 *  @param table    表名.
 *  @param condtion JOIN 条件.
 *  @param type     JOIN 类型
 *
 *  @return 实例对象自身.
 */
- (YFDataBase *) join: (NSString *) table
             condtion: (NSString *) condtion
                 type: (YFDBJoinType) joinType;

/**
 *  生成一个查询的 JOIN 部分.
 *
 *  @param table    表名.
 *  @param condtion JOIN 条件.
 *
 *  @return 实例对象自身.
 */
- (YFDataBase *) join: (NSString *) table
             condtion: (NSString *) condtion;


/**
 *  产生一个查询的 WHERE 部分.多个查询条件,将使用 AND 连接.
 *
 *  @param where where 一个字典,以字段或包含操作符的字段为key,以条件值为value.
 *
 *  @return 实例对象自身.
 */
- (YFDataBase *) where: (NSDictionary *) where;

/**
 *  产生一个查询的 WHERE 部分.多个查询条件,将使用 OR 连接.
 *
 *  @param where 一个字典,以字段或包含操作符的字段为key,以条件值为value.
 *
 *  @return 实例对象自身.
 */
- (YFDataBase *) orWhere: (NSDictionary *) where;

/**
 *  产生一个 WHERE 字段 IN ('值1', '值2') 形式的SQL查询.如果 WHERE 子句含有其他部分，将用 AND 与其连接起来.
*
*  @param field 字段。
*  @param values 可选的值的范围。
*
*  @return 实例对象自身。
*/
- (YFDataBase *) where: (NSString *) field
              inValues: (NSArray *) values;

/**
 *  产生一个 WHERE 字段 IN ('值1', '值2') 形式的SQL查询.如果 WHERE 子句含有其他部分，将用 OR 与其连接起来.
 *
 *  @param field 字段。
 *  @param values 可选的值的范围。
 *
 *  @return 实例对象自身。
 */
- (YFDataBase *) orWhere: (NSString *) field
                inValues: (NSArray *) values;

/**
 *  产生一个 WHERE 字段 NOT IN ('值1', '值2') 形式的SQL查询.如果 WHERE 子句含有其他部分，将用 AND 与其连接起来.
 *
 *  @param field 字段。
 *  @param values 可选的值的范围。
 *
 *  @return 实例对象自身。
 */
- (YFDataBase *) where: (NSString *) field
           notInValues: (NSArray *) values;

/**
 *  产生一个 WHERE 字段 NOT IN ('值1', '值2') 形式的SQL查询.如果 WHERE 子句含有其他部分，将用 OR 与其连接起来.
 *
 *  @param field 字段。
 *  @param values 可选的值的范围。
 *
 *  @return 实例对象自身。
 */
- (YFDataBase *) orWhere: (NSString *) field
             notInValues: (NSArray *) values;

/**
 *  产生查询的 LIKE 部分.如果有多个,使用 AND 连接.
 *
 *  @param like  一个字典,已字段名为key,以要匹配的字符串为value.
 *  @param side  通配位置,可选: @"none", @"before", @"after", @"both".
 *
 *  @return 实例对象自身.
 */
- (YFDataBase *) like: (NSDictionary *) like
                 side: (YFDBLikeSide) side;

/**
 *  产生查询的 NOT LIKE 部分.如果有多个,使用 AND 连接.
 *
 *  @param like  一个字典,已字段名为key,以要匹配的字符串为value.
 *  @param side  通配位置,可选: @"none", @"before", @"alter", @"both".
 *
 *  @return 实例对象自身.
 */
- (YFDataBase *) notLike: (NSDictionary *) like
                    side: (YFDBLikeSide) side;

/**
 *  产生查询的 LIKE 部分.如果有多个,使用 OR 连接.
 *
 *  @param like  一个字典,已字段名为key,以要匹配的字符串为value.
 *  @param side  通配位置,可选: @"none", @"before", @"alter", @"both".
 *
 *  @return 实例对象自身.
 */
- (YFDataBase *) orLike: (NSDictionary *) like
                   side: (YFDBLikeSide) side;

/**
 *  产生查询的 NOT LIKE 部分.如果有多个,使用 OR 连接.
 *
 *  @param like  一个字典,已字段名为key,以要匹配的字符串为value.
 *  @param side  通配位置,可选: @"none", @"before", @"alter", @"both".
 *
 *  @return 实例对象自身.
 */
- (YFDataBase *) orNotLike: (NSDictionary *) like
                      side: (YFDBLikeSide) side;

/**
 *  产生查询的 LIKE 部分.如果有多个,使用 AND 连接.
 *
 *  @param like  一个字典,已字段名为key,以要匹配的字符串为value.
 *
 *  @return 实例对象自身.
 */
- (YFDataBase *) like: (NSDictionary *) like;

/**
 *  产生查询的 NOT LIKE 部分.如果有多个,使用 AND 连接.
 *
 *  @param like  一个字典,已字段名为key,以要匹配的字符串为value.
 *
 *  @return 实例对象自身.
 */
- (YFDataBase *) notLike: (NSDictionary *) like;

/**
 *  产生查询的 LIKE 部分.如果有多个,使用 OR 连接.
 *
 *  @param like  一个字典,已字段名为key,以要匹配的字符串为value.
 *
 *  @return 实例对象自身.
 */
- (YFDataBase *) orLike: (NSDictionary *) like;

/**
 *  产生查询的 NOT LIKE 部分.如果有多个,使用 OR 连接.
 *
 *  @param like  一个字典,已字段名为key,以要匹配的字符串为value.
 *
 *  @return 实例对象自身.
 */
- (YFDataBase *) orNotLike: (NSDictionary *) like;

/**
 *  产生查询的 GROUP BY 部分.
 *
 *  @param by 用于分组的字段,多个字段,请用','分隔.
 *
 *  @return 实例对象自身.
 */
- (YFDataBase *) groupBy: (NSString *) by;

/**
 *  设置 HAVING 的值.如果有多个,使用 AND 连接.
 *
 *  @param having 一个字典,以HAVING子句前半部分为key,可包含操作符;以HAVIN子句的后半部分为value.
 *
 *  @return 实例对象的自身.
 */
- (YFDataBase *) having: (NSDictionary *) having;

/**
 *  设置 OR HAVING 的值.如果有多个,使用 OR 连接.
 *
 *  @param having 一个字典,以HAVING子句前半部分为key,可包含操作符;以HAVIN子句的后半部分为value.
 *
 *  @return 实例对象自身.
 */
- (YFDataBase *) orHaving: (NSDictionary *) having;

/**
 *  设置 ORDER BY 的值.
 *
 *  @param orderBy   分组依据,多个请用','分隔.
 *  @param direction 排序方式,可选: @"ASC", @"DESC", @"RANDOM"
 *
 *  @return 实例对象自身.
 */
- (YFDataBase *) orderBy: (NSString *) orderBy
               direction: (YFDBOrderDirection) direction;

/**
 *  设置 ORDER BY 的值.此时 SQL 查询中将不会使用 ASC 或 DESC 显示指定排序顺序.
 *
 *  @param orderBy   分组依据,多个请用','分隔.
 *
 *  @return 实例对象自身.
 */
- (YFDataBase *) orderBy: (NSString *) orderBy;

/**
 *  设置 LIMIT 值.
 *
 *  @param limit  查询的限制行数.
 *  @param offset 偏移值.
 *
 *  @return 实例对象自身.
 */
- (YFDataBase *) limit: (NSUInteger) limit
                offset: (NSUInteger) offset;

/**
 *  设置 LIMIT 值.
 *
 *  @param limit  查询的限制行数.
 *
 *  @return 实例对象自身.
 */
- (YFDataBase *) limit: (NSUInteger) limit;

/**
 *  设置 OFFSET 值.
 *
 *  @param offset 偏移值.
 *
 *  @return 实例对象自身.
 */
- (YFDataBase *) offset: (NSUInteger) offset;

/**
 *  设置用于插入或更新数据的键值对.
 *
 *  @param set 字典,以字段为key,以要设置的值为value.
 *
 *  @return 实例对象自身.
 */
- (YFDataBase *) set: (NSDictionary *) set;

/**
 *  基于其他函数编译 SELECT 语句,并执行查询.
 *
 *  @param table  表名,多个表名,请用 ',' 符号分隔.
 *  @param limit  查询的限制行数.
 *  @param offset 偏移值.
 *
 *  @return 查询结果.
 */
- (FMResultSet *) get: (NSString *) table
                limit: (NSUInteger) limit
               offset: (NSUInteger) offset;

/**
 *  基于其他函数编译 SELECT 语句,并执行查询.
 *
 *  @param table 表名,多个表名,请用 ',' 符号分隔.
 *
 *  @return 查询结果.
 */
- (FMResultSet *) get: (NSString *) table;

/**
 *  基于其他函数编译 SELECT 语句,并执行查询.
 *
 *  @return 查询结果.
 */
- (FMResultSet *) get;

/**
 *  产生并执行一个计算查询结果数目的查询.
 *
 *  @param table 表名,多个表名,请用 ',' 符号分隔.
 *
 *  @return 查询结果的数目.
 */
- (NSUInteger) countAllResults: (NSString *) table;

/**
 *  计算查询结果的数目.
 *
 *  @return 查询结果的数目.
 */
- (NSUInteger) countAllResults;

/**
 *  支持往查询中直接添加WHERE子句,查询的限制行数和偏移值.
 *
 *  @param table  表名,多个表名,请用 ',' 符合分隔.
 *  @param where  一个字典,以字段或包含操作符的字段为key,以条件值为value.
 *  @param limit  查询的限制行数.
 *  @param offset 偏移值.
 *
 *  @return 查询结果.
 */
- (FMResultSet *) get: (NSString *) table
                     where: (NSDictionary *) where
                     limit: (NSUInteger) limit
                    offset: (NSUInteger) offset;

/**
 *  支持往查询中直接添加WHERE子句.
 *
 *  @param table  表名,多个表名,请用 ',' 符合分隔.
 *  @param where  一个字典,以字段或包含操作符的字段为key,以条件值为value.
 *
 *  @return 查询结果.
 */
- (FMResultSet *) getWhere: (NSString *) table
                     where: (NSDictionary *) where;

/**
 *  编译批量插入的查询语句并执行查询.
 *
 *  @param table 用于检索数据的表.
 *  @param batch 数组,存储用于一个或多个用于插入数据的字典.
 *
 *  @return YES,执行成功;NO,执行失败.
 */
- (BOOL) insert: (NSString *) table
          batch: (NSArray *)  batch;

/**
 *  编译并执行 INSERT 查询.
 *
 *  @param table 用于插入数据的表.
 *  @param set   字典,以字段为key,以要设置的值为value.
 *
 *  @return YES,成功;NO,失败.
 */
- (BOOL) insert: (NSString *) table
            set: (NSDictionary *) set;

/**
 *  编译并执行 INSERT 查询.
 *
 *  @param table 用于插入数据的表.
 *
 *  @return YES,成功;NO,失败.
 */
- (BOOL) insert: (NSString *) table;

/**
 *  编译并执行 REPLACE 查询.
 *
 *  @param table 用于替换数据的表.
 *  @param set   字典,以字段为key,以要设置的值为value.
 *
 *  @return YES,成功;NO,失败.
 */
- (BOOL) replace: (NSString *) table
             set: (NSDictionary *) set;

/**
 *  编译并执行 REPLACE 查询.
 *
 *  @param table 用于替换数据的表.
 *
 *  @return YES,成功;NO,失败.
 */
- (BOOL) replace: (NSString *) table;

/**
 *  编译批量替换的查询语句并执行查询.
 *
 *  @param table 用于检索数据的表.
 *  @param batch 数组,存储用于一个或多个用于插入数据的字典.
 *
 *  @return YES,执行成功;NO,执行失败.
 */
- (BOOL) replace: (NSString *) table
           batch: (NSArray *)  batch;

/**
 *  编译并执行 UPDATE 查询.
 *
 *  @param table 用于检索数据的表.
 *  @param set   字典,存储用于更新的数据.
 *  @param where 一个字典,以字段或包含操作符的字段为key,以条件值为value.
 *
 *  @return YES,执行成功;NO,执行失败.
 */
- (BOOL) update: (NSString *) table
            set: (NSDictionary *) set
          where: (NSDictionary *) where;

/**
 *  编译并执行 UPDATE 查询.
 *
 *  @param table 用于检索数据的表.
 *  @param set   字典,存储用于更新的数据.
 *
 *  @return YES,执行成功;NO,执行失败.
 */
- (BOOL) update: (NSString *) table
            set: (NSDictionary *) set;

/**
 *  编译并执行 UPDATE 查询.
 *
 *  @param table 用于检索数据的表.
 *
 *  @return YES,执行成功;NO,执行失败.
 */
- (BOOL) update: (NSString *) table;

/**
 *  编译并执行 UPDATE 查询.
 *
 *  @return YES,执行成功;NO,执行失败.
 */
- (BOOL) update;

/**
 *  编译并批量执行 UPDATE 查询.
 *
 *  @param table 用于检索数据的表.
 *  @param batch 数组,存储用于一个或多个用于更新数据的字典.
 *  @param index 索引,即决定数据字典中用于决定更新位置的字段.
 *
 *  @return YES, 执行成功;NO, 执行失败.
 */
- (BOOL) update: (NSString *) table
          batch: (NSArray *) batch
          index: (NSString *) index;

/**
 *  编译一个 DELETE 语句,并执行 "DELETE FROM table".
 *
 *  @param table 要清空的表.
 *
 *  @return YES, 执行成功;NO, 执行失败.
 */
- (BOOL) emptyTable: (NSString *) table;

/**
 *  编译并执行 DELETE 语句.
 *
 *  @param table 表名,多个用 ',' 分隔.
 *  @param where 一个字典,以字段或包含操作符的字段为key,以条件值为value.
 *
 *  @return YES, 执行成功;NO, 执行失败.
 */
- (BOOL) remove: (NSString *) table
          where: (NSDictionary *) where;

/**
 *  编译并执行 DELETE 语句.
 *
 *  @param table 表名,多个用 ',' 分隔.
 *
 *  @return YES, 执行成功;NO, 执行失败.
 */
- (BOOL) remove: (NSString *) table;

/**
 *  开始 ACTIVE RECORD 缓存.
 */
- (void) startCache;

/**
 *  停止 ACTIVE RECORD 缓存.
 */
- (void) stopCache;

/**
 *  清空 ACTIVE RECORD 缓存.
 */
- (void) flushCache;
@end
