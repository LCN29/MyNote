# explain 

explain 可以用来分析sql语句的性能, 主要关注(type, key, row)


## 前提
数据库中的索引基本都是有序的

## 例子
```sql
EXPLAIN select * from t_u_playerinfo where NickName like 'AAAA';
```
 | id  |  select_type | table | type  |  possible_keys  | key |  key_len  |  ref  | row  | Extra | 
 | :-:  | :-: |  :-: |  :-:  | :-: |  :-: |  :-:  | :-: |  :-: | :-: |
 | 1 | simple | t_u_playerinfo | range | Index_1 | Index_1 | 152 | (Null) | 1 | Using index condition|

1. id : select查询的序列号
2. select_type : select查询的类型，可以为以下任何一种: 
>1. SIMPLE:简单SELECT(不使用UNION或子查询)

>2. PRIMARY:最外面的SELECT

>3. UNION:UNION中的第二个或后面的SELECT语句

>4. DEPENDENT UNION:UNION中的第二个或后面的SELECT语句,取决于外面的查询

>5. UNION RESULT:UNION 的结果

>6. SUBQUERY:子查询中的第一个SELECT

>7. DEPENDENT SUBQUERY:子查询中的第一个SELECT,取决于外面的查询

>8. DERIVED:导出表的SELECT(FROM子句的子查询)

3. table: 输出的行所引用的表

4. type: 联合查询所使用的类型, type显示的是访问类型，是较为重要的一个指标，结果值从好到坏依次是(一般来说，得保证查询至少达到range级别，最好能达到ref)：
>1. system:表仅有一行(=系统表)。这是const联接类型的一个特例。

>2. const:表最多有一个匹配行,它将在查询开始时被读取。因为仅有一行,在这行的列值可被优化器剩余部分认为是常数。const表很快,因为它们只读取一次

>3. eq_ref: 在查询时已经知道数据项为一个(主键, unique),这可能是最好的联接类型,除了const类型。

>4. ref: 查找条件列使用了索引而且不为主键和unique, 意思就是虽然使用了索引,但该索引列的值并不唯一,有重复。

>5. fulltext: 使用全文索引执行的

>5. ref_or_null:该联接类型如同ref,但是添加了MySQL可以专门搜索包含NULL值的行。

>6. index_merge:该联接类型表示使用了索引合并优化方法。

>7. unique_subquery:该类型替换了下面形式的IN子查询的ref: value IN (SELECT primary_key FROM single_table WHERE some_expr) unique_subquery是一个索引查找函数,可以完全替换子查询,效率更高。

>8. index_subquery:该联接类型类似于unique_subquery。可以替换IN子查询,但只适合下列形式的子查询中的非唯一索引: value IN (SELECT key_column FROM single_table WHERE some_expr)

>9. range: 只检索给定范围的行, 用于查询的列需要为索引。

>10. index: 为了找到数据，进行了索引扫描(索引树被扫描)。这通常比ALL快,因为索引文件通常比数据文件小。

>11. ALL: 为了找到数据,进行完整的表扫描。

5. possible_keys:  指出MySQL能使用哪个索引在该表中找到行。如果是空的，没有相关的索引。
6. key: 显示MySQL实际决定使用的键。如果没有索引被选择，键是NULL。
7. key_len: 显示MySQL决定使用的键长度。如果键是NULL，长度就是NULL。
8. ref: 显示哪个字段或常数与key一起被使用
9. rows: 这个数表示mysql要遍历多少数据才能找到，在innodb上是不准确的。

10. Extra: 关于MYSQL如何解析查询的额外信息
>1. Distinct: MySQL发现第1个匹配行后,停止为当前的行组合搜索更多的行。

>2. Not exists: MySQL能够对查询进行LEFT JOIN优化,发现1个匹配LEFT JOIN标准的行后,不再为前面的的行组合在该表内检查更多的行。

