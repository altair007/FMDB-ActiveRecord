#YFDataBase 类
***
**YFDB** 是在[FMDB](https://github.com/ccgus/fmdb)基础上对sqlite数据库操作的进一步封装,以使其支持 [Active Record](http://zh.wikipedia.org/wiki/Active_Record) 数据库模式。这种模式是以较少的程序代码来实现信息在数据库中的获取，插入，更改。有时只用一两行的代码就能完成对数据库的操作。 YFDB 不需要每一个数据库表拥有自己的类。它提供了一个更简单的接口。

**注意: YFDB以[FMDB](https://github.com/ccgus/fmdb)为基础,在使用 YFDB 之前请先在自己的工程中正确引入[FMDB](https://github.com/ccgus/fmdb)。如果更喜欢手动写 SQL 语句,你仍然可以按照原来的方式来使用[FMDB](https://github.com/ccgus/fmdb)来完成各种数据库操作。**

* [选择数据](#selectData)
* [插入数据](#insertData)
* [更新数据](#updataData)
* [删除数据](#deleteData)
* [链式方法](#methodChain)
* [Active Record 缓存](#arCache)
 
##[选择数据](id:selectData)

下面的函数帮助你构建 SQL **SELECT**语句。

**备注：你可以在复杂情况下使用链式语法。本页面底部有具体描述。**

###get:limit:offset:
***

运行选择查询语句并且返回结果集。获取一个表的全部数据，你可以直接使用 *get:* 方法。

```
FMResultSet * result = [db get: @"mytable"];
// 生成: SELECT * FROM mytable]
```

*limit* 参数允许你设置一个结果集每页纪录数，*offset* 参数允许你设置结果集的偏移。

```
FMResultSet * result = [db get: @"mytable" limit: 10 offset: 20];
// 生成: SELECT * FROM mytable LIMIT 20, 10
```

你会注意到上面的方法返回的是一个 **FMResultSet** 对象，你可以用它来显示结果集，就像你在 FMDB 中做的那样。

```
    FMResultSet * result  = [db get: @"mytable"];
	while ([result next]) {
		// 检索每个记录的值。
	}
```

请访问 [FMDB](https://github.com/ccgus/fmdb) 项目主页查看详细的生成结果的方法。

### get: where: limit: offset:
***

跟上面的方法一样，只是它允许你在方法的第二个参数那里添加一个用于构成 *where* 从句的字典，从而不用使用 *where:* 这个方法：

```
FMResultSet * result = [db getWhere: @"mytable" where:@{@"id": idValue}];
```

请阅读下面的 *where:* 方法了解更多。

### select:
***

允许你在 SQL 查询中写 **SELECT** 部分:

```
[db select: @"title, content, data"];
FMResultSet * result = [db get: @"mytable"]; 
// 生成: SELECT title, content, date FROM mytable
```

**注意: 如果你要查询表中的所有列，你可以直接使用 *select* 方法。**

### selectMax: alias:
***

为你的查询编写一个 **SELECT MAX(field) AS alias**。如果你不想重命名结果字段名，可以直接使用 *selectMax:* 方法。

```
[db selectMax: @"age"];
FMResultSet * result = [db get: @"members"];
// 生成：SELECT MAX(age) as age FROM members
```
```
[db selectMax: @"age" alias: @"memberAge"];
FMResultSet * result = [db get: @"members"];
// 生成: SELECT MAX(age) as memberAge FROM members
```

### selectMin: alias:
***

为你的查询编写一个 **SELECT MIN(field) AS alias** 。如果你不想重命名结果字段名，可以直接使用 *selectMin:* 方法。

```
[db selectMin: @"age"];
FMResultSet * result = [db get: @"members"];
// 生成: SELECT MIN(age) as age FROM members
```

### selectAvg: alias:
***

为你的查询编写一个 **SELECT AVG(field) AS alias** 。如果你不想重命名结果字段名，可以直接使用 *selectAvg:* 方法。

```
[db selectAvg: @"age"];
FMResultSet * result = [db get: @"members"];
// 生成: SELECT AVG(age) as age FROM members
```

### selectSum: alias:
***

为你的查询编写一个 "SELECT SUM(field) AS alias" 。如果你不想重命名结果字段名，可以直接使用 *selectSum:* 方法。

```
[db selectSum: @"age"];
FMResultSet * result = [db get: @"members"];
// 生成: SELECT SUM(age) as age FROM members
```

### from:
***

允许你编写查询中的 **FROM** 部分:

```
[db select: @"title, content, date"];
[db from: @"mytable"];
FMResultSet * result = [db get];
// 生成: SELECT title, content, date FROM mytable
```
**说明: 或许你已经想到，查询中的FROM部分也可以在  get: 方法中指定，所以你可以根据自己的喜好来选择使用哪个方法。**

### join: condtion: type: 
***

允许你编写查询中的 **JOIN** 部分。

```
[db select];
[db from: @"blogs"];
[db join: @"comments" condtion: @"comments.id = blogs.id" type: YFDBLeftOuterJoin];
FMResultSet * result = [db get];
// 生成:
// SELECT * FROM blogs
// LEFT OUTTER JOIN comments ON comments.id = blogs.id
```

如果你不需要指定 JOIN 类型，你可以使用 *join:condtion:* 方法。

```
[db select];
[db from: @"blogs"];
[db join: @"comments" condtion: @"comments.id = blogs.id"];
FMResultSet * result = [db get];
// 生成:
// SELECT * FROM blogs
// JOIN comments ON comments.id = blogs.id
```

如果你想要在查询中使用多个连接，可以多次向数据库对象发送此消息。


### where:
***

本方法允许你使用三种方式中的一种来设置 **WHERE** 子句:

* 简单的 key/value 方式，即向方法传递一个单键值对字典对象: 

```   
[db select];
[db from: @"blogs"];
[db where: @{@"name": @"颜风"}];
FMResultSet * result = [db get];
// 生成:
// SELECT * FROM blogs
// WHERE name = '颜风'
```

请注意等号已经为你添加。

如果你多次向数据库对象发送此消息，那么这些条件会被 **AND** 连接起来:

```
[db select];
[db from: @"blogs"];
[db where: @{@"name": @"颜风"}];
[db where: @{@"title": @"出处"}];
[db where: @{@"status": @"active"}];
FMResultSet * result = [db get];
// 生成:
// SELECT * FROM blogs
// WHERE name = '颜风' AND title = '出处' AND status = 'active'
```

* 自定义 key/value 方式:
你仍然需要向方法传递一个单键值对字典对象， 但你可以在 key 中包含一个运算符，以便控制比较:

```
[db select];
[db from: @"blogs"];
[db where: @{@"name != ": @"颜风"}];
[db where: @{@"id < ": [NSNumber numberWithUnsignedInteger: 42]}];
FMResultSet * result = [db get];
// 生成:
// SELECT * FROM blogs
// WHERE name != '颜风' AND id < 42
```

* 你可以向方法传递含有多个键值对的字典对象

```
[db select];
[db from: @"blogs"];
[db where: @{@"name": @"颜风", @"status =": @"active"}];
FMResultSet * result = [db get];
// 生成:
// SELECT * FROM blogs
// WHERE name = '颜风' AND status = 'active'
```

使用这个方法时你也可以包含运算符:
 
```
[db select];
[db from: @"blogs"];
[db where: @{@"name != ": @"颜风", @"id < ": [NSNumber numberWithUnsignedInteger: 42], @"status =": @"active"}];
FMResultSet * result = [db get];
// 生成:
// SELECT * FROM blogs
// WHERE name != '颜风' AND id < 42 AND status = 'active'
```

### orWhere:
***

本方法与上面的那个几乎完全相同，唯一的区别是本方法生成的子句是用 **OR** 来连接的:

```
[db select];
[db from: @"blogs"];
[db orWhere: @{@"name": @"颜风", @"id > ": [NSNumber numberWithUnsignedInteger: 42]}];
FMResultSet * result = [db get];
// 生成:
// SELECT * FROM blogs
// WHERE name = '颜风' OR id > 42
```

### where:inValues:
***

生成一段 **WHERE field IN ('item', 'item')** 查询语句，如果 **WHERE** 子句含有其他部分，将用 **AND** 与其连接起来。

```
[db where: @"id" inValues: @[[NSNumber numberWithUnsignedInteger: 42], [NSNumber numberWithUnsignedInteger: 43]]];
[db where: @"username" inValues: @[@"Shadow", @"Altair"]];
FMResultSet * result = [db get: @"blogs"];
// 生成:
// SELECT * FROM blogs
// WHERE id IN(42, 43) AND username IN ('Shadow', 'Altair')
```

### orWhere:inValues:
***

生成一段 **WHERE field IN ('item', 'item')** 查询语句，如果合适的话，用 **OR** 连接起来。

```
[db where: @"id" inValues: @[[NSNumber numberWithUnsignedInteger: 42], [NSNumber numberWithUnsignedInteger: 43]]];
[db orWhere: @"username" inValues: @[@"Shadow", @"Altair"]];
FMResultSet * result = [db get: @"blogs"];
// 生成:
// SELECT * FROM blogs
// WHERE id IN(42, 43) OR username IN ('Shadow', 'Altair')
```

### where:notInValues:
***

生成一段 **WHERE field NOT IN ('item', 'item')** 查询语句，如果合适的话，用 **AND** 连接起来。

```
[db where: @"id" inValues: @[[NSNumber numberWithUnsignedInteger: 42], [NSNumber numberWithUnsignedInteger: 43]]];
[db where: @"username" notInValues: @[@"Shadow", @"Altair"]];
FMResultSet * result = [db get: @"blogs"];
// 生成:
// SELECT * FROM blogs
// WHERE id IN(42, 43) AND username Not IN ('Shadow', 'Altair')
```

### orWhere:notInValues:
***

生成一段 **WHERE field NOT IN ('item', 'item')** 查询语句，如果合适的话，用 **OR** 连接起来。

```
[db where: @"id" inValues: @[[NSNumber numberWithUnsignedInteger: 42], [NSNumber numberWithUnsignedInteger: 43]]];
[db orWhere: @"username" notInValues: @[@"Shadow", @"Altair"]];
FMResultSet * result = [db get: @"blogs"];
// 生成:
// SELECT * FROM blogs
// WHERE id IN(42, 43) OR username Not IN ('Shadow', 'Altair')
```

### like:side:
***

本函数允许你生成 **LIKE** 子句，在做查询时非常有用。

* 你可以向方法传递一个单键值对字典，这可能是最常用的方式。

```
[db like: @{@"title": @"颜风"} side: YFDBLikeSideBefore];
FMResultSet * result = [db get: @"blogs"];
// 生成:
// SELECT * FROM blogs
// WHERE title LIKE '%颜风'
```
```
[db like: @{@"title": @"颜风"} side: YFDBLikeSideAfter];
FMResultSet * result = [db get: @"blogs"];
// 生成:
// SELECT * FROM blogs
// WHERE title LIKE '颜风%'
```
```
[db like: @{@"title": @"颜风"} side: YFDBLikeSideBoth];
FMResultSet * result = [db get: @"blogs"];
// 生成:
// SELECT * FROM blogs
// WHERE title LIKE '%颜风%'
```
```
[db like: @{@"title": @"颜风"} side: YFDBLikeSideNone];
FMResultSet * result = [db get: @"blogs"];
// 生成:
// SELECT * FROM blogs
// WHERE title LIKE '颜风'
```

如果你不想控制通配符（*%*）的位置，你可以直接使用 *like:*方法。

```
[db like: @{@"title": @"颜风"}];
FMResultSet * result = [db get: @"blogs"];
// 生成:
// SELECT * FROM blogs
// WHERE title LIKE '%颜风%'
```

如果你多次调用本函数，那么这些条件将由 **AND** 连接起来:

```
[db like: @{@"title": @"颜风"}];
[db like: @{@"body": @"大爱颜风"}];
FMResultSet * result = [db get: @"blogs"];
// 生成:
// SELECT * FROM blogs
// WHERE title LIKE '%颜风%' AND body LIKE '%大爱颜风%'
```

* 你也可以直接向方法传递一个含有多个键值对的字典对象。

```
[db like: @{@"title": @"颜风", @"body": @"大爱颜风"}];
FMResultSet * result = [db get: @"blogs"];
// 生成:
// SELECT * FROM blogs
// WHERE title LIKE '%颜风%' AND body LIKE '%大爱颜风%'
```

### orLike:side:

本方法与上面那个函数几乎完全相同，唯一的区别是多个实例之间是用 **OR** 连接起来的:

```
[db like: @{@"title": @"颜风"}];
[db orLike: @{@"body": @"大爱颜风"}];
FMResultSet * result = [db get: @"blogs"];
// 生成:
// SELECT * FROM blogs
// WHERE title LIKE '%颜风%' OR body LIKE '%大爱颜风%'
```

### notLike:side:

本方法与 *like:side:* 方法几乎完全相同，唯一的区别是它生成 **NOT LIKE** 语句:

```
[db like: @{@"title": @"颜风"}];
[db notLike: @{@"body": @"大爱颜风"}];
FMResultSet * result = [db get: @"blogs"];
// 生成:
// SELECT * FROM blogs
// WHERE title LIKE '%颜风%' OR body NOT LIKE '%大爱颜风%'
```

### orNotLike:side:
***

本F方法与 *notLike:side:* 几乎完全相同，唯一的区别是多个实例之间是用 **OR** 连接起来的:

```
[db like: @{@"title": @"颜风"}];
[db orNotLike: @{@"body": @"大爱颜风"}];
FMResultSet * result = [db get: @"blogs"];
// 生成:
// SELECT * FROM blogs
// WHERE title LIKE '%颜风%' OR body NOT LIKE '%大爱颜风%'
```

### groupBy:

允许你编写查询语句中的 **GROUP BY** 部分:

```
[db groupBy: @"title"];
FMResultSet * result = [db get: @"blogs"];
// 生成:
// SELECT * FROM blogs GROUP BY title
```

也可以传递用 ',' 符号分隔的多个值。

```
[db groupBy: @"title, id"];
FMResultSet * result = [db get: @"blogs"];
// 生成:
// SELECT * FROM blogs GROUP BY title, id
```

### distinct
***

为查询语句添加 **DISTINCT** 关键字:

```
[db distinct];
FMResultSet * result =  [db get: @"blogs"];
// 生成: SELECT DISTINCT * FROM blogs
```

### having:
***


允许你为你的查询语句编写 **HAVING** 部分。

```
[db select: @"COUNT(id) number, title"];
[db groupBy: @"title"];
[db having: @{@"number > ": [NSNumber numberWithUnsignedInteger: 2],@"title != ": @"颜风"}];
FMResultSet * result =  [db get: @"blogs"];
// 生成:
// SELECT COUNT(id) number, title
// FROM (blogs)
// GROUP BY title
// HAVING  number >  2
// AND title !=  '颜风'
```

### orHaving:
***

与 *having:* 函数几乎完全一样，唯一的区别是多个子句之间是用 **OR** 分隔的。

### orderBy:direction:
***

帮助你设置一个 **ORDER BY** 子句。第一个参数是你想要排序的字段名。第二个参数设置结果的顺序，可用的选项包括 YFDBOrderAsc (升序)或 YFDBOrderDesc(降序), 或 YFDBOrderRandom(随机) 或 YFDBOrderDeault (默认,SQLite 默认升序)。

```
[db orderBy: @"title" direction: YFDBOrderDesc];
FMResultSet * result =  [db get: @"blogs"];
// 生成:
// SELECT *
// FROM (blogs)
// ORDER BY title DESC
```

如果你想在第一个参数中传递你自己的字符串, *orderBY:* 方法是一个更好的选择:

```
[db orderBy: @"title DESC, name ASC"];
FMResultSet * result =  [db get: @"blogs"];
// 生成:
// SELECT *
// FROM (blogs)
// ORDER BY title DESC, name ASC
```

当然，你也可以多次向数据库对象发送 *orderBy:direction:* 消息来排序多个字段。

```
[db orderBy: @"title" direction: YFDBOrderDesc];
[db orderBy: @"name" direction: YFDBOrderAsc];
FMResultSet * result =  [db get: @"blogs"];
// 生成:
// SELECT *
// FROM (blogs)
// ORDER BY title DESC, name ASC
```

### limit:offset:
***

限制查询所返回的结果数量,并设置结果的偏移量:

```
[db limit: 5 offset: 15];
FMResultSet * result =  [db get: @"blogs"];
// 生成:
// SELECT *
// FROM (blogs)
// LIMIT 15, 5
```
如果你不打算设置结果的偏移量,可以直接向数据库对象发送 *limit:* 消息.

```
[db limit: 5];
FMResultSet * result =  [db get: @"blogs"];
// 生成:
// SELECT *
// FROM (blogs)
// LIMIT 0, 5
```

### countAllResults:
***

允许你获得某个特定的 **Active Record** 查询所返回的结果数量。可以使用 **Active Record** 限制方法，例如 *where:*, *orWhere:*, *like:side:*, *orLike:side:* 等等。范例：

```
[db like: @{@"title": @"颜风"}];
NSLog(@"%lu", [db countAllResults: @"blogs"]);
// 生成一个整数，例如 42  
```

##[插入数据](id:insertData)

### insert:set:
***

生成一条基于你所提供的数据的SQL插入字符串并执行查询。

```
NSDictionary * set = @{@"title": @"My title",
                       @"name": @"My Name",
                       @"date": @"My Date"};
[db insert: @"mytable" set: set];
// 生成: INSERT INTO mytable (title, date, name) VALUES ('My title', 'My Date', 'My Name')
```

### insert:batch:

生成一条基于你所提供的数据的SQL插入字符串并执行查询。你可以向方法传递一个存储有要插入的数据的数组来插入同时插入多组数据.

```
NSArray * batch = @[@{@"title": @"My title",
                     @"name": @"My Name",
                     @"date": @"My Date"},
                   @{@"title": @"Another title",
                     @"name": @"Another Name",
                     @"date": @"Another Date"}];
[db insert: @"mytable" batch: batch];
// 生成: INSERT INTO mytable (date, name, title) VALUES ('My Date', 'My Name', 'My title'), ('Another Date', 'Another Name', 'Another title')
```

### set:
***

此方法使您能够设置用于插入或更新的值。

它可以用来代替那种直接传递数组或字典给插入和更新方法的方式:

```
[db set: @{@"name": @"my name"}];
[db insert: @"mytable"];
// 生成: INSERT INTO mytable (name) VALUES ('my name')
```

如果你多次调用本函数，它们会根据最终执行的是插入操作还是更新操作而自动合理地组织起来:

```
[db set: @{@"name": @"my name"}];
[db set: @{@"title": @"my title"}];
[db set: @{@"status": @"my status"}];
[db insert: @"mytable"];
// 生成: INSERT INTO mytable (title, name, status) VALUES ('my title', 'my name', 'my status')
```

```
[db set: @{@"name": @"my name"}];
[db set: @{@"title": @"my title"}];
[db set: @{@"status": @"my status"}];
[db update: @"mytable"];
// 生成: UPDATE mytable SET title = 'my title', name = 'my name', status = 'my status'
```

当然,一种更加便利的方式,直接将一个多键值对字典传递给此方法:

```
[db set: @{@"name": @"my name", @"title": @"my title", @"status": @"my status"}];
[db insert: @"mytable"];
// 生成: INSERT INTO mytable (title, name, status) VALUES ('my title', 'my name', 'my status')
```
##[更新数据](id:updataData)

### update:set:where: 
***

根据你提供的数据生成并执行一条 **UPDATE** 语句。

```
[db update: @"mytable" set: @{@"name": @"my name", @"title": @"my title", @"status": @"my status"} where: @{@"id": @"6aKc6aOO"}];
// 生成:UPDATE mytable SET title = 'my title', name = 'my name', status = 'my status' WHERE  id = '6aKc6aOO'
```
### update:batch:index:
***

根据你提供的数据生成一条 **update** 查询语句，并执行。

```
NSArray * data = @[@{@"title": @"My title",
                     @"name": @"My name",
                     @"date": @"My date"},
                   @{@"title": @"Another title",
                     @"name": @"My name2",
                     @"date": @"My date2"}];
[db update: @"mytable" batch: data index: @"title"];
// 生成:
// UPDATE mytable
// SET date = CASE
// WHEN title = 'My title' THEN 'My date'
// WHEN title = 'Another title' THEN 'My date2'
// ELSE date END,
// name = CASE
// WHEN title = 'My title' THEN 'My name'
// WHEN title = 'Another title' THEN 'My name2'
// ELSE name END
// WHERE title IN ('My title', 'Another title')
```
参数1:表名 参数2:存储字典的数组 参数3:用来决定数据更新位置的字段.

##[删除数据](id:deleteData)

### remove:where:
***

生成并执行一条 **DELETE** 语句。

```
[db remove: @"mytable" where: @{@"id": @"6aKc6aOO"}];
// 生成:
// DELETE FROM mytable
// WHERE  id = '6aKc6aOO'
```
第一个参数是表名，第二个参数用来生成 **WHERE** 子句。所以你可以配合使用*remove:* 方法 与 *where:* 方法来达到同样的效果:

```
[db where: @{@"id": @"6aKc6aOO"}];
[db remove: @"mytable"];
// 生成:
// DELETE FROM mytable
// WHERE  id = '6aKc6aOO'
```

如果你想要从多个表中删除数据，用','分隔表名即可.

```
[db where: @{@"id": @"6aKc6aOO"}];
[db remove: @"mytable1, mytable2, mytable3"];
```

如果你想要删除表中的全部数据，可以向数据库对象发送 *empthTable:* 消息.

### emptyTable:
***

生成并执行一条 **DELETE** 语句。 

```
[db emptyTable: @"mytable"];
// 生成: DELETE FROM mytable
```
##[链式方法](id:methodChain)

链式方法允许你以连接多个函数的方式简化你的语法。考虑一下这个范例:

```
[[[[db select: @"title"] from: @"mytable"] where: @{@"id": @"6aKc6aOO"}] limit:5 offset:15];
FMResultSet * result =  [db get];
// 生成:
// SELECT title
// FROM mytable
// WHERE  id = '6aKc6aOO'
// LIMIT 15, 5
```

##[Active Record 缓存](id:arCache)

尽管不是 "真正的" 缓存，**Active Record** 允许你将查询的某个特定部分保存(或"缓存")起来，以便在你的脚本执行之后重用。一般情况下，当一次 **Active Record** 查询结束(比如,你向数据库对象发送了 *get:* 消息)，所有已存储的信息都会被重置，以便下一次调用。如果开启缓存，你就可以使信息避免被重置，方便你进行重用。

缓存调用是累加的。如果你向数据库对象发送了两次有缓存的 **select:**，此次 **Active Record** 结束后,你再向数据库对象发送两次没有缓存的 **select:** 消息，此时数据库对象会响应4次 **select:** 消息。有三个可用的关于缓存的方法:

### startCache
***

次方法必须被用来开启缓存。所有类型正确的(下面给出了支持的查询类型) **Active Record** 查询都会被存储起来供以后使用。

### stopCache

此方法可以被用来停止缓存。

### flushCache

此方法被用来从Active Record 缓存中删除全部项目。

下面是一个使用范例:

```
[db startCache];
[db select: @"field1"];
[db stopCache];
FMResultSet * result = [db get: @"tablename"];
// 生成:
// SELECT field1
// FROM tablename
[db select: @"field2"];
[db get: @"tablename"];
// 生成:
// SELECT field1, field2
// FROM tablename
[db flushCache];
[db select: @"field2"];
[db get: @"tablename"];
// 生成:
// SELECT field2
// FROM tablename
```

说明: 下列语句能够被缓存: **SELECT**, **FROM**, **JOIN**, **WHERE**, **LIKE**, **GROUP BY**, **HAVING**, **ORDER BY**, **SET**