//
//  YFDataBase.m
//  FMDB-ActiveRecord
//
//  Created by   颜风 on 14-6-21.
//  Copyright (c) 2014年 Shadow. All rights reserved.
//

#import "YFDataBase.h"

@interface YFDataBase ()

// !!!:提供对多线程的支持吗?block可以很好地支持多线程的!FMDB支持多线程吗?
// !!!:优化方向,优化注释.
// !!!:使用复杂的SQL逻辑测试各个方法.
#pragma mark - 私有属性.
// !!!:给变量加一些注释.
// !!!:此处给属性添加"ar"前缀的目的是为了与方法区分(OC中不得不遵守的原因).有没有更好的策略.比如放到一个字典中,直接以"select"等为键,已一个可变数组为值.
// !!!:可以直接存储字符串.将子句本身声明为属性.
@property (retain, nonatomic) NSMutableArray * arSelect;
@property (assign, nonatomic)           BOOL   arDistinct;
@property (retain, nonatomic) NSMutableArray * arFrom;
@property (retain, nonatomic) NSMutableArray * arJoin;
@property (retain, nonatomic) NSMutableArray * arWhere;
@property (retain, nonatomic) NSMutableArray * arLike;
@property (retain, nonatomic) NSMutableArray * arGroupby;
@property (retain, nonatomic) NSMutableArray * arHaving;
@property (retain, nonatomic) NSMutableArray * arKeys;
// !!!:使用有符号性或许更合适,要不然无法分辨.又或者使用最大正整数常量初始化.
@property (assign, nonatomic)     NSUInteger   arLimit;
@property (assign, nonatomic)     NSUInteger   arOffset;
@property (assign, nonatomic)     NSString*    arOrder; //!!!:似乎没有存在价值.
@property (retain, nonatomic) NSMutableArray * arOrderby;
@property (retain, nonatomic) NSMutableDictionary * arSet;
@property (retain, nonatomic) NSMutableArray * arSetBatch; //!!!:临时添加的属性,因为批量插入时,必须用arset数组.暂时替代.
@property (retain, nonatomic) NSMutableArray * arWherein;
@property (retain, nonatomic) NSMutableArray * arStoreArray; //!!!:似乎没有存在价值.

// Active Record 缓存属性.
@property (assign, nonatomic)           BOOL   arCaching;
@property (retain, nonatomic) NSMutableArray * arCacheExists;
@property (retain, nonatomic) NSMutableArray * arCacheSelect;
@property (retain, nonatomic) NSMutableArray * arCacheFrom;
@property (retain, nonatomic) NSMutableArray * arCacheJoin;
@property (retain, nonatomic) NSMutableArray * arCacheWhere;
@property (retain, nonatomic) NSMutableArray * arCacheLike;
@property (retain, nonatomic) NSMutableArray * arCacheGroupby;
@property (retain, nonatomic) NSMutableArray * arCacheHaving;
@property (retain, nonatomic) NSMutableArray * arCacheOrderby;
@property (retain, nonatomic) NSMutableArray * arCacheSet;

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
 *  供其他方法调用:whereIn: whereInOr: whereNotIn: whereNotInOr:
 *
 *  @param where 字典,以字段为key,以可选的值为value.多个值,请用','符号分隔.
 *  @param isNot YES,是 NOT IN查询;NO,是 IN查询.
 *  @param type  类型.
 *
 *  @return 实例对象自身.
 */
- (YFDataBase *) YFDBWhereIn: (NSDictionary *) where
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
// !!!:建议把type和side参数声明为枚举.!
// !!!:建议,预定义参数使用大写形式.如"BEFORE"
- (YFDataBase *) YFDBLike: (NSDictionary *) like
                     type: (NSString *) type
                     side: (NSString *) side
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

//!!!:方法有点鸡肋,直接存储from子句不就行了.没有必要的转换:字符串-->数组-->字符串.而且,和IN方法的逻辑冲突!
// !!!: 仅被调用一次,没必要写成方法.
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
 *  重置 ACTIVE RECORD "写"的值.
 */
- (void) YFDBResetWrite;

/**
 *  支持设置用于批量插入的键值对.
 *
 *  @param batch 数组,存储用于一个或多个用于插入数据的字典.
 *
 *  @return 实例对象自身.
 */
// !!!:如此频繁地返回实例对象自身,真的合适吗?
- (YFDataBase *) YFDBSetInsertBatch: (NSArray *) batch;

@end

@implementation YFDataBase