>3. range checked for each record: MySQL没有发现好的可以使用的索引,但发现如果来自前面的表的列值已知,可能部分索引可以使用。

>4. Using filesort: Mysql需要进行额外的步骤来发现如何对返回的行排序。(sql需要优化了)

>5. Using index: 从只使用索引树中的信息而不需要进一步搜索读取实际的行来检索表中的列信息。

>6. Using temporary: 为了解决查询,MySQL需要创建一个临时表来容纳结果。(sql需要优化了)

>7. Using where: WHERE 子句用于限制哪一个行匹配下一个表或发送到客户。

>8. Using sort_union(...), Using union(...), Using intersect(...):这些函数说明如何为index_merge联接类型合并索引扫描。

>9. Using index for group-by: 类似于访问表的Using index方式,Using index for group-by表示MySQL发现了一个索引,可以用来查 询GROUP BY或DISTINCT查询的所有列,而不要额外搜索硬盘访问实际的表。

## select_type
1. UNION 
当通过union来连接多个查询结果时，第二个之后的select其select_type为UNION
`explain select * from t_order where order_id=100 union select * from t_order where order_id=200`

 | id  |  select_type | table | type  |  possible_keys  | key |  key_len  |  ref  | row  | Extra | 
 | :-:  | :-: |  :-: |  :-:  | :-: |  :-: |  :-:  | :-: |  :-: | :-: |
 |  1 | PRIMARY      | t_order    | const | PRIMARY       | PRIMARY | 4       | const |    1 |       |
 | 2 | UNION        | t_order    | const | PRIMARY       | PRIMARY | 4       | const |    1 |       |
 | NULL | UNION RESULT | <union1,2> | ALL   |          |     |     |    |   |   NULL   | 
 
 2. DEPENDENT UNION与DEPENDENT SUBQUERY
当union作为子查询时，其中第二个union的select_type就是DEPENDENT UNION。第一个子查询的select_type则是DEPENDENT SUBQUERY。
`explain select * from t_order where order_id in (select order_id from t_order where order_id=100 union select order_id from t_order where order_id=200); `

 | id  |  select_type | table | type  |  possible_keys  | key |  key_len  |  ref  | row  | Extra | 
 | :-:  | :-: |  :-: |  :-:  | :-: |  :-: |  :-:  | :-: |  :-: | :-: |
 | 1 | PRIMARY            | t_order    | ALL   | NULL          | NULL    | NULL    | NULL  | 100453 | Using where | 
 | 2 | DEPENDENT SUBQUERY | t_order    | const | PRIMARY       | PRIMARY | 4       | const |      1 | Using index | 
 |  3 | DEPENDENT UNION    | t_order    | const | PRIMARY       | PRIMARY | 4       | const |      1 | Using index | 
 | NULL | UNION RESULT       | <union2,3> | ALL   | NULL          | NULL    | NULL    | NULL  |   NULL |   NULL  | 
 
 3. SUBQUERY
子查询中的第一个select其select_type为SUBQUERY
`explain select * from t_order where order_id=(select order_id from t_order where order_id=100); `

 | id  |  select_type | table | type  |  possible_keys  | key |  key_len  |  ref  | row  | Extra | 
 | :-:  | :-: |  :-: |  :-:  | :-: |  :-: |  :-:  | :-: |  :-: | :-: |
 |  1 | PRIMARY     | t_order | const | PRIMARY       | PRIMARY | 4       | const |    1 |             | 
 | 2 | SUBQUERY    | t_order | const | PRIMARY       | PRIMARY | 4       |       |    1 | Using index | 
 
 4. DERIVED
当子查询是from子句时，其select_type为DERIVED。
` explain select * from (select order_id from t_order where order_id=100) as A; `

 | id  |  select_type | table | type  |  possible_keys  | key |  key_len  |  ref  | row  | Extra | 
 | :-:  | :-: |  :-: |  :-:  | :-: |  :-: |  :-:  | :-: |  :-: | :-: |
 | 1 | PRIMARY     | &lt;derived2> | system | NULL          | NULL      | NULL    | NULL |    1 |                    | 
 | 2 | DERIVED     | t_order           | const   | PRIMARY    | PRIMARY | 4          |          |    1 | Using index | 
 
 ## type
 1. system，const
