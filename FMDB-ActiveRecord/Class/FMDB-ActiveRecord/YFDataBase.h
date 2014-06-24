//
//  YFDataBase.h
//  FMDB-ActiveRecord
//
//  Created by   颜风 on 14-6-21.
//  Copyright (c) 2014年 Shadow. All rights reserved.
//

#import "FMDatabase.h"

// !!!:使用类目扩展FMDataBase的一个可能思路:在类目中重写初始化和dealloc方法,进行添加和销毁"模拟属性"的相关操作.
// !!!:可能的优化:把字符串相关的私有工具方法,放到NSString的一个类目里.
// !!!:用YFDB翻译一个入门教程.或者课堂上的DEMO.
// !!!:将自己的工程升级至YFDB.
// !!!:感觉没必要支持缓存操作机制!
// !!!:移除所有一次性逻辑.

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
// !!!: 统一使用"字段, 字段, 字段"语法,而不是数组语法@[字段,字段,字段]?统一修改一下.
// !!!: 或许应进行容错设置,即使用户进行了转义,也可以!还有where相关的方法,也是如此!
// !!!: 能让生成的sql语句,尽可能规范.
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
                 type: (NSString *) type;

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
 *  @param side  通配位置,可选: @"none", @"before", @"alter", @"both".
 *
 *  @return 实例对象自身.
 */
- (YFDataBase *) like: (NSDictionary *) like
                 side: (NSString *) side;

/**
 *  产生查询的 NOT LIKE 部分.如果有多个,使用 AND 连接.
 *
 *  @param like  一个字典,已字段名为key,以要匹配的字符串为value.
 *  @param side  通配位置,可选: @"none", @"before", @"alter", @"both".
 *
 *  @return 实例对象自身.
 */
- (YFDataBase *) notLike: (NSDictionary *) like
                    side: (NSString *) side;

/**
 *  产生查询的 %LIKE% 部分.如果有多个,使用 OR 连接.
 *
 *  @param like  一个字典,已字段名为key,以要匹配的字符串为value.
 *  @param side  通配位置,可选: @"none", @"before", @"alter", @"both".
 *
 *  @return 实例对象自身.
 */
- (YFDataBase *) OrLike: (NSDictionary *) like
                    side: (NSString *) side;

/**
 *  产生查询的 NOT LIKE 部分.如果有多个,使用 OR 连接.
 *
 *  @param like  一个字典,已字段名为key,以要匹配的字符串为value.
 *  @param side  通配位置,可选: @"none", @"before", @"alter", @"both".
 *
 *  @return 实例对象自身.
 */
- (YFDataBase *) OrNotLike: (NSDictionary *) like
                      side: (NSString *) side;

/**
 *  产生查询的 GROUP BY 部分.
 *
 *  @param by 用于分组的字段,多个字段,请用','分隔.
 *
 *  @return 实例对象自身.
 */
// !!!:by后面的似乎不一定是字段啊!
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
// !!!: direction参数应该写到枚举里.
- (YFDataBase *) orderBy: (NSString *) orderBy
               direction: (NSString *) direction;

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

// !!!:感觉没必要提供limit: 方法.
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
 *  <#Description#>
 *
 *  @param table <#table description#>
 *  @param batch <#batch description#>
 *
 *  @return <#return value description#>
 */
- (BOOL) insertBatch: (NSString *) table
                 set: (NSArray *)  batch;


//!!!:临时跳转	public function insert_batch($table = '', $set = NULL)
// !!!:迭代至此!方法,先模拟 _insertBatch
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

@end
