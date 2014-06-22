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
 *  @param field  数组,或者以','分隔的字符串,用于存储字段信息.
 *
 *  @return 实例对象自身.
 */
- (YFDataBase *) select: (id) field;

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
 *  @param table 表名.可以是一个字符串或数组.
 *
 *  @return 实例对象自身.
 */
// !!!:我觉得此处不应该提供对数组的额外支持!OC不是脚本!会带来使用者理解的混乱!
- (YFDataBase *) from: (id) table;

@end