见上面4.DERIVED的例子。其中第一行的type就是为system，第二行是const，这两种联接类型是最快的。

2. eq_ref
在t_order表中的order_id是主键，t_order_ext表中的order_id也是主键，该表可以认为是订单表的补充信息表，他们的关系是1对1，在下面的例子中可以看到b表的连接类型是eq_ref，这是极快的联接类型。
` explain select * from t_order a,t_order_ext b where a.order_id=b.order_id; `

 | id  |  select_type | table | type  |  possible_keys  | key |  key_len  |  ref  | row  | Extra | 
  | :-:  | :-: |  :-: |  :-:  | :-: |  :-: |  :-:  | :-: |  :-: | :-: |
 | 1 | SIMPLE      | b     | ALL    | order_id         | NULL       | NULL    | NULL            |    1 |             | 
 | 1 | SIMPLE      | a     | eq_ref | PRIMARY       | PRIMARY | 4       | test.b.order_id |    1 | Using where |
 
3. ref
在上面的sql加上条件order_id=100,所有与a表中order_id=100的匹配记录都将会从b表获取。
`explain select * from t_order a,t_order_ext b where a.order_id=b.order_id and a.order_id=100`

 | id  |  select_type | table | type  |  possible_keys  | key |  key_len  |  ref  | row  | Extra | 
  | :-:  | :-: |  :-: |  :-:  | :-: |  :-: |  :-:  | :-: |  :-: | :-: |
 | 1 | SIMPLE      | a     | const | PRIMARY       | PRIMARY  | 4       | const |    1 |       | 
 | 1 | SIMPLE      | b     | ref   | order_id      | order_id | 4       | const |    1 |       | 
 
 4. ref_or_null
user_id字段是一个可以为空的字段，并对该字段创建了一个索引。在下面的查询中可以看到联接类型为ref_or_null，这是mysql为含有null的字段专门做的处理。在我们的表设计中应当尽量避免索引字段为NULL，因为这会额外的耗费mysql的处理时间来做优化。
`explain select * from t_order where user_id=100 or user_id is null;`

 | id  |  select_type | table | type  |  possible_keys  | key |  key_len  |  ref  | row  | Extra | 
 | :-:  | :-: |  :-: |  :-:  | :-: |  :-: |  :-:  | :-: |  :-: | :-: |
 | 1 | SIMPLE      | t_order | ref_or_null | user_id       | user_id | 5       | const | 50325 | Using where | 

5. index_merge
经常出现在使用一张表中的多个索引时。mysql会将多个索引合并在一起，
` explain select * from t_order where order_id=100 or user_id=10; `

 | id  |  select_type | table | type  |  possible_keys  | key |  key_len  |  ref  | row  | Extra | 
 | :-:  | :-: |  :-: |  :-:  | :-: |  :-: |  :-:  | :-: |  :-: | :-: |
 | 1 | SIMPLE      | t_order | index_merge | PRIMARY,user_id | PRIMARY,user_id | 4,5     | NULL |    2 | Using union(PRIMARY,user_id); Using where |
 
 6. unique_subquery
该联接类型用于替换value IN (SELECT primary_key FROM single_table WHERE some_expr)这样的子查询的ref。注意ref列，其中第二行显示的是func，表明unique_subquery是一个函数，而不是一个普通的ref。
 `explain select * from t_order where order_id in (select order_id from t_order where user_id=10);`
 
 | id  |  select_type | table | type  |  possible_keys  | key |  key_len  |  ref  | row  | Extra | 
 | :-:  | :-: |  :-: |  :-:  | :-: |  :-: |  :-:  | :-: |  :-: | :-: |
 | 1 | PRIMARY            | t_order | ALL             | NULL            | NULL    | NULL    | NULL | 100649 | Using where | 
 |  2 | DEPENDENT SUBQUERY | t_order | unique_subquery | PRIMARY,user_id | PRIMARY | 4       | func |      1 | Using where|
 
