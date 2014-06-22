//
//  YFDataBase.m
//  FMDB-ActiveRecord
//
//  Created by   颜风 on 14-6-21.
//  Copyright (c) 2014年 Shadow. All rights reserved.
//

// !!!:代码中如此频繁地使用便利构造器,真的好吗?
#import "YFDataBase.h"

@interface YFDataBase ()

#pragma mark - 私有属性.
@property (retain, nonatomic) NSMutableArray * arSelect;
@property (assign, nonatomic)           BOOL   arDistinct;
@property (retain, nonatomic) NSMutableArray * arFrom;
@property (retain, nonatomic) NSMutableArray * arJoin;
@property (retain, nonatomic) NSMutableArray * arWhere;
@property (retain, nonatomic) NSMutableArray * arLike;
@property (retain, nonatomic) NSMutableArray * arGroupby;
@property (retain, nonatomic) NSMutableArray * arHaving;
@property (retain, nonatomic) NSMutableArray * arKeys;
@property (assign, nonatomic)           BOOL   arLimit;
@property (assign, nonatomic)           BOOL   arOffset;
@property (assign, nonatomic)           BOOL   arOrder;
@property (retain, nonatomic) NSMutableArray * arOrderby;
@property (retain, nonatomic) NSMutableArray * arSet;
@property (retain, nonatomic) NSMutableArray * arWherein;
@property (retain, nonatomic) NSMutableArray * arAliasedTables;
@property (retain, nonatomic) NSMutableArray * arStoreArray;

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

@property (retain, nonatomic) NSMutableArray * arNoEscape;
@property (retain, nonatomic) NSMutableArray * arCacheNoEscape;

// !!!:我不确定它写在这里是否合适,是手动配置,还是自动初始化.暂时采取后一种策略!
@property (copy, nonatomic) NSString * escapeChar;
@property (retain, nonatomic) NSMutableArray * reservedIdentifiers;

#pragma mark - 私有方法.
/**
 *  为下面四个公开方法服务.
 *
 *  selectMax:alias:
 *  selectMin:alias:
 *  selectAvg:alias:
 *  selectSum:alias:
 *
 *  @param select 字段.
 *  @param alias  别名.
 *  @param type   类型.
 *
 *  @return 实例对象自身.
 */
- (YFDataBase *) YFDBMaxMinAvgSum: (NSString *) select
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

//!!!:暂先不写注释.有些棘手!
- (id) YFDBProtectIdentifiers: (id)   item
                 prefixSingle: (BOOL) perfixSingle
           protectIdentifiers: (BOOL) protectIdentifiers
                  fieldExists: (BOOL) fieldExists;

/**
 *  转义SQL标识符.
 *
 *  这个方法转义列名和表名.
 *
 *  @param item 要转义的内容.
 *
 *  @return 转义后的内容.
 */
- (NSString *) YFDBEscapeIdentifiers: (NSString *) item;

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
        self.arLike     = [NSMutableArray arrayWithCapacity: 42];
        self.arGroupby  = [NSMutableArray arrayWithCapacity: 42];
        self.arHaving   = [NSMutableArray arrayWithCapacity: 42];
        self.arKeys     = [NSMutableArray arrayWithCapacity: 42];
        self.arLimit    = NO;
        self.arOffset   = NO;
        self.arOrder    = NO;
        self.arOrderby  = [NSMutableArray arrayWithCapacity: 42];
        self.arSet      = [NSMutableArray arrayWithCapacity: 42];
        self.arWherein  = [NSMutableArray arrayWithCapacity: 42];
        self.arAliasedTables = [NSMutableArray arrayWithCapacity: 42];
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
        
        self.arNoEscape = [NSMutableArray arrayWithCapacity: 42];
        self.arCacheNoEscape = [NSMutableArray arrayWithCapacity: 42];

        self.escapeChar = @"";
        
        self.reservedIdentifiers = [NSMutableArray arrayWithCapacity: 42];
    }
    
    return self;
}