+ (instancetype) databaseWithPath: (NSString *)inPath
{
    return [[[self alloc] initWithPath: inPath] autorelease];
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
        self.arOrder    = @"";
        self.arOrderby  = [NSMutableArray arrayWithCapacity: 42];
        self.arSet      = [NSMutableDictionary dictionaryWithCapacity: 42];
        self.arSetBatch = [NSMutableArray arrayWithCapacity: 42];
        self.arWherein = [NSMutableArray arrayWithCapacity: 42];
        self.arStoreArray = [NSMutableArray arrayWithCapacity: 42];
        
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
    self.arOrder    = nil;
    self.arOrderby  = nil;
    self.arSet      = nil;
    self.arSetBatch = nil;
    self.arWherein = nil;
    self.arStoreArray = nil;
    
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
    
    [super dealloc];
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
                [self.arCacheExists     addObject: @"select"];//!!!: 为什么不用大写?
            }
        }
        
    }];
    
    return self;
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

- (YFDataBase *) distinct: (BOOL) distinct
{
    self.arDistinct = distinct;
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
            [self.arCacheExists addObject: @"from"];
        }
        
        return self;
    }
    
    [[table componentsSeparatedByString:@","] enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL *stop) {
        obj = [self YFDBTrim: obj];
        
        [self.arFrom addObject: obj];
        
        if (YES == self.arCaching) {
            [self.arCacheFrom addObject: obj];
            [self.arCacheExists addObject: @"from"];
        }
    }];
    
    return self;
}

- (YFDataBase *) join: (NSString *) table
             condtion: (NSString *) condtion
                 type: (NSString *) type
{
    if (nil == type) {
        type = @"";
    }
    
    if (YES != [type isEqualToString: @""]) {
        type = [type uppercaseString];
        
        // ???:以下几种,sqlite都支持吗?
        if (YES != [@[@"LEFT", @"RIGHT", @"OUTER", @"INNER", @"LEFT OUTER", @"RIGHT OUTER"] containsObject: type]) {
            type = @"";
        }
        
    }
    
    // 拼接 JOIN 语句.
    NSString * join = [NSString stringWithFormat: @"%@ JOIN %@ ON %@", type, table, condtion];

    [self.arJoin addObject: join];
    
    if (YES == self.arCaching) {
        [self.arCacheJoin addObject: join];
        [self.arCacheExists addObject: @"join"];
    }
    
    return self;
}

- (YFDataBase *) join: (NSString *) table
             condtion: (NSString *) condtion
{
    return [self join: table condtion: condtion type: nil];
}

- (YFDataBase *) where: (NSDictionary *)where
{
    return [self YFDBWhere: where type: @"AND"];
}

- (YFDataBase *) orWhere: (NSDictionary *) where
{
    return [self YFDBWhere: where type: @"OR"];   
}

- (YFDataBase *) whereIn: (NSDictionary *) where
{
    return [self YFDBWhereIn: where not: NO type: @"AND"];
}

- (YFDataBase *) orWhereIn: (NSDictionary *) where
{
    return [self YFDBWhereIn: where not: NO type: @"OR"];
}

- (YFDataBase *) whereNotIn: (NSDictionary *) where
{
    return [self YFDBWhereIn: where not: YES type: @"AND"];
}

- (YFDataBase *) OrWhereNotIn: (NSDictionary *) where
{
    return [self YFDBWhereIn: where not: YES type: @"OR"];
}

- (YFDataBase *) like: (NSDictionary *) like
                 side: (NSString *) side
{
    return [self YFDBLike: like type: @"AND" side: side not: NO];
}

- (YFDataBase *) notLike: (NSDictionary *) like
                    side: (NSString *) side
{
    return [self YFDBLike: like type: @"AND" side: side not: YES];
}

- (YFDataBase *) OrLike: (NSDictionary *) like
                   side: (NSString *) side
{
    return [self YFDBLike: like type: @"OR" side: side not: NO];
}