7. index_subquery
和 unique_subquery 类型，唯一的差别就是子查询查的不是主键而是非唯一索引 
 `explain select * from t_order where user_id in (select user_id from t_order where order_id>10)`
 
 | id  |  select_type | table | type  |  possible_keys  | key |  key_len  |  ref  | row  | Extra | 
 | :-:  | :-: |  :-: |  :-:  | :-: |  :-: |  :-:  | :-: |  :-: | :-: |
 | 1  | PRIMARY            | t_order | ALL            | NULL            | NULL    | NULL    | NULL | 100649 | Using where              | 
|  2 | DEPENDENT SUBQUERY | t_order | index_subquery | PRIMARY,user_id | user_id | 5       | func |  50324 | Using index; Using where | 
 
8. range
按指定的范围进行检索
 ` explain select * from t_order where user_id in (100,200,300)`
 
 | id  |  select_type | table | type  |  possible_keys  | key |  key_len  |  ref  | row  | Extra | 
 | :-:  | :-: |  :-: |  :-:  | :-: |  :-: |  :-:  | :-: |  :-: | :-: |
 | 1 | SIMPLE      | t_order | range | user_id       | user_id | 5       | NULL |    3 | Using where | 
 
9. index
在进行统计时非常常见，此联接类型实际上会扫描索引树，仅比ALL快些。
 `explain select count(*) from t_order`
 
 | id  |  select_type | table | type  |  possible_keys  | key |  key_len  |  ref  | row  | Extra | 
 | :-:  | :-: |  :-: |  :-:  | :-: |  :-: |  :-:  | :-: |  :-: | :-: |
 | 1 | SIMPLE      | t_order | index | NULL          | user_id | 5       | NULL | 100649 | Using index | 
 
10. ALL
 完整的扫描全表，最慢的联接类型，尽可能的避免。
 `explain select count(*) from t_order`
 
 | id  |  select_type | table | type  |  possible_keys  | key |  key_len  |  ref  | row  | Extra | 
 | :-:  | :-: |  :-: |  :-:  | :-: |  :-: |  :-:  | :-: |  :-: | :-: |
 | 1 | SIMPLE      | t_order | ALL  | NULL          | NULL | NULL    | NULL | 100649 |       | 
 
 
 ## extra
 1. Distinct
MySQL发现第1个匹配行后,停止为当前的行组合搜索更多的行。暂无demo.

2. Not exists
因为b表中的order_id是主键，不可能为NULL，所以mysql在用a表的order_id扫描t_order表，并查找b表的行时，如果在b表发现一个匹配的行就不再继续扫描b了，因为b表中的order_id字段不可能为NULL。这样避免了对b表的多次扫描。
` explain select count(1) from t_order a left join t_order_ext b on a.order_id=b.order_id where b.order_id is null;`

 | id  |  select_type | table | type  |  possible_keys  | key |  key_len  |  ref  | row  | Extra | 
 | :-:  | :-: |  :-: |  :-:  | :-: |  :-: |  :-:  | :-: |  :-: | :-: |
 | 1 | SIMPLE      | a     | index | NULL          | express_type | 1       | NULL            | 100395 | Using index                          | 
|  1 | SIMPLE      | b     | ref   | order_id      | order_id     | 4       | test.a.order_id |      1 | Using where; Using index; Not exists| 


3. Range checked for each record
这种情况是mysql没有发现好的索引可用，速度比没有索引要快得多。
`explain select * from t_order t, t_order_ext s where s.order_id>=t.order_id and s.order_id<=t.order_id and t.express_type>5; `

 | id  |  select_type | table | type  |  possible_keys  | key |  key_len  |  ref  | row  | Extra | 
 | :-:  | :-: |  :-: |  :-:  | :-: |  :-: |  :-:  | :-: |  :-: | :-: |
 |1 | SIMPLE      | t     | range | PRIMARY,express_type | express_type | 1       | NULL |    1 | Using where  | 
