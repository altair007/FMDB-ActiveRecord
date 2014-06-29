//
//  YFDataBase.m
//  FMDB-ActiveRecord
//
//  Created by   颜风 on 14-6-21.
//  Copyright (c) 2014年 Shadow. All rights reserved.
//

#import "YFDataBase.h"

@interface YFDataBase ()

#pragma mark - 私有属性.
@property (retain, nonatomic) NSMutableArray * arSelect; //!<  存储 SELECT 子句的信息.
@property (assign, nonatomic) BOOL   arDistinct; //!< 存储 DISTINCT 子句的信息.
@property (retain, nonatomic) NSMutableArray * arFrom; //!< 存储 FROM 子句的信息.
@property (retain, nonatomic) NSMutableArray * arJoin; //!< 存储 JOIN 子句的信息.
@property (retain, nonatomic) NSMutableArray * arWhere; //!< 存储 WHERE 子句的信息.
@property (retain, nonatomic) NSMutableArray * arLike; //!< 存储 LIKE 子句的信息.
@property (retain, nonatomic) NSMutableArray * arGroupby; //!< 存储 GROUPBY 子句的信息.
@property (retain, nonatomic) NSMutableArray * arHaving; //!< 存储 HAVING 子句的信息.
@property (retain, nonatomic) NSMutableArray * arKeys; //!< 批量插入时,用于存储 字段 信息.
@property (assign, nonatomic)     NSUInteger   arLimit; //!<  存储查询的限制行数.
@property (assign, nonatomic)     NSUInteger   arOffset; //!< 查询偏移值.
@property (retain, nonatomic) NSMutableArray * arOrderby; //!< 存储 ORDER 子句的信息.
@property (retain, nonatomic) NSMutableDictionary * arSet; //!< 存储 SET 子句的信息.
@property (retain, nonatomic) NSMutableArray * arSetBatch; //!< 批量插入时,存储 SET 子句的信息.
@property (retain, nonatomic) NSMutableArray * arWherein; //!< 存储 IN 子句的相关信息.

// Active Record 缓存属性.
@property (assign, nonatomic)           BOOL   arCaching; //!< 是否缓存AR操作.
@property (retain, nonatomic) NSMutableArray * arCacheExists; //!< 存储已经缓存的操作的名称.
@property (retain, nonatomic) NSMutableArray * arCacheSelect; //!< 缓存 SELECT 子句的信息.
@property (retain, nonatomic) NSMutableArray * arCacheFrom; //!< 缓存 FROM 子句的信息.
@property (retain, nonatomic) NSMutableArray * arCacheJoin; //!< 缓存 JOIN 子句的信息.
@property (retain, nonatomic) NSMutableArray * arCacheWhere; //!< 缓存 WHERE 子句的信息.
@property (retain, nonatomic) NSMutableArray * arCacheLike; //!< 缓存 LIKE 子句的信息.
@property (retain, nonatomic) NSMutableArray * arCacheGroupby; //!< 缓存 GROUPBY子句的信息.
@property (retain, nonatomic) NSMutableArray * arCacheHaving; //!< 缓存 HAVING 子句的信息.
@property (retain, nonatomic) NSMutableArray * arCacheOrderby; //!< 缓存 ORDERBY 子句的信息.
@property (retain, nonatomic) NSMutableArray * arCacheSet; //!< 缓存 SET 子句的信息.

#pragma mark - 私有方法.
/**
 *  为下面四个公开方法服务.
 *
 *  selectMax:alias:
 *  selectMin:alias:
 *  selectAvg:alias:
 *  selectSum:alias:
 *
 *  @param field  字段.
 *  @param alias  别名.
 *  @param type   类型.
 *
 *  @return 实例对象自身.
 */
- (YFDataBase *) YFDBMaxMinAvgSum: (NSString *) field
                            alias: (NSString *) alias
                             type: (NSString *) type;

/**
 *  根据表来产生别名.
 *
 *  @param item 一项.
 *
 *  @return 此项对应的别名.
 */
- (NSString *) YFDBCreateAliasFromTable: (NSString *) item;

/**
 *  供where: 和orWhere:type:调用.
 *
 *  @param where 一个字典,以字段或包含操作符的字段为key,以条件值为value.
 *  @param type  类型.
 *
 *  @return 实例对象自身.
 */
- (YFDataBase *) YFDBWhere: (NSDictionary *) where
                      type: (NSString *) type;

/**
 *  测试字符串是否含有一个SQL操作符.
 *
 *  @param str 字符串.
 *
 *  @return YES,含有;NO,不含有;
 */
- (BOOL) YFDBHasOperator: (NSString *) str;

/**
 *  清除字符串的首尾空白.
 *
 *  @param str 字符串.
 *
 *  @return 一个新的字符串.
 */
- (NSString *) YFDBTrim: (NSString *) str;

/**
 *  供其他方法调用:where:in: where:inOr: where:notIn: where:notInOr:.
 *
 *  @param field 字段.
 *  @param values 可选范围.
 *  @param isNot YES,是 NOT IN查询;NO,是 IN查询.
 *  @param type  类型,可选: @"AND", @"OR"
 *
 *  @return 实例对象自身.
 */
- (YFDataBase *) YFDBWhere: (NSString *) field
                  inValues: (NSArray *) values
                       not: (BOOL) isNot
                      type: (NSString *) type;

/**
 *  使用"'"符号转义字符串.
 *
 *  @param str 字符串.
 *
 *  @return 转义后的字符串.
 */
- (NSString *) YFDBEscape: (NSString *) str;

/**
 *  供 like:side: 和orLike:side: 调用.
 *
 *  @param like  一个字典,以字段名为key,以要匹配的字符串为value.
 *  @param type  类型,可选: @"AND", @"OR".
 *  @param side  通配位置,可选: @"none", @"before", @"alter", @"both".
 *  @param isNot YES,是 NOT LIKE查询;NO,是 LIKE查询.
 *
 *  @return 实例对象自身.
 */
- (YFDataBase *) YFDBLike: (NSDictionary *) like
                     type: (NSString *) type
                     side: (YFDBLikeSide) side
                      not: (BOOL) isNot;

/**
 *  供 having: 和 orHaving: 调用.
 *
 *  @param having 一个字典,以HAVING子句前半部分为key,可包含操作符;以HAVIN子句的后半部分为value.
 *  @param type   类型,可选: @"AND", @"OR".
 *
 *  @return 实例对象自身.
 */
- (YFDataBase *) YFDBHaving: (NSDictionary *) having
                       type: (NSString *) type;

/**
 *  当被调用时,合并缓存的数据库查询信息.
 */
- (void) YFDBMergeCache;

/**
 *  重置 active record 的值.
 *
 *  @param resetItems 一个字典,以要重置的属性为key,以属性默认值为value.
 */
- (void) YFDBResetRun: (NSDictionary *) resetItems;

/**
 *  重置 active record 的值.
 */
- (void) YFDBResetSelect;

/**
 *  编译 SELECT 语句.
 *
 *  @param  selectOverride 覆盖SELECT子句的内容.
 *
 *  @return SELECT 语句.
 */
