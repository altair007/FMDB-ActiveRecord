//
//  FMDatabase+ActiveRecord.h
//  DBActiveRecord
//
//  Created by   颜风 on 14-6-20.
//  Copyright (c) 2014年 Shadow. All rights reserved.
//

#import "FMDatabase.h"

typedef BOOL (^RemoveSingleBlock) (NSString * talbe, NSDictionary * where); //!< 单次删除数据的block.

//!!!:项目目标: 1.与原有FMDB代码,兼容! 2.简洁. 3.优雅.
// !!!:可能必须使用延展,才能实现既定需求!
// !!!:基本迭代规划:1.实现 2.优化
// !!!:
/*可能的优化方向:
 1.增加安全性检查(FMDB自带吗?).
 2.将getTable:和getTable:limit:offset:等方法合并,使共用getTable:limit:offset:的逻辑.
 3.将select和get等语句剥离,使其支持自由组合,连写语法.(可能需要一个类,而不是类目,来进行封装,要不然,灵活性不够.继承,延展,或者手动添加一个自定义的常量.或者,又或者代理?)
 4.形参本身的命名更规范.
 5.或许需要一个单独的类,来处理字符串的拼接.
 6.根据ARC和MRC,自动编译.(参考FMDB的实现策略)!
 7.借助FMDB,写一个超轻量级的数据库管理程序!(网页版?)
 8.配上每条个方法对应产生的sql语句.
 9.支持Method Chaining方法链.
 */
@interface FMDatabase (ActiveRecord)

#pragma mark - 核心方法.

/**
*  获取某个表的数据.
*
*  @param table 表名称.
*
*  @return 表的全部数据.
*/
- (FMResultSet *) getTable: (NSString *) table;

/**
 *  获取某个表的数据.
 *
 *  @param table  表名称.
 *  @param limit  返回的行数的最大值.
 *  @param offset 返回的第一行的偏移量.初始行的偏移量为0.
 *
 *  @return 某个表存储的信息.
 */
- (FMResultSet *) getTable: (NSString *) table
                     limit: (NSUInteger) limit
                    offset: (NSUInteger) offset;

/**
 *  获取表中符合条件的数据.
 *
 *  @param table 表名.
 *  @param where 只含有一个键值对的字典,以列名为键,以筛选条件为值.
 *
 *  @return 表中符合条件的数据.
 */
- (FMResultSet *) getTable: (NSString *) table
                     where: (NSDictionary *) where;

/**
 *  获取表中符合条件的数据.
 *
 *  @param table  表名.
 *  @param where  只含有一个键值对的字典,以列名为键,以筛选条件为值.
 *  @param limit  返回的行数的最大值.
 *  @param offset 返回的第一行的偏移量.初始行的偏移量为0.
 *
 *  @return 表中符合条件的数据.
 */
- (FMResultSet *) getTable: (NSString *) table
                     where: (NSDictionary *) where
                     limit: (NSUInteger) limit
                    offset: (NSUInteger) offset;

// FIXME: 它应该还有一个参数,用来指定是否转义.
// ???:这个select会支持select的嵌套吗?
/**
 *  从表中筛选数据.
 *
 *  @param select 列名.多个列名以 ',' 隔开,'*'号用来代表所有字段.
 *  @param table  表名.
 *
 *  @return 表中符合条件的数据.
 */
- (FMResultSet *) select: (NSString *) select
                    from: (NSString *) table;

/**
 *  获取表中某个字段的最大值.
 *
 *  @param field 字段名.
 *  @param alias 别名,用于重命名获取的字段.
 *  @param table 表.
 *
 *  @return 符合条件的数据.
 */
- (FMResultSet *) selectMax: (NSString *) field
                      alias: (NSString *) alias
                       from: (NSString *) table;

/**
 *  获取表中某个字段的最大值.
 *
 *  @param field 字段名.
 *  @param table 表.
 *
 *  @return 符合条件的数据.
 */
- (FMResultSet *) selectMax: (NSString *) field
                       from: (NSString *) table;

/**
 *  获取表中某个字段的最小值.
 *
 *  @param field 字段名.
 *  @param alias 别名,用于重命名获取的字段.
 *  @param table 表.
 *
 *  @return 符合条件的数据.
 */
- (FMResultSet *) selectMin: (NSString *) field
                      alias: (NSString *) alias
                       from: (NSString *) table;

/**
 *  获取表中某个字段的最小值.
 *
 *  @param field 字段名.
 *  @param table 表.
 *
 *  @return 符合条件的数据.
 */
- (FMResultSet *) selectMin: (NSString *) field
                       from: (NSString *) table;