|  1 | SIMPLE      | s     | ALL   | order_id             | NULL         | NULL    | NULL |    1 | Range checked for each record (index map: 0x1) | 
 
4. Using filesort 
在有排序子句的情况下很常见的一种情况。此时mysql会根据联接类型浏览所有符合条件的记录，并保存排序关键字和行指针，然后排序关键字并按顺序检索行。
 ` explain select * from t_order order by express_type; `
 
 | id  |  select_type | table | type  |  possible_keys  | key |  key_len  |  ref  | row  | Extra | 
 | :-:  | :-: |  :-: |  :-:  | :-: |  :-: |  :-:  | :-: |  :-: | :-: |
 | 1 | SIMPLE      | t_order | ALL  | NULL          | NULL | NULL    | NULL | 100395 | Using filesort | 
 
 5. Using index
 这是性能很高的一种情况。当查询所需的数据可以直接从索引树中检索到时，就会出现。(例子找上面)
 
 
 6. Using temporary
 发生这种情况一般都是需要进行优化的。mysql需要创建一张临时表用来处理此类查询。
 `explain select * from t_order a left join t_order_ext b on a.order_id=b.order_id group by b.order_id; `
 
 | id  |  select_type | table | type  |  possible_keys  | key |  key_len  |  ref  | row  | Extra | 
 | :-:  | :-: |  :-: |  :-:  | :-: |  :-: |  :-:  | :-: |  :-: | :-: |
 | 1 | SIMPLE      | a     | ALL  | NULL   | NULL     | NULL    | NULL   | 100395 | Using temporary; Using filesort | 
 |  1 | SIMPLE      | b     | ref  | order_id      | order_id | 4       | test.a.order_id |      1 |                                 | 
 
 7. Using where
当有where子句时，extra都会有说明。


8. Using sort_union(...)/Using union(...)/Using intersect(...)
下面的例子中user_id是一个检索范围，此时mysql会使用sort_union函数来进行索引的合并。而当user_id是一个固定值时，请参看上面type说明5.index_merge的例子，此时会使用union函数进行索引合并。
 `explain select * from t_order where order_id=100 or user_id>10;`
 
 | id  |  select_type | table | type  |  possible_keys  | key |  key_len  |  ref  | row  | Extra | 
 | :-:  | :-: |  :-: |  :-:  | :-: |  :-: |  :-:  | :-: |  :-: | :-: |
 | 1 | SIMPLE      | t_order | index_merge | PRIMARY,user_id | user_id,PRIMARY | 5,4     | NULL |    2 | Using sort_union(user_id,PRIMARY); Using where |
 
    `explain select * from t_order where express_type=1 and user_id=100; `
    
 | id  |  select_type | table | type  |  possible_keys  | key |  key_len  |  ref  | row  | Extra | 
 | :-:  | :-: |  :-: |  :-:  | :-: |  :-: |  :-:  | :-: |  :-: | :-: |
 | 1 | SIMPLE      | t_order | index_merge | user_id,express_type | user_id,express_type | 5,1     | NULL |    1 | Using intersect(user_id,express_type); Using where | 
 
 9.  Using index for group-by
 表明可以在索引中找到分组所需的所有数据，不需要查询实际的表。
 `explain select user_id from t_order group by user_id; `
 
 | id  |  select_type | table | type  |  possible_keys  | key |  key_len  |  ref  | row  | Extra | 
 | :-:  | :-: |  :-: |  :-:  | :-: |  :-: |  :-:  | :-: |  :-: | :-: |
 |  1 | SIMPLE      | t_order | range | NULL          | user_id | 5       | NULL |    3 | Using index for group-by | 
 