- (NSString *) YFDBCompileSelect: (NSString *) selectOverride;

/**
 *  编译 SELECT 语句.
 *
 *  @return SELECT 语句.
 */
- (NSString *) YFDBCompileSelect;

- (NSString *) YFDBFromTables: (NSArray *) tables;

/**
 *  根据提供的数据生成一个 INSERT 子句.
 *
 *  @param table  表名.
 *  @param keys   用于插入的键.
 *  @param values 用于插入的值.
 *
 *  @return INSERT 子句.
 */
- (NSString *) YFDBInsert: (NSString *) table
                     keys: (NSArray *) keys
                   values: (NSArray *) values;

/**
 *  根据提供的数据生成一个 INSERT 子句, 用于批量插入.
 *
 *  @param table  表名.
 *  @param keys   用于插入的键.
 *  @param values 用于插入的值.
 *
 *  @return INSERT 子句.
 */
- (NSString *) YFDBInsert: (NSString *) table
                          batch: (NSArray *) keys
                        values: (NSArray *) values;

/**
 *  重置 ACTIVE RECORD "写"的值.
 */
- (void) YFDBResetWrite;

/**
 *  支持设置用于批量插入或替换的键值对.
 *
 *  @param batch 数组,存储用于一个或多个用于插入或替换数据的字典.
 *
 *  @return 实例对象自身.
 */
- (YFDataBase *) YFDBSetInsertBatch: (NSArray *) batch;

/**
 *  根据提供的数据生成一个 REPLACE 子句.
 *
 *  @param table  表名.
 *  @param keys   用于替换的键.
 *  @param values 用于替换的值.
 *
 *  @return INSERT 子句.
 */
- (NSString *) YFDBReplace: (NSString *) table
                      keys: (NSArray *) keys
                    values: (NSArray *) values;

/**
 *  根据提供的数据生成一个 REPLACE 子句, 用于批量插入.
 *
 *  @param table  表名.
 *  @param keys   用于替换的键.
 *  @param values 用于替换的值.
 *
 *  @return INSERT 子句.
 */
- (NSString *) YFDBReplaceBatch: (NSString *) table
                           keys: (NSArray *) keys
                         values: (NSArray *) values;

/**
 *  根据提供的数据生成一个 UPDATE 子句.
 *
 *  @param table   表名.
 *  @param values  用于UPDATE的数据.
 *  @param where   where子句.
 *  @param orderby orderby子句.
 *  @param limit   limit子句.
 *
 *  @return 一个 UPDATE 子句.
 */
- (NSString *) YFDBUpdate: (NSString *) table
                   values: (NSDictionary *) values
                    where: (NSArray *) where;

/**
 *  支持设置用于批量更新的键值对.
 *
 *  @param batch 数组,存储用于一个或多个用于更新数据的字典.
 *  @param index 索引,即决定数据字典中用于决定更新位置的字段.
 *
 *  @return 实例对象自身.
 */
- (YFDataBase *) YFDBSetUpdateBatch: (NSArray *) batch
                              index: (NSString *) index;

/**
 *  根据提供的数据生成一个 UPDATE 子句, 用于批量更新.
 *
 *  @param table 表名.
 *  @param sets  用于 UPDATE 的数据.
 *  @param index 索引,即决定数据字典中用于决定更新位置的字段.
 *  @param where WHERE 子句.
 *
 *  @return UPDATE 子句.
 */
- (NSString *) YFDBUpdate: (NSString *) table
                    batch: (NSArray*) sets
                    index: (NSString *) index
                    where: (NSArray *) where;

/**
 *  依据提供的数据生成一个 DELETE 子句.
 *
 *  @param table 表名.
 *  @param where WHERE 子句.
 *  @param like  LIKE子句
 *
 *  @return DELETE 子句.
 */
- (NSString *) YFDBDelete: (NSString *) table
                    where: (NSArray *) where
                     like: (NSArray *) like;


/**
 *  编译并执行 DELETE 语句.
 *
 *  @param table     表名,多个用 ',' 分隔.
 *  @param where     一个字典,以字段或包含操作符的字段为key,以条件值为value.
 *  @param resetData 执行成功后是否重置查询操作
 *
 *  @return YES, 执行成功;NO, 执行失败.
 */
- (BOOL) YFDBRemove: (NSString *) table
              where: (NSDictionary *) where
          resetData: (BOOL) reset;
@end

@implementation YFDataBase

+ (instancetype) databaseWithPath: (NSString *)inPath
{
    YFDataBase * temp = [[self alloc] initWithPath: inPath];
    YFDBAutorelease(temp);
    return temp;
}

- (instancetype)initWithPath:(NSString *)inPath
{
    if (self = [super initWithPath: inPath]) {
        self.arSelect   = [NSMutableArray arrayWithCapacity: 42];
        self.arDistinct = NO;
        self.arFrom     = [NSMutableArray arrayWithCapacity: 42];
        self.arJoin     = [NSMutableArray arrayWithCapacity: 42];
        self.arWhere    = [NSMutableArray arrayWithCapacity: 42];
        self.arLike     = [NSMutableArray arrayWithCapacity: 42];
        self.arGroupby  = [NSMutableArray arrayWithCapacity: 42];
        self.arHaving   = [NSMutableArray arrayWithCapacity: 42];
        self.arKeys     = [NSMutableArray arrayWithCapacity: 42];
        self.arLimit    = NSUIntegerMax;
        self.arOffset   = 0;
        self.arOrderby  = [NSMutableArray arrayWithCapacity: 42];
        self.arSet      = [NSMutableDictionary dictionaryWithCapacity: 42];
        self.arSetBatch = [NSMutableArray arrayWithCapacity: 42];
        self.arWherein = [NSMutableArray arrayWithCapacity: 42];
        
        self.arCaching = NO;
        self.arCacheExists = [NSMutableArray arrayWithCapacity: 42];
        self.arCacheSelect = [NSMutableArray arrayWithCapacity: 42];
        self.arCacheFrom = [NSMutableArray arrayWithCapacity: 42];
        self.arCacheJoin = [NSMutableArray arrayWithCapacity: 42];
        self.arCacheWhere = [NSMutableArray arrayWithCapacity: 42];
        self.arCacheLike = [NSMutableArray arrayWithCapacity: 42];
        self.arCacheGroupby = [NSMutableArray arrayWithCapacity: 42];
        self.arCacheHaving = [NSMutableArray arrayWithCapacity: 42];
        self.arCacheOrderby = [NSMutableArray arrayWithCapacity: 42];
        self.arCacheSet = [NSMutableArray arrayWithCapacity: 42];
    }
    
    return self;
}

