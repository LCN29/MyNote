# 索引

### 数据库中的key和index
key是数据库的物理结构，它包含两层意义和作用，一是约束(偏重于约束和规范数据库的结构完整性),二是索引(辅助查询用的),既index。
如primary key 有两个作用，一是约束作用(constraint),用来规范一个存储主键和唯一性,但同时也在此key上建立了一个主键索引。其他的类似的unique key类似。所以在建立表时，在声明的key也会自动生成对应的索引。
如果`create table `table` ( ...,  key '索引名'('列名'))`,此处的只要一个key就是只要一种作用索引，既这里可以用index代替。


### 查询表的索引
`select index from 表名;` --->可以发现主键等都是索引。



### 普通索引
```sql
	# 创建 
	CREATE INDEX 索引名 ON 表名 (列名, 列名)

	# 删除
	DROP INDEX 表名.索引名
```

### 唯一索引 和 主键索引
(1) 唯一索引不允许两行具有相同的索引值，列允许为null, 一张表中可以有多个
(2) 主键索引是唯一索引的特殊类型, 列不允许为null, 同时一张表中有只能有一个


### 聚集索引




### 非聚集索引




##### 复合索引
假设现在有复合索引 (userName, registData) userName在registData之前。
1. `select * from t_u_userinfo where userName = 'aaa'`;

2. `select * from t_u_userinfo where userName = 'aaa' and registData > '2019-10-10'`;

3. `select * from t_u_userinfo where registDate > '2019-10-10'`;

4. `select * from t_u_userinfo where registData > '2019-10-10 and userName = 'aaa'`;

在上面的4个sql中,只要1,2会索引才会起作用,3,4不会，因为复合索引的会按照建立的顺序起作用，如果查询的条件顺序不一致，索引将不起作用。


##### 会使索引失效的情况
>1. `%` 
(1) like '%张'  会使索引失效     (2) like `张%` 则不会
>2. or 会引起全表扫描
>3. 非操作符  NOT、!=、<>、!<、!>、NOT EXISTS、NOT IN、NOT LIKE等
>4. in 相当于 or  都会引起全表扫描
>5. 