/**
 *  获取表中某个字段的平均值.
 *
 *  @param field 字段名.
 *  @param alias 别名,用于重命名获取的字段.
 *  @param table 表.
 *
 *  @return 符合条件的数据.
 */
- (FMResultSet *) selectAvg: (NSString *) field
                      alias: (NSString *) alias
                       from: (NSString *) table;

/**
 *  获取表中某个字段的平均值.
 *
 *  @param field 字段名.
 *  @param table 表.
 *
 *  @return 符合条件的数据.
 */
- (FMResultSet *) selectAvg: (NSString *) field
                       from: (NSString *) table;

/**
 *  获取表中某个字段的和.
 *
 *  @param field 字段名.
 *  @param alias 别名,用于重命名获取的字段.
 *  @param table 表.
 *
 *  @return 符合条件的数据.
 */
- (FMResultSet *) selectSum: (NSString *) field
                      alias: (NSString *) alias
                       from: (NSString *) table;

/**
 *  获取表中选取某个字段的和.
 *
 *  @param field 字段名.
 *  @param table 表.
 *
 *  @return 符合条件的数据.
 */
- (FMResultSet *) selectSum: (NSString *) field
                       from: (NSString *) table;

#pragma mark - 暂时无法再类目中实现的方法.
//!!!:FIXME:通过某种技巧,即使不添加变量,也是可以的.参考UIAlertView-Blocks扩展UIAlertView的思路.
/*
- (void) from;
- (void) join;
- (void) where;
- (void) orWhere;
- (void) whereIn;
- (void) orWhereIn;
- (void) whereNotIn;
- (void) orWhereNotIn;
- (void) like;
- (void) orLike;
- (void) notLike;
- (void) orNotLike;
- (void) groupBy;
- (void) distinct;
- (void) having;
- (void) orHaving;
- (void) orderBy;
- (void) limit;
- (void) countAllResults;
- (void) countAll;*/

// FIXME: 可以利用iskind语法,合并单次操作和批操作.
/**
 *  插入数据.
 *
 *  @param table 表名.
 *  @param data  字典,存储要插入的数据.以字段名为key,以要设置的值为value.
 *
 *  @return YES,成功;NO,失败.
 */
// !!!:CI提供了自动转义功能,处于安全考虑,机制是什么!`加个前缀吗?
- (BOOL) insert: (NSString *) table
           data: (NSDictionary *) data;

/**
 *  批量添加数据.
 *
 *  @param table 表名.
 *  @param batch 数组,存放要插入的数据的字典,字典以字段名为key,以要设置的值为value.
 *
 *  @return YES,添加成功;NO,添加失败.
 */
// !!!:批量操作,是否添加回滚支持?
- (BOOL) insert: (NSString *) table
          batch: (NSArray *) batch;
// !!!:暂无法实现.
/*
- (void) set;
 */
/**
 *  更新数据.
 *
 *  @param table 表名.
 *  @param data  字典,存储要插入的数据.以字段名为key,以要设置的值为value.
 *  @param where 只含有一个键值对的字典,以列名为键,以筛选条件为值.
 *
 *  @return YES,成功;NO,失败.
 */
- (BOOL) update:(NSString *) table
           data: (NSDictionary *) data
          where: (NSDictionary *) where;

/**
 *  批量更新数据.
 *
 *  @param table 表名.
 *  @param batch 数组,存放要插入的数据的字典,字典以字段名为key,以要设置的值
 *  @param where 只含有一个键值对的字典,以列名为键,以筛选条件为值.
 *
 *  @return YES,成功;NO,失败.
 */
- (BOOL) update: (NSString *) table
          batch: (NSArray *) batch
          where: (NSDictionary *) where;

/**
 *  删除数据.
 *
 *  @param tables 表名.你也可以传入多个表名字符串组成的数组,同时在多个表中删除数据.
 *  @param where  只含有一个键值对的字典,以列名为键,以筛选条件为值.
 *
 *  @return YES,成功;NO,失败.
 */
- (BOOL) remove: (id) tables
          where: (NSDictionary *) where;

/**
 *  清空表.
 *
 *  @param table 表名.
 *
 *  @return YES,成功;NO,失败.
 */
- (BOOL) empty: (NSString *)table;

// !!!:sqlite 不符合truncate命令!
/*
- (BOOL) truncate: (NSString *) table;
*/

// !!!:以下方法,暂时无法实现.(能力不够!)
/*
- (void) startCache;
- (void) stopCache;
- (void) flushCache;
*/
 
# pragma mark - 工具方法.

@end