- (void)dealloc
{
    self.arSelect   = nil;
    self.arFrom     = nil;
    self.arJoin     = nil;
    self.arWhere    = nil;
    self.arLike     = nil;
    self.arGroupby  = nil;
    self.arHaving   = nil;
    self.arKeys     = nil;
    self.arOrderby  = nil;
    self.arSet      = nil;
    self.arSetBatch = nil;
    self.arWherein = nil;
    
    self.arCacheExists = nil;
    self.arCacheSelect = nil;
    self.arCacheFrom = nil;
    self.arCacheJoin = nil;
    self.arCacheWhere = nil;
    self.arCacheLike = nil;
    self.arCacheGroupby = nil;
    self.arCacheHaving = nil;
    self.arCacheOrderby = nil;
    self.arCacheSet = nil;
    
#if ! __has_feature(objc_arc)
    [super dealloc];
#endif
}

- (YFDataBase *)select: (NSString *) field
{
    NSArray * fields = [(NSString *)field componentsSeparatedByString:@","];
    
    [fields enumerateObjectsUsingBlock:^(NSString * val, NSUInteger idx, BOOL *stop) {
        val = [self YFDBTrim: val];

        if (YES != [val isEqualToString: @""]) {
            [self.arSelect      addObject: val];
            
            if (YES == self.arCaching) {
                [self.arCacheSelect     addObject: val];
                [self.arCacheExists     addObject: @"SELECT"];
            }
        }
        
    }];
    
    return self;
}

- (YFDataBase *) select
{
    return  [self select: @"*"];
}
- (YFDataBase *) selectMax: (NSString *) field
                     alias: (NSString *) alias
{
    return [self YFDBMaxMinAvgSum: field alias: alias type: @"MAX"];
}

- (YFDataBase *) selectMin: (NSString *) field
                     alias: (NSString *) alias
{
    return [self YFDBMaxMinAvgSum: field alias: alias type: @"MIN"];
}

- (YFDataBase *) selectAvg: (NSString *) field
                     alias: (NSString *) alias
{
    return [self YFDBMaxMinAvgSum: field alias: alias type: @"AVG"];
}

- (YFDataBase *) selectSum: (NSString *) field
                     alias: (NSString *) alias
{
    return [self YFDBMaxMinAvgSum: field alias: alias type: @"SUM"];
}

- (YFDataBase *) selectMax: (NSString *) field
{
    return [self selectMax: field alias: nil];
}

- (YFDataBase *) selectMin: (NSString *) field
{
    return [self selectMin: field alias: nil];
}

- (YFDataBase *) selectAvg: (NSString *) field
{
    return [self selectAvg: field alias: nil];
}

- (YFDataBase *) selectSum: (NSString *) field
{
    return [self selectSum: field alias: nil];
}

- (YFDataBase *) distinct
{
    self.arDistinct = YES;
    return self;
}

- (YFDataBase *) from: (NSString *) table
{
    if (nil == table) {
        return self;
    }
    
    if (NSNotFound == [table rangeOfString: @","].location) {
        table = [self YFDBTrim: table];
        
        [self.arFrom addObject: table];
        
        if (YES == self.arCaching) {
            [self.arCacheFrom addObject: table];
            [self.arCacheExists addObject: @"FROM"];
        }
        
        return self;
    }
    
    [[table componentsSeparatedByString:@","] enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL *stop) {
        obj = [self YFDBTrim: obj];
        
        [self.arFrom addObject: obj];
        
        if (YES == self.arCaching) {
            [self.arCacheFrom addObject: obj];
            [self.arCacheExists addObject: @"FROM"];
        }
    }];
    
    return self;
}

- (YFDataBase *) join: (NSString *) table
             condtion: (NSString *) condtion
                 type: (YFDBJoinType) joinType
{
    NSString * type = @"INNER";
    
    if (YFDBLeftOuterJoin == joinType) {
        type = @"LEFT OUTER";
    }
    
    if (nil == type) {
        type = @"";
    }
    
    // 拼接 JOIN 语句.
    NSString * join = [NSString stringWithFormat: @"%@ JOIN %@ ON %@", type, table, condtion];

    [self.arJoin addObject: join];
    
    if (YES == self.arCaching) {
        [self.arCacheJoin addObject: join];
        [self.arCacheExists addObject: @"JOIN"];
    }
    
    return self;
}

- (YFDataBase *) join: (NSString *) table
             condtion: (NSString *) condtion
{
    return [self join: table condtion: condtion type: YFDBInnerJoin];
}

- (YFDataBase *) where: (NSDictionary *)where
{
    return [self YFDBWhere: where type: @"AND"];
}

- (YFDataBase *) orWhere: (NSDictionary *) where
{
    return [self YFDBWhere: where type: @"OR"];   
}

- (YFDataBase *) where: (NSString *) field
              inValues: (NSArray *) values
{
    return [self YFDBWhere: field inValues: values not: NO type: @"AND"];
}

- (YFDataBase *) orWhere: (NSString *) field
                inValues: (NSArray *) values
{
    return [self YFDBWhere: field inValues: values not: NO type: @"OR"];
}

- (YFDataBase *) where: (NSString *) field
           notInValues: (NSArray *) values
{
    return [self YFDBWhere: field inValues: values not: YES type: @"AND"];
}

- (YFDataBase *) orWhere: (NSString *) field
             notInValues: (NSArray *) values
{
    return [self YFDBWhere: field inValues: values not: YES type: @"OR"];
}

- (YFDataBase *) like: (NSDictionary *) like
                 side: (YFDBLikeSide) side
{
    return [self YFDBLike: like type: @"AND" side: side not: NO];
}

- (YFDataBase *) notLike: (NSDictionary *) like
                    side: (YFDBLikeSide) side
{
    return [self YFDBLike: like type: @"AND" side: side not: YES];
}

- (YFDataBase *) orLike: (NSDictionary *) like
                   side: (YFDBLikeSide) side
{
    return [self YFDBLike: like type: @"OR" side: side not: NO];
}

- (YFDataBase *) orNotLike: (NSDictionary *) like
                      side: (YFDBLikeSide) side
{
    return [self YFDBLike: like type: @"OR" side: side not: YES];
}

- (YFDataBase *) like: (NSDictionary *) like
{
    return [self YFDBLike: like type: @"AND" side: YFDBLikeSideBoth not: NO];
}

- (YFDataBase *) notLike: (NSDictionary *) like
{
    return [self YFDBLike: like type: @"AND" side: YFDBLikeSideBoth not: YES];
}

- (YFDataBase *) orLike: (NSDictionary *) like
{
    return [self YFDBLike: like type: @"OR" side: YFDBLikeSideBoth not: NO];
}

- (YFDataBase *) orNotLike: (NSDictionary *) like
{
    return [self YFDBLike: like type: @"OR" side: YFDBLikeSideBoth not: YES];
}

- (YFDataBase *) groupBy: (NSString *) by
{
    [[by componentsSeparatedByString: @","] enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL *stop) {
        obj = [self YFDBTrim: obj];
        
        if (YES == [obj isEqualToString: @""]) {
            return;
        }
        
        [self.arGroupby addObject: obj];
        
        if (YES == self.arCaching) {
            [self.arCacheGroupby addObject: obj];
            [self.arCacheExists addObject: @"GROUPBY"];
        }
    }];
    
    return self;
}

- (YFDataBase *) having: (NSDictionary *) having
{
    return [self YFDBHaving: having type: @"AND"];
}

