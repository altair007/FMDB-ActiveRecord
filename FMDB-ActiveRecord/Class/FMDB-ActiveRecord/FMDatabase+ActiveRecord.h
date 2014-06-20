//
//  FMDatabase+ActiveRecord.h
//  DBActiveRecord
//
//  Created by   颜风 on 14-6-20.
//  Copyright (c) 2014年 Shadow. All rights reserved.
//

#import "FMDatabase.h"

// !!!:可能必须使用延展,才能实现既定需求!
// !!!:基本迭代规划:1.实现 2.优化
@interface FMDatabase (ActiveRecord)
- (void) get;
- (void) getWhere;
- (void) select;
- (void) selectMax;
- (void) selectMin;
- (void) selectAvg;
- (void) selectSum;
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
- (void) countAll;
- (void) insert;
- (void) insertBatch;
- (void) set;
- (void) update;
- (void) updateBatch;
- (void) delete;
- (void) emptyTable;
- (void) truncate;
- (void) startCache;
- (void) stopCache;
- (void) flushCache;
@end