- (YFDataBase *) OrNotLike: (NSDictionary *) like
                      side: (NSString *) side
{
    return [self YFDBLike: like type: @"OR" side: side not: YES];
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
            [self.arCacheExists addObject: @"groupby"];
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
               direction: (NSString *) direction
{
    NSString * orderbyStatement = nil;
    
    direction = [self YFDBTrim:[direction uppercaseString]] ;
    if (YES == [direction isEqualToString: @"RANDOM"]) {
        orderbyStatement = @"RANDOM()";
    }
    
    if (nil == orderbyStatement) {
        if (YES ==  [[self YFDBTrim: direction] isEqualToString: @""]  &&
            YES != [@[@"ASC", @"DESC"] containsObject: direction]) { //!!!: 此处将允许direction为@"",但是如此得到的结果,将依赖于数据库的默认排序顺序!
            // !!!:移除self的arOrder或者dierection变量声明为枚举,才可以彻底解决此混乱!
            direction = @"ASC";
        }
        
        orderbyStatement = [NSString stringWithFormat: @"%@ %@", orderBy, direction];
    }
    
    [self.arOrderby addObject: orderbyStatement];
    if (YES == self.arCaching) {
        [self.arCacheOrderby addObject: orderbyStatement];
        [self.arCacheExists addObject: @"orderby"];
    }
    
    return self;
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

- (FMResultSet *) getWhere: (NSString *) table
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
    return [self getWhere: table where: where limit: NSUIntegerMax offset:0];
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
#pragma mark - 私有方法.
- (YFDataBase *) YFDBMaxMinAvgSum: (NSString *) field
                            alias: (NSString *) alias
                             type: (NSString *) type
{
    if (YES != [field isKindOfClass: [NSString class]] || YES == [field isEqualToString:@""]) {
        // !!!:无法匹配语法 或许可以直接返回nil.
//        $this->display_error('db_invalid_query');
    }
    
    type = [type uppercaseString];
    
    if (YES != [@[@"MAX", @"MIN", @"AVG", @"SUM"] containsObject: type]) {
        // !!!:无法匹配语法
//        show_error('Invalid function type: '.$type);
    }
    
    if (nil == alias || [alias isEqualToString: @""]) {
        alias = [self YFDBTrim: field];
    }
    
    NSString * sql = [NSString stringWithFormat: @"%@(%@) AS %@", type, field, alias];
    
    [self.arSelect addObject: sql];
    
    if (YES == self.arCaching) {
        [self.arCacheSelect addObject: sql];
        [self.arCacheExists addObject: @"select"];
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
        // !!!:是否有必要加上限制:0 == self.arCacheWhere.count.分析下缓存机制,再作判断.
        // !!!:此处原文是:			$prefix = (count($this->ar_where) == 0 AND count($this->ar_cache_where) == 0) ? '' : $type;
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
            [self.arCacheExists addObject: @"where"];
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
    return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

// !!!:个人感觉,应该让此方法,自动支持批操作!它是字典,有先天条件.!php很可能是受制于自身的逻辑,未能实现自动对批操作的支持.
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
    
    // !!!:是否有必要加上限制:0 == self.arCacheWhere.count.分析下缓存机制,再作判断.
    // !!!:此处原文是:$prefix = (count($this->ar_where) == 0) ? '' : $type;
    NSString * prefix = type;
    if (0 == self.arWhere.count && 0 == self.arCacheWhere.count) {
        prefix = @"";
    }
    
    NSString * whereIn = [NSString stringWithFormat: @"%@ %@ %@ IN (%@)", prefix, field, not, value];
    
    [self.arWhere addObject: whereIn];
    
    if (YES == self.arCaching) {
        [self.arCacheWhere addObject: whereIn];
        [self.arCacheExists addObject: @"where"];
    }
    
    return self;
}

- (NSString *) YFDBEscape: (NSString *) str
{
    if ([NSNull null] == (NSNull *) str) {
        return @"";
    }
    
    return [NSString stringWithFormat: @"'%@'", str];
}

- (YFDataBase *) YFDBLike: (NSDictionary *) like
                     type: (NSString *) type
                     side: (NSString *) side
                      not: (BOOL) isNot
{
    NSString * not = @"";
    if (YES == isNot) {
        not = @"NOT";
    }
    
    [like enumerateKeysAndObjectsUsingBlock:^(NSString * key, NSString * obj, BOOL *stop) {
        NSString * prefix = type;
        // ???:是否有必要考虑缓存like字段不为空的情况.暂时先考虑.
        if (0 == self.arLike.count && 0 == self.arCacheLike.count) {
            prefix = @"";
        }
        
        // 转义 LIKE 条件中的通配符.
        NSString * likeEscapeChr = @"!";
        NSRegularExpression * regExp = [NSRegularExpression regularExpressionWithPattern: [NSString stringWithFormat:@"(%%|_|%@)", likeEscapeChr] options:0 error: nil];
        obj = [regExp stringByReplacingMatchesInString: obj options:0 range: NSMakeRange(0, obj.length) withTemplate: [NSString stringWithFormat: @"%@$1", likeEscapeChr]];

        NSString * value = [NSString stringWithFormat:@"%%%@%%", obj];
        
        if ([side isEqualToString: @"none"]) {
            value = obj;
        }
        
        if ([side isEqualToString: @"before"]) {
            value = [NSString stringWithFormat: @"%%%@", obj];
        }
        
        if ([side isEqualToString: @"after"]) {
            value = [NSString stringWithFormat: @"%@%%", obj];
        }
        
        NSString * likeStatement = [NSString stringWithFormat: @"%@ %@ %@ LIKE '%@' ESCAPE '%@' ", prefix, key, not, value, likeEscapeChr];
        
        [self.arLike addObject: likeStatement];
        if (YES == self.arCaching) {
            [self.arCacheLike addObject: likeStatement];
            [self.arCacheExists addObject: @"like"];
        }
        
    }];
    
    return self;
}

- (YFDataBase *) YFDBHaving: (NSDictionary *) having
                       type: (NSString *) type
{
    [having enumerateKeysAndObjectsUsingBlock:^(NSString * key, NSString * obj, BOOL *stop) {
        NSString * prefix = type;
        // !!!:有无必要考虑缓存的self.arCacheHaving.count?
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
            [self.arCacheExists addObject: @"having"];
        }
        
    }];
    
    return self;
}

- (void) YFDBMergeCache
{
    if (0 == self.arCacheExists.count) {
        return;
    }
    
    // !!!:如果属性与方法的区分策略变更,此处的逻辑也要相应调整.
    [self.arCacheExists enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL *stop) {
        // !!!: 可以把类似的逻辑,having位置的值改为大写了!           [self.arCacheExists addObject: @"having"];
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
    // !!!:缓存的操作,在何处"重置"?不需要重置?
}

- (void) YFDBResetRun: (NSDictionary *) resetItems
{
    [resetItems enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (YES != [self.arStoreArray containsObject: key]) {
            [self setValue: obj forKey: key];
        }
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
                                  @"arLimit": [NSNumber numberWithUnsignedInteger:0],
                                  @"arOffset": [NSNumber numberWithUnsignedInteger:0],
                                  @"arOrder": @""
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
        // !!!: 为什么要加'\n'换行,为了美观吗?
        [fromClause appendFormat: @"\nFROM %@", [self YFDBFromTables: self.arFrom]];
    }
    
    /* 生成查询的 JOIN 部分. */
    NSMutableString * joinClause = [NSMutableString stringWithCapacity: 42];
    if (0 != self.arJoin) {
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
        // !!!: arOrderby不是已经有说明顺序的字段了嘛?为什么又用self.arOrder?
        [orderbyClause appendFormat: @"\nORDER BY %@ %@", [self.arOrderby componentsJoinedByString: @", "], [self.arOrder uppercaseString]];
    }
    
    /* 生成查询的 LIMIT 部分. */
    NSMutableString * limitClause = [NSMutableString stringWithCapacity: 42];
    if (NSUIntegerMax != self.arLimit) {
        [limitClause appendFormat: @"\nLIMIT %@, %@", [NSNumber numberWithUnsignedInteger: self.arOffset], [NSNumber numberWithUnsignedInteger: self.arLimit]];
    }
    
    /* 生成完整的 SQL 语句. */
    // !!!: 有一个BUG:生成的语句,\n可能过多!
    NSString * sql = [NSString stringWithFormat: @"%@%@%@%@%@%@%@%@%@", selectClause, fromClause, joinClause, whereClause, likeClause, groupbyClause, havingClause, orderbyClause, limitClause];
    return sql;
}
- (NSString *) YFDBCompileSelect
{
    return [self YFDBCompileSelect: nil];
}

- (NSString *) YFDBFromTables: (NSArray *) tables
{
    return [NSString stringWithFormat: @"(%@)", [tables componentsJoinedByString:@", "]];
}

- (NSString *) YFDBInsert: (NSString *) table
                     keys: (NSArray *) keys
                   values: (NSArray *) values
{
    NSString * insertClause = [NSString stringWithFormat: @"INSERT INTO %@ (%@) VALUES (%@)", table, [keys componentsJoinedByString: @", "], [values componentsJoinedByString: @", "]];
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
                                  @"arLimit": [NSNumber numberWithUnsignedInteger: NSUIntegerMax],
                                  @"arOrder": @""
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
            // ???:此处为何插入一个空数组.
            [self.arSetBatch addObject: @[]];
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

@end