- (YFDataBase *) orHaving: (NSDictionary *) having
{
    return [self YFDBHaving: having type: @"OR"];
}

- (YFDataBase *) orderBy: (NSString *) orderBy
               direction: (YFDBOrderDirection) direction
{
    NSString * orderbyStatement = nil;

    if (YFDBOrderRandom == direction) {
        orderbyStatement = @" RANDOM()";
    }
    
    if (nil == orderbyStatement) {
        NSString * directionStr = @" ASC";
        if (YFDBOrderDesc == direction) {
            directionStr = @" DESC";
        }
        
        if (YFDBOrderDeault == direction) {
            directionStr = @"";
        }
        
        orderbyStatement = [NSString stringWithFormat: @"%@%@", orderBy, directionStr];
    }

    [self.arOrderby addObject: orderbyStatement];
    if (YES == self.arCaching) {
        [self.arCacheOrderby addObject: orderbyStatement];
        [self.arCacheExists addObject: @"ORDERBY"];
    }
    
    return self;
}

- (YFDataBase *) orderBy: (NSString *) orderBy
{
    return [self orderBy: orderBy direction: YFDBOrderDeault];
}

- (YFDataBase *) limit: (NSUInteger) limit
                offset: (NSUInteger) offset
{
    self.arLimit = limit;
    self.arOffset = offset;
    
    return self;
}

- (YFDataBase *) limit: (NSUInteger) limit
{
    return [self limit: limit offset: 0];
}

- (YFDataBase *) offset: (NSUInteger) offset
{
    self.arOffset = offset;
    return self;
}

- (YFDataBase *) set: (NSDictionary *) set
{
    [set enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [self.arSet setObject: [self YFDBEscape: obj] forKey: key];
    }];
    return self;
}

- (FMResultSet *) get: (NSString *) table
                limit: (NSUInteger) limit
               offset: (NSUInteger) offset
{
    if (nil != table && YES != [table isEqual: @""]) {
        [self from: table];
    }
    
    if (NSUIntegerMax != limit) {
        [self limit: limit offset: offset];
    }
    
    NSString * sql = [self YFDBCompileSelect];
    [self YFDBResetSelect];
    
    FMResultSet * result = [self executeQuery: sql];
    
    return result;
}

- (FMResultSet *) get: (NSString *) table
{
    return [self get: table limit: NSUIntegerMax offset:0];
}

- (FMResultSet *) get
{
    return [self get: nil limit: NSUIntegerMax offset:0];
}

- (NSUInteger) countAllResults: (NSString *) table
{
    if (nil != table ||
        YES != [table isEqualToString: @""]) {
        [self from: table];
    }
    
    NSString * sql = [self YFDBCompileSelect: @"SELECT COUNT(*) AS 'numrows'"];
    [self YFDBResetSelect];
    
    FMResultSet * result = [self executeQuery: sql];
    
    if (0 == result.columnCount) {
        return 0;
    }
    
    NSUInteger count = 0;
    while ([result next]) {
        count = [result unsignedLongLongIntForColumn: @"numrows"];
    };

    return count;
}

- (NSUInteger) countAllResults
{
    return [self countAllResults: nil];
}

- (FMResultSet *) get: (NSString *) table
                     where: (NSDictionary *) where
                     limit: (NSUInteger) limit
                    offset: (NSUInteger) offset
{
    if (nil != table &&
        YES != [table isEqualToString: @""]) {
        [self from: table];
    }
    
    if (nil != where) {
        [self where: where];
    }
    
    if (NSUIntegerMax != limit) {
        [self limit: limit offset: offset];
    }
    
    NSString * sql = [self YFDBCompileSelect];
    [self YFDBResetSelect];
    
    FMResultSet * result = [self executeQuery: sql];
    return result;
}

- (FMResultSet *) getWhere: (NSString *) table
                     where: (NSDictionary *) where
{
    return [self get: table where: where limit: NSUIntegerMax offset:0];
}

- (BOOL) insert: (NSString *) table
          batch: (NSArray *)  batch
{
    if (nil != batch) {
        [self YFDBSetInsertBatch: batch];
    }
    
    if (0 == self.arSetBatch.count) {
        return NO;
    }
    
    if (nil == table ||
        YES == [table isEqualToString: @""]) {
        if (0 == self.arFrom.count) {
            return NO;
        }
        
        table = self.arFrom[0];
    }
    
    // 批处理.
    NSUInteger maxInsert = 100; // 单次允许的最大插入数据的条数.
    for (NSUInteger i = 0, total = self.arSetBatch.count;  i < total;  i += maxInsert) {
        NSUInteger length = maxInsert;
        if (total < i + length) {
            length = total - i;
        }
        NSRange range = NSMakeRange( i, length);
        
        NSString * sql = [self YFDBInsert: table batch: self.arKeys values: [self.arSetBatch subarrayWithRange: range]];
        if (YES != [self executeUpdate: sql]) {
            return NO;
        }
    }
    
    [self YFDBResetWrite];
    
    return YES;
}

- (BOOL) insert: (NSString *) table
            set: (NSDictionary *) set
{
    if (nil != set) {
        [self set: set];
    }
    
    if (0 == self.arSet.count) {
        return NO;
    }
    
    if (nil == table ||
        YES == [table isEqualToString: @""]) {
        if (0 == self.arFrom.count) {
            return NO;
        }
        
        table = self.arFrom[0];
    }
    
    NSString * sql = [self YFDBInsert: table keys: [self.arSet allKeys] values: [self.arSet allValues]];
    [self YFDBResetWrite];
    
    BOOL result  = [self executeUpdate: sql];
    
    return result;
}

- (BOOL) insert: (NSString *) table
{
    return [self insert: table set: nil];
}

- (BOOL) replace: (NSString *) table
             set: (NSDictionary *) set
{
    if (nil != set) {
        [self set: set];
    }
    
    if (0 == self.arSet.count) {
        return NO;
    }
    
    if (nil == table ||
        YES == [table isEqualToString: @""]) {
        if (0 == self.arFrom.count) {
            return NO;
        }
        
        table = self.arFrom[0];
    }
    
    NSString * sql = [self YFDBReplace: table keys: [self.arSet allKeys] values: [self.arSet allValues]];
    [self YFDBResetWrite];
    
    BOOL result  = [self executeUpdate: sql];
    
    return result;
}

- (BOOL) replace: (NSString *) table
{
    return [self replace: table set: nil];
}

- (BOOL) replace: (NSString *) table
                  batch: (NSArray *)  batch
{
    if (nil != batch) {
        [self YFDBSetInsertBatch: batch];
    }
    
    if (0 == self.arSetBatch.count) {
        return NO;
    }
    
    if (nil == table ||
        YES == [table isEqualToString: @""]) {
        if (0 == self.arFrom.count) {
            return NO;
        }
        
        table = self.arFrom[0];
    }
    
    // 批处理.
    NSUInteger maxInsert = 100; // 单次允许的最大插入数据的条数.
    for (NSUInteger i = 0, total = self.arSetBatch.count;  i < total;  i += maxInsert) {
        NSUInteger length = maxInsert;
        if (total < i + length) {
            length = total - i;
        }
        NSRange range = NSMakeRange( i, length);
        
        NSString * sql = [self YFDBReplaceBatch: table keys: self.arKeys values: [self.arSetBatch subarrayWithRange: range]];
        if (YES != [self executeUpdate: sql]) {
            return NO;
        }
    }
    
    [self YFDBResetWrite];
    
    return YES;
}

