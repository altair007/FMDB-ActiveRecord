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
 *  @param select 数组,或者以','分隔的字符串,用于存储字段信息.
 *  @param escape 是否转义.YES,转义;NO,不转义.
 *
 *  @return 实例对象自身.
 */
- (YFDataBase *) select: (id)    select
                 escape: (BOOL)  escape;

/**
 *  生成一个查询的 SELECT MAX(字段) 部分.
 *
 *  @param select 字段.
 *  @param alias  别名.
 *
 *  @return 实例对象自身.
 */
- (YFDataBase *) selectMax: (NSString *) select
                     alias: (NSString *) alias;

/**
 *  生成一个查询的 SELECT MIN(字段) 部分.
 *
 *  @param select 字段.
 *  @param alias  别名.
 *
 *  @return 实例对象自身.
 */
- (YFDataBase *) selectMin: (NSString *) select
                     alias: (NSString *) alias;

/**
 *  生成一个查询的 SELECT AVG(字段) 部分.
 *
 *  @param select 字段.
 *  @param alias  别名.
 *
 *  @return 实例对象自身.
 */
- (YFDataBase *) selectAvg: (NSString *) select
                     alias: (NSString *) alias;

/**
 *  生成一个查询的 SELECT SUM(字段) 部分.
 *
 *  @param select 字段.
 *  @param alias  别名.
 *
 *  @return 实例对象自身.
 */
- (YFDataBase *) selectSum: (NSString *) select
                     alias: (NSString *) alias;

@end