- (void)dealloc
{
    self.arSelect   = nil;
    self.arFrom     = nil;
    self.arJoin     = nil;
    self.arLike     = nil;
    self.arGroupby  = nil;
    self.arHaving   = nil;
    self.arKeys     = nil;
    self.arOrderby  = nil;
    self.arSet      = nil;
    self.arWherein  = nil;
    self.arAliasedTables = nil;
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
    
    self.arNoEscape = nil;
    self.arCacheNoEscape = nil;
    
    self.escapeChar = nil;
    
    self.reservedIdentifiers = nil;
    
    [super dealloc];
}

- (YFDataBase *)select: (id)    select
                escape: (BOOL)  escape
{
    if (nil == select) {
        select = @"*";
    }
    
    if ([select isKindOfClass: [NSString class]]) {
        select = [(NSString *)select componentsSeparatedByString:@","];
    }
    
    [select enumerateObjectsUsingBlock:^(NSString * val, NSUInteger idx, BOOL *stop) {
        val = [val stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];

        if (NO == [val isEqualToString: @""]) {
            [self.arSelect      addObject: val];
            [self.arNoEscape    addObject: [NSNumber numberWithBool: escape]];
            
            if (YES == self.arCaching) {
                [self.arCacheSelect     addObject: val];
                [self.arCacheExists     addObject: @"select"];
                [self.arCacheNoEscape   addObject: [NSNumber numberWithBool: escape]];
            }
        }
        
    }];
    
    return self;
}

- (YFDataBase *) selectMax: (NSString *) select
                     alias: (NSString *) alias
{
    return [self YFDBMaxMinAvgSum: select alias: alias type: @"MAX"];
}

- (YFDataBase *) selectMin: (NSString *) select
                     alias: (NSString *) alias
{
    return [self YFDBMaxMinAvgSum: select alias: alias type: @"MIN"];
}

- (YFDataBase *) selectAvg: (NSString *) select
                     alias: (NSString *) alias
{
    return [self YFDBMaxMinAvgSum: select alias: alias type: @"AVG"];
}

- (YFDataBase *) selectSum: (NSString *) select
                     alias: (NSString *) alias
{
    return [self YFDBMaxMinAvgSum: select alias: alias type: @"SUM"];
}

#pragma mark - 私有方法.
- (YFDataBase *) YFDBMaxMinAvgSum: (NSString *) select
                            alias: (NSString *) alias
                             type: (NSString *) type
{
    if (NO == [select isKindOfClass: [NSString class]] || YES == [select isEqualToString:@""]) {
        // !!!:无法匹配语法
//        $this->display_error('db_invalid_query');
    }
    
    type = [type uppercaseString];
    
    if (NO == [@[@"MAX", @"MIN", @"AVG", @"SUM"] containsObject: type]) {
        // !!!:无法匹配语法
//        show_error('Invalid function type: '.$type);
    }
    
    if ([alias isEqualToString: @""]) {
        alias = [self YFDBCreateAliasFromTable: [alias stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
    }
    
    // !!!:临时跳出!
//    NSString * sql = [NSString stringWithFormat: @"%@("]
    
    return self;
}

// ???:从实现和已有的应用来看,此方法好像并没有存在的价值.
- (NSString *) YFDBCreateAliasFromTable: (NSString *) item
{
    if (NSNotFound != [item rangeOfString:@"."].location) {
        return [[item componentsSeparatedByString: @"."] lastObject];
    }
    
    return item;
}

- (id) YFDBProtectIdentifiers: (id)   item
                         prefixSingle: (BOOL) perfixSingle
                   protectIdentifiers: (BOOL)   protectIdentifiers
                          fieldExists: (BOOL) fieldExists
{
    if (YES == [item isKindOfClass: [NSDictionary class]]) { // ???:我不确定,这个逻辑有什么用!
        // !!!: 猜想,此处其实可能是在遍历数组.item应该是数组!
        // !!!:怎么可能会传个字典进来,真的有用吗?要干什么??
        NSMutableDictionary * escapedDict = [NSMutableDictionary dictionaryWithCapacity: 42];
        
        [(NSDictionary *)item enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSString * escapeKey = [self YFDBProtectIdentifiers: key prefixSingle: NO protectIdentifiers: NO fieldExists: YES];
            NSString * escapeValue = [self YFDBProtectIdentifiers: obj prefixSingle: NO protectIdentifiers: NO fieldExists: YES];
            
            [escapedDict setObject: escapeKey forKey: escapeValue];
        }];
        
        return escapedDict;
    }
    
    // !!!:标记位置1
    
    // 把制表符或多个空格转换成单一的空格.
    NSRegularExpression * regex = [NSRegularExpression regularExpressionWithPattern:@"[\t ]+" options: 0  error:nil];
    item = [regex stringByReplacingMatchesInString:item options:0 range:NSMakeRange(0, [item length]) withTemplate:@" "];
    
    // 如果此项有一个别名,我们暂时先把别名移到一个单独的变量中保存.
    // 通常,我们移除第一个空格后面的所有内容.
    NSString * alias = @"";
    NSRange rangeOfAlias = [item rangeOfString:@" "];
    if (NSNotFound != rangeOfAlias.location) {
        alias = [item substringFromIndex: rangeOfAlias.location];
        item = [item substringToIndex: rangeOfAlias.location];
    }
    
    // 当涉及到使用MAX,MIN等进行的查询时,我们不需要进行转义或者增加前缀.
    if (NSNotFound != [item rangeOfString: @"("].location) { // !!!:我觉得这个逻辑放到标记位置1,更合理些.
        return [NSString stringWithFormat: @"%@%@", item, alias];
    }
    
    // !!!:不确定如何翻译是好!
    // Break the string apart if it contains periods, then insert the table prefix
    // in the correct location, assuming the period doesn't indicate that we're dealing
    // with an alias. While we're at it, we will escape the components
    if (NSNotFound != [item rangeOfString: @"."].location) {
        NSArray * parts = [item componentsSeparatedByString: @"."];
        // Does the first segment of the exploded item match
        // one of the aliases previously identified?  If so,
        // we have nothing more to do other than escape the item
        if ([self.arAliasedTables containsObject: parts[0]]) {
            if (YES == protectIdentifiers) { //!!!:暂时中止.
                [parts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//!!!:暂时跳出.                    obj = [self YMDBEscapeIdentifiers: ];
                }];
            }
        }
    }
    
    
    
    // !!!:临时返回值.
    return nil;
}