- (BOOL) update: (NSString *) table
            set: (NSDictionary *) set
          where: (NSDictionary *) where
{
    // 将缓存内容与当前语句合并.
    [self YFDBMergeCache];
    
    if (nil != set) {
        [self set: set];
    }
    
    if (0 == self.arSet.count) {
        return NO;
    }
    
    if (nil == table ||
        YES == [table isEqualToString: @""]) {
        if (0 == self.arFrom.count) {
            return NO;
        }
        
        table = self.arFrom[0];
    }
    
    if (nil != where) {
        [self where: where];
    }
    
    NSString * sql = [self YFDBUpdate: table values: self.arSet where: self.arWhere];
    [self YFDBResetWrite];
    
    return [self executeUpdate: sql];
}

- (BOOL) update: (NSString *) table
            set: (NSDictionary *) set
{
    return [self update: table set: set where: nil];
}

- (BOOL) update: (NSString *) table
{
    return [self update: table set: nil where: nil];
}

- (BOOL) update
{
    return [self update: nil set: nil where: nil];
}

- (BOOL) update: (NSString *) table
               batch: (NSArray *) batch
               index: (NSString *) index
{
    // 将缓存内容与当前语句合并.
    [self YFDBMergeCache];
    
    if (nil != batch) {
        [self YFDBSetUpdateBatch: batch index: index];
    }
    
    if (0 == self.arSetBatch.count) {
        return NO;
    }
    
    if (nil == table ||
        YES == [table isEqualToString: @""]) {
        if (0 == self.arFrom.count) {
            return NO;
        }
        
        table = self.arFrom[0];
    }
    
    // 批处理.
    NSUInteger maxInsert = 100; // 单次允许的最大插入数据的条数.
    for (NSUInteger i = 0, total = self.arSetBatch.count;  i < total;  i += maxInsert) {
        NSUInteger length = maxInsert;
        if (total < i + length) {
            length = total - i;
        }
        NSRange range = NSMakeRange( i, length);
        
        NSString * sql = [self YFDBUpdate: table batch: [self.arSetBatch subarrayWithRange: range] index: index where: self.arWhere];
        
        if (YES != [self executeUpdate: sql]) {
            return NO;
        }
    }
    
    [self YFDBResetWrite];
    return YES;
}

- (BOOL) emptyTable: (NSString *) table
{
    if (nil == table ||
        YES == [table isEqualToString: @""]) {
        if (0 == self.arFrom.count) {
            return NO;
        }
        
        table = self.arFrom[0];
    }
    
    NSString * sql = [self YFDBDelete: table where: nil like: nil];
    [self YFDBResetWrite];
    
    return [self executeUpdate: sql];
}

- (BOOL) YFDBRemove: (NSString *) table
          where: (NSDictionary *) where
      resetData: (BOOL) reset
{
    if (NSNotFound != [table rangeOfString: @","].location) {
        NSArray * tables = [table componentsSeparatedByString:@","];
        for (NSString * obj in tables) {
            BOOL resetData = NO;
            if ([tables indexOfObject: obj] == tables.count - 1) {
                resetData = YES;
            }
            
            if (YES != [self YFDBRemove: [self YFDBTrim: obj] where: where resetData: resetData]) {
                return NO;
            }
        }
        return YES;
    }
    
    // 将缓存内容与当前语句合并.
    [self YFDBMergeCache];
    
    if (nil == table ||
        YES == [table isEqualToString: @""]) {
        if (0 == self.arFrom.count) {
            return NO;
        }
        
        table = self.arFrom[0];
    }
    
    if (nil != where) {
        [self where: where];
    }
    
    if (0 == self.arWhere.count &&
        0 == self.arWherein.count &&
        0 == self.arLike.count) {
        return NO;
    }
    
    NSString * sql = [self YFDBDelete: table where: self.arWhere like: self.arLike];
    
    if (YES == reset) {
        [self YFDBResetWrite];
    }
    
    return [self executeUpdate: sql];
}

- (BOOL) remove: (NSString *) table
          where: (NSDictionary *) where
{
    return [self YFDBRemove: table where: where resetData: YES];
}

- (BOOL) remove: (NSString *) table
{
    return [self YFDBRemove: table where: nil resetData: YES];
}

- (void) startCache
{
    self.arCaching = YES;
}

- (void) stopCache
{
    self.arCaching = NO;
}

- (void) flushCache
{
    NSDictionary * resetItems = @{@"arCacheSelect": [NSMutableArray arrayWithCapacity: 42],
                                  @"arCacheFrom": [NSMutableArray arrayWithCapacity: 42],
                                  @"arCacheJoin": [NSMutableArray arrayWithCapacity: 42],
                                  @"arCacheWhere": [NSMutableArray arrayWithCapacity: 42],
                                  @"arCacheLike": [NSMutableArray arrayWithCapacity: 42],
                                  @"arCacheGroupby": [NSMutableArray arrayWithCapacity: 42],
                                  @"arCacheHaving": [NSMutableArray arrayWithCapacity: 42],
                                  @"arCacheOrderby": [NSMutableArray arrayWithCapacity: 42],
                                  @"arCacheSet": [NSMutableArray arrayWithCapacity: 42],
                                  @"arCacheExists": [NSMutableArray arrayWithCapacity: 42]
                                  };
    [self YFDBResetRun: resetItems];
}
#pragma mark - 私有方法.
- (YFDataBase *) YFDBMaxMinAvgSum: (NSString *) field
                            alias: (NSString *) alias
                             type: (NSString *) type
{
    if (YES != [field isKindOfClass: [NSString class]] || YES == [field isEqualToString:@""]) {
        return nil;
    }
    
    type = [type uppercaseString];
    
    if (YES != [@[@"MAX", @"MIN", @"AVG", @"SUM"] containsObject: type]) {
        return nil;
    }
    
    if (nil == alias || [alias isEqualToString: @""]) {
        alias = [self YFDBTrim: field];
    }
    
    NSString * sql = [NSString stringWithFormat: @"%@(%@) AS %@", type, field, alias];
    
    [self.arSelect addObject: sql];
    
    if (YES == self.arCaching) {
        [self.arCacheSelect addObject: sql];
        [self.arCacheExists addObject: @"SELECT"];
    }
    
    return self;
}

- (NSString *) YFDBCreateAliasFromTable: (NSString *) item
{
    if (NSNotFound != [item rangeOfString:@"."].location) {
        return [[item componentsSeparatedByString: @"."] lastObject];
    }
    
    return item;
}

