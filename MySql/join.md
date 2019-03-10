# join 数据库联表

>1. left join --->返回包括左表中的所有记录和右表中联结字段相等的记录
>2. right join ---> 返回包括右表中的所有记录和左表中联结字段相等的记录
>3. inner join ---> 只返回两个表中联结字段相等的行

### 使用
`select * from 表名  left/right/inner join 表名 on 表名.字段 = 表名.字段`
on 是必填字段，用于判断表之间如何连接


### 2张表
表A
  AId  |  ANum
  | - | :-: |
  1  | a20050111
  2 | a20050112
  5 | a20050115
  
  表B
  BId  |  BNum
  | - | :-: |
  1  | 2006032401
  2 | 2006032402
  8 | 2006032408
  
  


### left join

`select * from A left join B on A.AId = B.BId`;
结果如下:
  AId  |  ANum |   BId  |  BNum 
 |:------------- |:-------------:| :-------------:| -----:|
   1  | a20050111 |   1  | 2006032401
   2 | a20050112 |   2 | 2006032402
   5 | a20050115 | NULL | NULL
   
 结果说明
left join是以A表的记录为基础的,A可以看成左表,B可以看成右表,left join是以左表为准的.
换句话说,左表(A)的记录将会全部表示出来,而右表(B)只会显示符合搜索条件的记录(例子中为: A.aID = B.bID).
B表记录不足的地方均为NULL.


### right join
   
`select * from A right join B on A.AId = B.BId`;   
结果如下:
  AId  |  ANum |   BId  |  BNum 
 |:------------- |:-------------:| :-------------:| -----:|
   1  | a20050111 |   1  | 2006032401
   2 | a20050112 |   2 | 2006032402
   NULL | NULL | 8 | 2006032408
  
  结果说明
  right join 是B表的记录为基础的,A可以看成左表,B可以看成右表,right join是以右表为准的.
换句话说,右表(B)的记录将会全部表示出来,而左表(A)只会显示符合搜索条件的记录(例子中为: A.aID = B.bID).
A表记录不足的地方均为NULL.


### inner join 

`select * from A inner join B on A.AId = B.BId`
结果如下:
  AId  |  ANum |   BId  |  BNum 
 |:------------- |:-------------:| :-------------:| -----:|
   1  | a20050111 |   1  | 2006032401
   2 | a20050112 |   2 | 2006032402
 
结果说明
inner join并不以谁为基础,它只显示符合条件的记录


### 多条件
`select * from A left join B on A.AId = B.Bid And A.ANum = 2006032401`
匹配的条件有多个时, 条件之间用and 进行连接，但是在 on 里面的条件，不会对结果进行筛选， 如left join 是以左表为主,没有 A.ANum = 2006032401 条件时，查询出来了3个，现在加上了这个条件，还是3个，但是除了符合条件的一条，其他2条中B表的信息都为NULL


### 多表
`select * from A left join B on A.条件 = B.条件 left join C on A/B.条件 = C.条件`
