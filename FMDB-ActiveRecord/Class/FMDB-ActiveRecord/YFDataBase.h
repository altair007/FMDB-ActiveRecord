//
//  YFDataBase.h
//  FMDB-ActiveRecord
//
//  Created by   颜风 on 14-6-21.
//  Copyright (c) 2014年 Shadow. All rights reserved.
//

#import "FMDatabase.h"

/**
 *  支持Active Record模式的数据库类.
 */
@interface YFDataBase : FMDatabase
#pragma mark - 属性.
@property (retain, nonatomic) NSArray * arSelect;
@property (assign, nonatomic) BOOL      arDistinct;
@property (retain, nonatomic) NSArray * arFrom;
@property (retain, nonatomic) NSArray * arJoin;
@property (retain, nonatomic) NSArray * arWhere;
@property (retain, nonatomic) NSArray * arLike;
@property (retain, nonatomic) NSArray * arGroupby;
@property (retain, nonatomic) NSArray * arHaving;
@property (retain, nonatomic) NSArray * arKeys;
@property (assign, nonatomic) BOOL      arLimit;
@property (assign, nonatomic) BOOL      arOffset;
@property (assign, nonatomic) BOOL      arOrder;
@property (retain, nonatomic) NSArray * arOrderby;
@property (retain, nonatomic) NSArray * arSet;
@property (retain, nonatomic) NSArray * arWherein;
@property (retain, nonatomic) NSArray * arAliasedTables;
@property (retain, nonatomic) NSArray * arStoreArray;

#pragma mark - Active Record 缓存属性.
@property (assign, nonatomic) BOOL      arCaching;
@property (retain, nonatomic) NSArray * arCacheExists;
@property (retain, nonatomic) NSArray * arCacheSelect;
@property (retain, nonatomic) NSArray * arCacheFrom;
@property (retain, nonatomic) NSArray * arCacheJoin;
@property (retain, nonatomic) NSArray * arCacheWhere;
@property (retain, nonatomic) NSArray * arCacheLike;
@property (retain, nonatomic) NSArray * arCacheGroupby;
@property (retain, nonatomic) NSArray * arCacheHaving;
@property (retain, nonatomic) NSArray * arCacheOrderby;
@property (retain, nonatomic) NSArray * arCacheSet;

@property (retain, nonatomic) NSArray * arNoEscape;
@property (retain, nonatomic) NSArray * arCacheNoEscape;

#pragma mark - 方法

/**
 *  生成查询的选择部分.
 *
 *  @param select 选择.
 *  @param escape 是否转义.YES,转义;NO,不转义.
 *
 *  @return 实例对象自身.
 */
- (instancetype)select: (NSString *) select
                escape: (BOOL)       escape;

@end