- (YFDataBase*) YFDBWhere: (NSDictionary *) where
                     type: (NSString *) type
{
    type = [type uppercaseString];
    
    [where enumerateKeysAndObjectsUsingBlock:^(NSString * key, id obj, BOOL *stop) {
        NSString * prefix = type;
        if (0 == self.arWhere.count && 0 == self.arCacheWhere.count) {
            prefix = @"";
        }
        
        if (YES != [self YFDBHasOperator: key]) {
            NSString * operator = @" =";
            
            if ([NSNull null] == obj) {
                operator = @" IS NULL";
            }
            
            key = [key stringByAppendingString: operator];
        }
        
        NSString * whereSegment = [NSString stringWithFormat: @"%@ %@ %@ ", prefix, key, [self YFDBEscape: obj]];
        
        [self.arWhere addObject: whereSegment];

        if (YES == self.arCaching) {
            [self.arCacheWhere addObject: whereSegment];
            [self.arCacheExists addObject: @"WHERE"];
        }
        
    }];
    
    return self;
}

- (BOOL) YFDBHasOperator: (NSString *) str
{
    str = [self YFDBTrim: str];
    
    NSRegularExpression * regExp = [NSRegularExpression regularExpressionWithPattern: @"(\\s|<|>|!|=|is null|is not null)" options: NSRegularExpressionCaseInsensitive error: nil];
    NSRange range = [regExp rangeOfFirstMatchInString: str options:0 range: NSMakeRange(0, str.length)];
    if (NSNotFound == range.location) {
        return NO;
    }
    
    return YES;
}

- (NSString *) YFDBTrim: (NSString *) str
{
    return [[NSString stringWithFormat:@"%@", str] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (YFDataBase *) YFDBWhere: (NSString *) field
                        inValues: (NSArray *) values
                       not: (BOOL) isNot
                      type: (NSString *) type
{
    NSMutableArray * valuesTemp = [NSMutableArray arrayWithCapacity: 42];
    [values enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        obj = [self YFDBEscape: [self YFDBTrim: obj]];
        [valuesTemp addObject: obj];
    }];
    NSString * value = [valuesTemp componentsJoinedByString: @","];
    
    NSString * not = @"NOT";
    if (YES != isNot) {
        not = @"";
    }
    
    NSString * prefix = type;
    if (0 == self.arWhere.count && 0 == self.arCacheWhere.count) {
        prefix = @"";
    }
    
    NSString * whereIn = [NSString stringWithFormat: @"%@ %@ %@ IN (%@)", prefix, field, not, value];
    
    [self.arWhere addObject: whereIn];
    
    if (YES == self.arCaching) {
        [self.arCacheWhere addObject: whereIn];
        [self.arCacheExists addObject: @"WHERE"];
    }
    
    return self;
}

- (YFDataBase *) YFDBWhereIn: (NSDictionary *) where
                         not: (BOOL) isNot
                        type: (NSString *) type
{
    NSString * field = [where allKeys][0];
    NSString * value = [where objectForKey: field];

    NSArray * values = [value componentsSeparatedByString:@","];
    NSMutableArray * valuesTemp = [NSMutableArray arrayWithCapacity: 42];
    [values enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        obj = [self YFDBEscape: [self YFDBTrim: obj]];
        [valuesTemp addObject: obj];
    }];
    value = [valuesTemp componentsJoinedByString: @","];
    
    NSString * not = @"NOT";
    if (YES != isNot) {
        not = @"";
    }
    
    NSString * prefix = type;
    if (0 == self.arWhere.count && 0 == self.arCacheWhere.count) {
        prefix = @"";
    }
    
    NSString * whereIn = [NSString stringWithFormat: @"%@ %@ %@ IN (%@)", prefix, field, not, value];
    
    [self.arWhere addObject: whereIn];
    
    if (YES == self.arCaching) {
        [self.arCacheWhere addObject: whereIn];
        [self.arCacheExists addObject: @"WHERE"];
    }
    
    return self;
}

- (NSString *) YFDBEscape: (NSString *) str
{
    if ([NSNull null] == (NSNull *) str) {
        return @"";
    }
    
    NSString * result = [NSString stringWithFormat: @"'%@'", str];
    
    if (YES ==[str isKindOfClass:[NSNumber class]]) {
        result = [NSString stringWithFormat: @"%@", str];
    }
    
    return result;
}

- (YFDataBase *) YFDBLike: (NSDictionary *) like
                     type: (NSString *) type
                     side: (YFDBLikeSide) side
                      not: (BOOL) isNot
{
    NSString * not = @"";
    if (YES == isNot) {
        not = @"NOT";
    }
    
    [like enumerateKeysAndObjectsUsingBlock:^(NSString * key, NSString * obj, BOOL *stop) {
        NSString * prefix = type;
        if (0 == self.arLike.count) {
            prefix = @"";
        }
        
        // 转义 LIKE 条件中的通配符.
        NSString * likeEscapeChr = @"!";
        NSRegularExpression * regExp = [NSRegularExpression regularExpressionWithPattern: [NSString stringWithFormat:@"(%%|_|%@)", likeEscapeChr] options:0 error: nil];
        obj = [regExp stringByReplacingMatchesInString: obj options:0 range: NSMakeRange(0, obj.length) withTemplate: [NSString stringWithFormat: @"%@$1", likeEscapeChr]];

        NSString * value = [NSString stringWithFormat:@"%%%@%%", obj];
        
        if (YFDBLikeSideNone == side) {
            value = obj;
        }
        
        if (YFDBLikeSideBefore == side) {
            value = [NSString stringWithFormat: @"%%%@", obj];
        }
        
        if (YFDBLikeSideAfter == side) {
            value = [NSString stringWithFormat: @"%@%%", obj];
        }
        
        NSString * likeStatement = [NSString stringWithFormat: @"%@ %@ %@ LIKE '%@' ESCAPE '%@' ", prefix, key, not, value, likeEscapeChr];
        
        [self.arLike addObject: likeStatement];
        if (YES == self.arCaching) {
            [self.arCacheLike addObject: likeStatement];
            [self.arCacheExists addObject: @"LIKE"];
        }
        
    }];
    
    return self;
}

- (YFDataBase *) YFDBHaving: (NSDictionary *) having
                       type: (NSString *) type
{
    [having enumerateKeysAndObjectsUsingBlock:^(NSString * key, NSString * obj, BOOL *stop) {
        NSString * prefix = type;
        if (0 == self.arHaving.count && 0 == self.arCacheHaving.count) {
            prefix = @"";
        }
        
        if (YES != [self YFDBHasOperator: key]) {
            key = [key stringByAppendingString: @" = "];
        }
        
        obj = [self YFDBEscape: obj];
        
        NSString * havingSegment = [NSString stringWithFormat: @"%@ %@ %@", prefix, key, obj];
        [self.arHaving addObject: havingSegment];
        if (YES == self.arCaching) {
            [self.arCacheHaving addObject: havingSegment];
            [self.arCacheExists addObject: @"HAVING"];
        }
        
    }];
    
    return self;
}