// !!!:转义之后,是否真的能躲避注入攻击?
// !!!:Active Record模式是否天生可以躲避注入攻击?
- (NSString *) YFDBEscapeIdentifiers: (NSString *) item
{
    NSString * result = nil;
    
    if ([self.escapeChar isEqualToString: @""]) {
        return item;
    }
    
    for (NSString * identifier in self.reservedIdentifiers) {
        if (NSNotFound != [item rangeOfString: [NSString stringWithFormat: @".%@", identifier]].location) {
            result = [NSString stringWithFormat: @"%@%@", self.escapeChar, [item stringByReplacingOccurrencesOfString: @"." withString:[NSString stringWithFormat: @"%@.", self.escapeChar]]];
            
            // 在此处移除多余的转义字符.多余转义字符产生的原因是,用户可能已经自己做了转义操作.
            NSRegularExpression * regex = [NSRegularExpression regularExpressionWithPattern: [NSString stringWithFormat: @"[%@]+", self.escapeChar] options: 0  error:nil];
            result = [regex stringByReplacingMatchesInString: result options:0 range:NSMakeRange(0, [result length]) withTemplate:[NSString stringWithFormat: @"%@", self.escapeChar]];
            return result;
        }
    }
    
    if (NSNotFound != [item rangeOfString: @"."].location) {
        result = [NSString stringWithFormat: @"%@%@%@", self.escapeChar, [item stringByReplacingOccurrencesOfString: @"." withString:[NSString stringWithFormat: @"%@.%@", self.escapeChar,self.escapeChar]], self.escapeChar];
    }else{
        result = [NSString stringWithFormat: @"%@%@%@", self.escapeChar, item, self.escapeChar];
    }
    
    // 在此处移除多余的转义字符.多余转义字符产生的原因是,用户可能已经自己做了转义操作.
    NSRegularExpression * regex = [NSRegularExpression regularExpressionWithPattern: [NSString stringWithFormat: @"[%@]+", self.escapeChar] options: 0  error:nil];
    result = [regex stringByReplacingMatchesInString: result options:0 range:NSMakeRange(0, [result length]) withTemplate:[NSString stringWithFormat: @"%@", self.escapeChar]];
    return result;
}
@end
