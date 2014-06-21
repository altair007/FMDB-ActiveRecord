//
//  YFDataBase.m
//  FMDB-ActiveRecord
//
//  Created by   颜风 on 14-6-21.
//  Copyright (c) 2014年 Shadow. All rights reserved.
//

#import "YFDataBase.h"

@implementation YFDataBase
+ (instancetype)databaseWithPath:(NSString *)inPath
{
    // TODO:重写便利构造器!
}

- (instancetype)initWithPath:(NSString *)inPath
{
    if (self = [super initWithPath: inPath]) {
        self.arSelect = [NSMutableArray arrayWithCapacity: 42];
        self.arDistinct = NO;
        self.arFrom = [NSMutableArray arrayWithCapacity: 42];
        self.arJoin = [NSMutableArray arrayWithCapacity: 42];
        self.arLike = [NSMutableArray arrayWithCapacity: 42];
        self.arGroupby = [NSMutableArray arrayWithCapacity: 42];
        self.arHaving = [NSMutableArray arrayWithCapacity: 42];
        self.arKeys = [NSMutableArray arrayWithCapacity: 42];
        self.arLimit = NO;
        self.arOffset = NO;
        self.arOrder = NO;
        self.arOrderby = [NSMutableArray arrayWithCapacity: 42];
        self.arSet = [NSMutableArray arrayWithCapacity: 42];
        self.arWherein = [NSMutableArray arrayWithCapacity: 42];
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
@end