- (void) YFDBMergeCache
{
    if (0 == self.arCacheExists.count) {
        return;
    }
    
    [self.arCacheExists enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL *stop) {
        NSString * key = [@"ar" stringByAppendingString: [obj capitalizedString]];
        NSString * cacheKey = [@"arCache" stringByAppendingString: [obj capitalizedString]];
        
        NSMutableArray * value = [self valueForKey: key];
        NSMutableArray * cacheValue = [self valueForKey: cacheKey];
        
        if (0 == cacheValue.count) {
            return;
        }
        
        [cacheValue addObjectsFromArray: value];
        
        value = [NSMutableArray arrayWithCapacity: 42];
        [cacheValue enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if (YES != [value containsObject: obj]) {
                [value addObject: obj];
            }
        }];
        
        [self setValue: value forKey: key];
    }];
}

- (void) YFDBResetRun: (NSDictionary *) resetItems
{
    [resetItems enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [self setValue: obj forKey: key];
    }];
}

- (void) YFDBResetSelect
{
    NSDictionary * resetItems = @{@"arSelect": [NSMutableArray arrayWithCapacity: 42],
                                  @"arFrom": [NSMutableArray arrayWithCapacity: 42],
                                  @"arJoin": [NSMutableArray arrayWithCapacity: 42],
                                  @"arWhere": [NSMutableArray arrayWithCapacity: 42],
                                  @"arLike": [NSMutableArray arrayWithCapacity: 42],
                                  @"arGroupby": [NSMutableArray arrayWithCapacity: 42],
                                  @"arHaving": [NSMutableArray arrayWithCapacity: 42],
                                  @"arOrderby": [NSMutableArray arrayWithCapacity: 42],
                                  @"arWherein": [NSMutableArray arrayWithCapacity: 42],
                                  @"arDistinct": [NSNumber numberWithBool: NO],
                                  @"arLimit": [NSNumber numberWithUnsignedInteger:NSUIntegerMax],
                                  @"arOffset": [NSNumber numberWithUnsignedInteger:0]
                                  };
    
    return [self YFDBResetRun: resetItems];
}

- (NSString *) YFDBCompileSelect: (NSString *) selectOverride
{
    // 将缓存内容与当前语句合并.
    [self YFDBMergeCache];
    
    /* 生成查询的 SELECT 部分. */
    NSMutableString * selectClause = nil;
    
    if (nil != selectOverride &&
        YES != [selectOverride isEqualToString: @""]) {
        selectClause = [NSMutableString stringWithString: selectOverride];
    }
    
    if (nil == selectClause) {
        selectClause = [NSMutableString stringWithString:@"SELECT"];
        
        if (YES == self.arDistinct) {
            [selectClause appendString: @" DISTINCT"];
        }
        
        NSString * selectClauseSegments = nil;
        if (0 == self.arSelect.count) {
            selectClauseSegments = @"*";
        }
        
        if (nil == selectClauseSegments) {
            selectClauseSegments = [self.arSelect componentsJoinedByString: @", "];
        }
        
        [selectClause appendFormat: @" %@", selectClauseSegments];
    }
    
    /* 生成查询的 FROM 部分. */
    NSMutableString * fromClause = [NSMutableString stringWithCapacity: 42];
    if (0 != self.arFrom.count) {
        [fromClause appendFormat: @"\nFROM %@", [self YFDBFromTables: self.arFrom]];
    }
    
    /* 生成查询的 JOIN 部分. */
    NSMutableString * joinClause = [NSMutableString stringWithCapacity: 42];
    if (0 != self.arJoin.count) {
        [joinClause appendFormat:@"\n%@", [self.arJoin componentsJoinedByString: @"\n"]];
    }
    
    /* 生成查询的 WHERE 部分. */
    NSMutableString * whereClause = [NSMutableString stringWithCapacity: 42];
    if (0!= self.arWhere.count || 0 != self.arLike.count) {
        [whereClause appendFormat:@"\nWHERE %@", [self.arWhere componentsJoinedByString: @"\n"]];
    }
    
    /* 生成查询的 LIKE 部分. */
    NSMutableString * likeClause = [NSMutableString stringWithCapacity: 42];
    if (0 != self.arLike.count) {
        if (0 != self.arWhere.count) {
            [likeClause appendString: @"\nAND"];
        }
        
        [likeClause appendFormat:@" %@", [self.arLike componentsJoinedByString: @"\n"]];
    }
    
    /* 生成查询的 GROUP BY 部分. */
    NSMutableString * groupbyClause = [NSMutableString stringWithCapacity: 42];
    if (0 != self.arGroupby.count) {
        [groupbyClause appendFormat: @"\nGROUP BY %@", [self.arGroupby componentsJoinedByString:@", "]];
    }
    
    /* 生成查询的 HAVING 部分. */
    NSMutableString * havingClause = [NSMutableString stringWithCapacity: 42];
    if (0 != self.arHaving.count) {
        [havingClause appendFormat: @"\nHAVING %@", [self.arHaving componentsJoinedByString: @"\n"]];
    }
    
    /* 生成查询的 ORDER BY 部分. */
    NSMutableString * orderbyClause = [NSMutableString stringWithCapacity: 42];
    if (0 != self.arOrderby.count) {
        [orderbyClause appendFormat: @"\nORDER BY %@", [self.arOrderby componentsJoinedByString: @", "]];
    }
    
    /* 生成查询的 LIMIT 部分. */
    NSMutableString * limitClause = [NSMutableString stringWithCapacity: 42];
    if (NSUIntegerMax != self.arLimit) {
        [limitClause appendFormat: @"\nLIMIT %@, %@", [NSNumber numberWithUnsignedInteger: self.arOffset], [NSNumber numberWithUnsignedInteger: self.arLimit]];
    }
    
    /* 生成完整的 SQL 语句. */
    NSString * sql = [NSString stringWithFormat: @"%@%@%@%@%@%@%@%@%@", selectClause, fromClause, joinClause, whereClause, likeClause, groupbyClause, havingClause, orderbyClause, limitClause];
    return sql;
}
- (NSString *) YFDBCompileSelect
{
    return [self YFDBCompileSelect: nil];
}

- (NSString *) YFDBFromTables: (NSArray *) tables
{
    if (nil == tables ||
        0 == tables.count) {
        return nil;
    }
    
    if (1 == tables.count) {
        return [NSString stringWithFormat: @"%@", [tables componentsJoinedByString:@", "]];
    }
    
    return [NSString stringWithFormat: @"(%@)", [tables componentsJoinedByString:@", "]];
}

- (NSString *) YFDBInsert: (NSString *) table
                     keys: (NSArray *) keys
                   values: (NSArray *) values
{
    NSString * insertClause = [NSString stringWithFormat: @"INSERT INTO %@ (%@) VALUES (%@)", table, [keys componentsJoinedByString: @", "], [values componentsJoinedByString: @", "]];
    return insertClause;
}

- (NSString *) YFDBInsert: (NSString *) table
                          batch: (NSArray *) keys
                        values: (NSArray *) values
{
    NSString * insertClause = [NSString stringWithFormat: @"INSERT INTO %@ (%@) VALUES %@", table, [keys componentsJoinedByString: @", "], [values componentsJoinedByString: @", "]];
    return insertClause;
}

