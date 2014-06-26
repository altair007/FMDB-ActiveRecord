//
//  YFDataBase.h
//  FMDB-ActiveRecord
//
//  Created by   颜风 on 14-6-21.
//  Copyright (c) 2014年 Shadow. All rights reserved.
//

#import "FMDatabase.h"


// !!!:用YFDB翻译一个入门教程.
// !!!: 添加一些额外的 常用  AR 功能.
// !!!:使用类目扩展FMDataBase的一个可能思路:在类目中重写初始化和dealloc方法,进行添加和销毁"模拟属性"的相关操作.

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
    YFDBOrderDesc //!< 降序排列.
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
 *  设置一个标志,来向查询字符串编译器指明是否添加 DISTINCT.
 *
 *  @param distinct YES,添加;NO,不添加.
 *
 *  @return 实例对象自身.
 */
- (YFDataBase *) distinct: (BOOL) distinct;

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
 *  产生一个 WHERE 字段 IN ('值1', '值2') 形式的SQL查询.如果需要,使用 AND 与SQL语句其他部分拼接.
 *
 *  @param where 字典,以字段为key,以可选的值为value.多个值,请用','符号分隔.
 *
 *  @return 实例对象自身.
 */
- (YFDataBase *) whereIn: (NSDictionary *) where;

/**
 *  产生一个 WHERE 字段 IN ('值1', '值2') 形式的SQL查询.如果需要,使用 OR 与SQL语句其他部分拼接.
 *
 *  @param where 字典,以字段为key,以可选的值为value.多个值,请用','符号分隔.
 *
 *  @return 实例对象自身.
 */
- (YFDataBase *) orWhereIn: (NSDictionary *) where;

/**
 *  产生一个 WHERE 字段 NOT IN ('值1', '值2') 形式的SQL查询.如果需要,使用 AND 与SQL语句其他部分拼接.
 *
 *  @param where 字典,以字段为key,以可选的值为value.多个值,请用','符号分隔.
 *
 *  @return 实例对象自身.
 */
- (YFDataBase *) whereNotIn: (NSDictionary *) where;

/**
 *  产生一个 WHERE 字段 NOT IN ('值1', '值2') 形式的SQL查询.如果需要,使用 OR 与SQL语句其他部分拼接.
 *
 *  @param where 字典,以字段为key,以可选的值为value.多个值,请用','符号分隔.
 *
 *  @return 实例对象自身.
 */
- (YFDataBase *) OrWhereNotIn: (NSDictionary *) where;

/**
 *  产生查询的 %LIKE% 部分.如果有多个,使用 AND 连接.
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
 *  产生查询的 %LIKE% 部分.如果有多个,使用 OR 连接.
 *
 *  @param like  一个字典,已字段名为key,以要匹配的字符串为value.
 *  @param side  通配位置,可选: @"none", @"before", @"alter", @"both".
 *
 *  @return 实例对象自身.
 */
- (YFDataBase *) OrLike: (NSDictionary *) like
                   side: (YFDBLikeSide) side;

/**
 *  产生查询的 NOT LIKE 部分.如果有多个,使用 OR 连接.
 *
 *  @param like  一个字典,已字段名为key,以要匹配的字符串为value.
 *  @param side  通配位置,可选: @"none", @"before", @"alter", @"both".
 *
 *  @return 实例对象自身.
 */
- (YFDataBase *) OrNotLike: (NSDictionary *) like
                      side: (YFDBLikeSide) side;

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
- (FMResultSet *) getWhere: (NSString *) table
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
 *  @param table     表名,多个用 ',' 分隔.
 *  @param where     一个字典,以字段或包含操作符的字段为key,以条件值为value.
 *  @param resetData 执行成功后是否重置查询操作
 *
 *  @return YES, 执行成功;NO, 执行失败.
 */
- (BOOL) remove: (NSString *) table
          where: (NSDictionary *) where
      resetData: (BOOL) reset;

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
