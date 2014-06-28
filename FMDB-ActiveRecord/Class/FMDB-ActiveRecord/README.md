#YFDataBase 类
***
**YFDB** 是在[FMDB](https://github.com/ccgus/fmdb)基础上对sqlite数据库操作的进一步封装,以使其支持 [Active Record](http://zh.wikipedia.org/wiki/Active_Record) 数据库模式。这种模式是以较少的程序代码来实现信息在数据库中的获取，插入，更改。有时只用一两行的代码就能完成对数据库的操作。 YFDB 不需要每一个数据库表拥有自己的类。它提供了一个更简单的接口。

**注意: YFDB以[FMDB](https://github.com/ccgus/fmdb)为基础。如果更喜欢手动写 SQL 语句,你仍然可以按照原来的方式来使用[FMDB](https://github.com/ccgus/fmdb)来完成各种数据库操作。**

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

、、、
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
、、、

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
$this->db->order_by('title desc, name asc'); 
// 生成: ORDER BY title DESC, name ASC
```

或者，多次调用本函数就可以排序多个字段。

$this->db->order_by("title", "desc");
$this->db->order_by("name", "asc"); 

// 生成: ORDER BY title DESC, name ASC

说明: order_by() 曾经被称为 orderby(), 后者已经过时，现已从代码中移除 orderby()。

说明: 目前 Oracle 和 MSSQL 的驱动还不支持随机排序，将被默认设置为 'ASC'(升序)。

$this->db->limit();

限制查询所返回的结果数量:

$this->db->limit(10);

// 生成: LIMIT 10
第二个参数设置的是结果偏移量。

$this->db->limit(10, 20);

// 生成: LIMIT 20, 10 (仅限MySQL中。其它数据库有稍微不同的语法)
$this->db->count_all_results();

允许你获得某个特定的Active Record查询所返回的结果数量。可以使用Active Record限制函数，例如 where(), or_where(), like(), or_like() 等等。范例：

echo $this->db->count_all_results('my_table');
// 生成一个整数，例如 25

$this->db->like('title', 'match');
$this->db->from('my_table');
echo $this->db->count_all_results();
// 生成一个整数，例如 17  
##[插入数据](id:insertData)

$this->db->insert();

生成一条基于你所提供的数据的SQL插入字符串并执行查询。你可以向函数传递 数组 或一个 对象。下面是一个使用数组的例子：

$data = array(
               'title' => 'My title' ,
               'name' => 'My Name' ,
               'date' => 'My date'
            );

$this->db->insert('mytable', $data); 

// Produces: INSERT INTO mytable (title, name, date) VALUES ('My title', 'My name', 'My date')
第一个参数包含表名，第二个是一个包含数据的关联数组。

下面是一个使用对象的例子：

/*
    class Myclass {
        var $title = 'My Title';
        var $content = 'My Content';
        var $date = 'My Date';
    }
*/

$object = new Myclass;

$this->db->insert('mytable', $object); 

// Produces: INSERT INTO mytable (title, content, date) VALUES ('My Title', 'My Content', 'My Date')
第一个参数包含表名，第二个是一个对象。

注意: 所有的值已经被自动转换为安全查询。

$this->db->insert_batch();

生成一条基于你所提供的数据的SQL插入字符串并执行查询。你可以向函数传递 数组 或一个 对象。下面是一个使用数组的例子：

$data = array(
   array(
      'title' => 'My title' ,
      'name' => 'My Name' ,
      'date' => 'My date'
   ),
   array(
      'title' => 'Another title' ,
      'name' => 'Another Name' ,
      'date' => 'Another date'
   )
);

$this->db->insert_batch('mytable', $data); 

//生成： INSERT INTO mytable (title, name, date) VALUES ('My title', 'My name', 'My date'), ('Another title', 'Another name', 'Another date')
第一个参数包含表名，第二个是一个包含数据的关联数组。

注意: 所有的值已经被自动转换为安全查询。

$this->db->set();

本函数使您能够设置inserts(插入)或updates(更新)值。

它可以用来代替那种直接传递数组给插入和更新函数的方式:

$this->db->set('name', $name); 
$this->db->insert('mytable'); 

// 生成: INSERT INTO mytable (name) VALUES ('{$name}')
如果你多次调用本函数，它们会被合理地组织起来，这取决于你执行的是插入操作还是更新操作:

$this->db->set('name', $name);
$this->db->set('title', $title);
$this->db->set('status', $status);
$this->db->insert('mytable');
set() 也接受可选的第三个参数($escape)，如果此参数被设置为 FALSE，就可以阻止数据被转义。为了说明这种差异，这里将对 包含转义参数 和 不包含转义参数 这两种情况的 set() 函数做一个说明。

$this->db->set('field', 'field+1', FALSE);
$this->db->insert('mytable'); 
// 得到 INSERT INTO mytable (field) VALUES (field+1)

$this->db->set('field', 'field+1');
$this->db->insert('mytable'); 
// 得到 INSERT INTO mytable (field) VALUES ('field+1')

你也可以将一个关联数组传递给本函数:

$array = array('name' => $name, 'title' => $title, 'status' => $status);

$this->db->set($array);
$this->db->insert('mytable');
或者一个对象也可以:

/*
    class Myclass {
        var $title = 'My Title';
        var $content = 'My Content';
        var $date = 'My Date';
    }
*/

$object = new Myclass;

$this->db->set($object);
$this->db->insert('mytable');  
##[更新数据](id:updataData)

$this->db->update();

根据你提供的数据生成并执行一条update(更新)语句。你可以将一个数组或者对象传递给本函数。这里是一个使用数组的例子:

$data = array(
               'title' => $title,
               'name' => $name,
               'date' => $date
            );

$this->db->where('id', $id);
$this->db->update('mytable', $data); 

// 生成:
// UPDATE mytable 
// SET title = '{$title}', name = '{$name}', date = '{$date}'
// WHERE id = $id
或者你也可以传递一个对象:

/*
    class Myclass {
        var $title = 'My Title';
        var $content = 'My Content';
        var $date = 'My Date';
    }
*/

$object = new Myclass;

$this->db->where('id', $id);
$this->db->update('mytable', $object); 

// 生成:
// UPDATE mytable 
// SET title = '{$title}', name = '{$name}', date = '{$date}'
// WHERE id = $id
说明: 所有值都会被自动转义，以便生成安全的查询。

你会注意到 $this->db->where() 函数的用法，它允许你设置 WHERE 子句。你可以有选择性地将这一信息直接以字符串的形式传递给 update 函数:

$this->db->update('mytable', $data, "id = 4");
或者是一个数组:

$this->db->update('mytable', $data, array('id' => $id));
在进行更新时，你还可以使用上面所描述的 $this->db->set() 函数。

$this->db->update_batch();

生成一条update命令是以你提供的数据为基础的，并执行查询。你可以传递一个数组或对象的参数给update_batch()函数。下面是一个使用一个数组作为参数的示例：Generates an update string based on the data you supply, and runs the query. You can either pass an array or an object to the function. Here is an example using an array:

$data = array(
   array(
      'title' => 'My title' ,
      'name' => 'My Name 2' ,
      'date' => 'My date 2'
   ),
   array(
      'title' => 'Another title' ,
      'name' => 'Another Name 2' ,
      'date' => 'Another date 2'
   )
);

$this->db->update_batch('mytable', $data, 'title'); 

// Produces: 
// UPDATE `mytable` SET `name` = CASE
// WHEN `title` = 'My title' THEN 'My Name 2'
// WHEN `title` = 'Another title' THEN 'Another Name 2'
// ELSE `name` END,
// `date` = CASE 
// WHEN `title` = 'My title' THEN 'My date 2'
// WHEN `title` = 'Another title' THEN 'Another date 2'
// ELSE `date` END
// WHERE `title` IN ('My title','Another title')
参数1:表名 参数2:如上所示的二维数组 参数3:键名.

提示: 所有的值都会自动进行安全性过滤.

 
##[删除数据](id:deleteData)

$this->db->delete();

生成并执行一条DELETE(删除)语句。

$this->db->delete('mytable', array('id' => $id)); 

// 生成:
// DELETE FROM mytable 
// WHERE id = $id
第一个参数是表名，第二个参数是where子句。你可以不传递第二个参数，使用 where() 或者 or_where() 函数来替代它:

$this->db->where('id', $id);
$this->db->delete('mytable'); 

// 生成:
// DELETE FROM mytable 
// WHERE id = $id

如果你想要从一个以上的表中删除数据，你可以将一个包含了多个表名的数组传递给delete()函数。

$tables = array('table1', 'table2', 'table3');
$this->db->where('id', '5');
$this->db->delete($tables);

如果你想要删除表中的全部数据，你可以使用 truncate() 函数，或者 empty_table() 函数。

说明：delete方法貌似现在没有办法接收排序参数

假设我想删除早期的用户登录日志信息，我的语法可能会是根据登录时间正序排列，然后跟上limit已经有的总日志条数减去想保留的条数，delete方法没有这个参数用来接收，那么我只能直接使用query传递我的sql了

$this->db->empty_table();

生成并执行一条DELETE(删除)语句。 $this->db->empty_table('mytable'); 

// 生成
// DELETE FROM mytable

$this->db->truncate();

生成并执行一条TRUNCATE(截断)语句。

$this->db->from('mytable'); 
$this->db->truncate(); 
// 或 
$this->db->truncate('mytable'); 

// 生成:
// TRUNCATE TABLE mytable 
说明: 如果 TRUNCATE 命令不可用，truncate() 将会以 "DELETE FROM table" 的方式执行。

##[链式方法](id:methodChain)

链式方法允许你以连接多个函数的方式简化你的语法。考虑一下这个范例:

$this->db->select('title')->from('mytable')->where('id', $id)->limit(10, 20);

$query = $this->db->get();
说明: 链式方法只能在PHP 5下面运行。

##[Active Record 缓存](id:arCache)

尽管不是 "真正的" 缓存，Active Record 允许你将查询的某个特定部分保存(或"缓存")起来，以便在你的脚本执行之后重用。一般情况下，当一次Active Record调用结束，所有已存储的信息都会被重置，以便下一次调用。如果开启缓存，你就可以使信息避免被重置，方便你进行重用。

缓存调用是累加的。如果你调用了两次有缓存的 select()，然后再调用两次没有缓存的 select()，这会导致 select() 被调用4次。有三个可用的缓存函数:

$this->db->start_cache()

本函数必须被用来开启缓存。所有类型正确的(下面给出了支持的查询类型) Active Record 查询都会被存储起来供以后使用。

$this->db->stop_cache()

本函数可以被用来停止缓存。

$this->db->flush_cache()

本函数从Active Record 缓存中删除全部项目。

这里是一个使用范例:

$this->db->start_cache();
$this->db->select('field1');
$this->db->stop_cache();

$this->db->get('tablename');

//Generates: SELECT `field1` FROM (`tablename`)

$this->db->select('field2');
$this->db->get('tablename');

//Generates: SELECT `field1`, `field2` FROM (`tablename`)

$this->db->flush_cache();

$this->db->select('field2');
$this->db->get('tablename');

//Generates: SELECT `field2` FROM (`tablename`)

说明: 下列语句能够被缓存: select, from, join, where, like, group_by, having, order_by, set