- (void) YFDBResetWrite
{
    NSDictionary * resetItems = @{@"arSet": [NSMutableDictionary dictionaryWithCapacity: 42],
                                  @"arFrom": [NSMutableArray arrayWithCapacity: 42],
                                  @"arWhere": [NSMutableArray arrayWithCapacity: 42],
                                  @"arLike": [NSMutableArray arrayWithCapacity: 42],
                                  @"arOrderby": [NSMutableArray arrayWithCapacity: 42],
                                  @"arKeys": [NSMutableArray arrayWithCapacity: 42],
                                  @"arLimit": [NSNumber numberWithUnsignedInteger: NSUIntegerMax]
                                  };
    
    return [self YFDBResetRun: resetItems];
}

- (YFDataBase *) YFDBSetInsertBatch: (NSArray *) batch
{
    if (nil == batch) {
        return self;
    }
    
    NSArray * keys = [[(NSDictionary *)batch[0] allKeys] sortedArrayUsingComparator:^NSComparisonResult(NSString * obj1, NSString * obj2) {
        return [obj1 compare: obj2];
    }];
    
    for (NSDictionary * dict in batch) {
        NSArray * keysTemp = [[dict allKeys] sortedArrayUsingComparator:^NSComparisonResult(NSString * obj1, NSString * obj2) {
            return [obj1 compare: obj2];
        }];
        
        if (YES != [keys isEqualToArray: keysTemp]) {
            return self;
        }
        
        NSMutableArray * clean = [NSMutableArray arrayWithCapacity: 42];
        [keys enumerateObjectsUsingBlock:^(id key, NSUInteger idx, BOOL *stop) {
            [clean addObject: [self YFDBEscape: [dict objectForKey: key]]];
        }];
        
        [self.arSetBatch addObject: [NSString stringWithFormat:@"(%@)", [clean componentsJoinedByString: @", "]]];
    }
    
    [keys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self.arKeys addObject: obj];
    }];
    
    return self;
}

- (NSString *) YFDBReplace: (NSString *) table
                      keys: (NSArray *) keys
                    values: (NSArray *) values
{
    NSString * replaceClause = [NSString stringWithFormat: @"REPLACE INTO %@ (%@) VALUES (%@)", table, [keys componentsJoinedByString: @", "], [values componentsJoinedByString: @", "]];
    return replaceClause;
}

- (NSString *) YFDBReplaceBatch: (NSString *) table
                           keys: (NSArray *) keys
                         values: (NSArray *) values
{
    NSString * replaceClause = [NSString stringWithFormat: @"REPLACE INTO %@ (%@) VALUES %@", table, [keys componentsJoinedByString: @", "], [values componentsJoinedByString: @", "]];
    return replaceClause;
}

- (NSString *) YFDBUpdate: (NSString *) table
                   values: (NSDictionary *) values
                    where: (NSArray *) where
{
    if (nil == table ||
        YES == [table isEqualToString: @""]) {
        return nil;
    }
    
    NSMutableArray * valstr = [NSMutableArray arrayWithCapacity: 42];
    [values enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [valstr addObject: [NSString stringWithFormat: @"%@ = %@", key, obj]];
    }];
    
    NSMutableString * updateClause = [NSMutableString stringWithFormat: @"UPDATE %@ SET %@", table, [valstr componentsJoinedByString: @", "]];
    
    NSMutableString * whereClause = [NSMutableString stringWithCapacity:42];
    if (nil != where &&
        0 != where.count) {
        [whereClause appendFormat: @"WHERE %@", [where componentsJoinedByString: @" "]];
    }
    
    [updateClause appendFormat: @" %@", whereClause];
    
    return updateClause;
}

- (YFDataBase *) YFDBSetUpdateBatch: (NSArray *) batch
                              index: (NSString *) index
{
    if (nil == batch && YES != [batch isKindOfClass: [NSArray class]]) {
        return self;
    }
    
    for (NSDictionary * data in batch) {
        if (YES != [[data allKeys] containsObject: index]) {
            return self;
        }

        NSMutableDictionary * clean = [NSMutableDictionary dictionaryWithCapacity: 42];
        [data enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [clean setObject: [self YFDBEscape: obj] forKey: key];
        }];
        
        [self.arSetBatch addObject: clean];
    }
    
    return self;
}

- (NSString *) YFDBUpdate: (NSString *) table
                         batch: (NSArray*) sets
                        index: (NSString *) index
                        where: (NSArray *) where
{
    NSMutableDictionary * setSegmentsDict = [NSMutableDictionary dictionaryWithCapacity: 42];
    NSMutableArray * inSegmentsArray = [NSMutableArray arrayWithCapacity: 42];
    [sets enumerateObjectsUsingBlock:^(NSDictionary * set, NSUInteger idx, BOOL *stop) {
        [set enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if (YES == [index isEqualToString: key]) {
                [inSegmentsArray addObject: obj];
                return;
            }
            
            if (nil == [setSegmentsDict objectForKey: key]) {
                [setSegmentsDict setObject: [NSMutableString stringWithCapacity: 42] forKey: key];
            }
            
            [[setSegmentsDict objectForKey: key] appendFormat: @"\nWHEN %@ = %@ THEN %@", index, [set objectForKey: index], obj];
            
        }];
    }];
    
    NSMutableArray * setSegmentsArray = [NSMutableArray arrayWithCapacity: 42];
    [setSegmentsDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [setSegmentsArray addObject: [NSString stringWithFormat: @"%@ = CASE %@\nELSE %@ END", key, obj, key]];
    }];
    
    NSMutableString * setClause = [NSMutableString stringWithFormat: @"SET %@", [setSegmentsArray componentsJoinedByString: @",\n"]];
    
    NSString * inClause = [NSString stringWithFormat: @"%@ IN (%@)", index, [inSegmentsArray componentsJoinedByString: @", "]];
    
    NSString * whereClause = [NSString stringWithFormat: @"WHERE %@", inClause];
    if (nil != where &&
        0 != where.count) {
        whereClause = [NSString stringWithFormat: @"WHERE %@ %@", [where componentsJoinedByString: @" "], inClause];
    }
    
    NSString * updateClause = [NSString stringWithFormat: @"UPDATE %@\n%@\n%@", table, setClause, whereClause];
    
    return updateClause;
}

- (NSString *) YFDBDelete: (NSString *) table
                    where: (NSArray *) where
                     like: (NSArray *) like
{
    NSMutableString * conditions = [NSMutableString stringWithCapacity: 42];
    
    if (0 != where.count ||
        0 != like.count) {
        [conditions appendFormat: @"\nWHERE %@", [self.arWhere componentsJoinedByString: @"\n"]];
        
        if (0 != where.count && 0 != like.count) {
            [conditions appendString: @" AND "];
        }
        [conditions appendFormat: @"%@", [like componentsJoinedByString: @"\n"]];
    }
    
    
    NSString * deleteClause = [NSString stringWithFormat: @"DELETE FROM %@ %@", table, conditions];
    return deleteClause;
}
@end
