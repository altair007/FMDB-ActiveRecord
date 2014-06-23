//
//  YFDataBase.h
//  FMDB-ActiveRecord
//
//  Created by   颜风 on 14-6-21.
//  Copyright (c) 2014年 Shadow. All rights reserved.
//

#import "FMDatabase.h"

// !!!:使用类目扩展FMDataBase的一个可能思路:在类目中重写初始化和dealloc方法,进行添加和销毁"模拟属性"的相关操作.

/**
 *  支持Active Record模式的数据库类.
 */
@interface YFDataBase : FMDatabase
#pragma mark - 方法

/**
 *  生成一个查询的 SELECT 部分.
 *
 *  @param field  字段.
 *
 *  @return 实例对象自身.
 */
// !!!: 统一使用"字段, 字段, 字段"语法,而不是数组语法@[字段,字段,字段]?
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
 *  @param table 表名.
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


//!!!:暂时跳出!	public function where_in($key = NULL, $values = NULL)
@end
