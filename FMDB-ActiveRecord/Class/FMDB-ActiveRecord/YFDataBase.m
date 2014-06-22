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

@end
