# 第一


## 表结构
列名 |  意义 | 类型
| - | :--: |-----:|
user_id | 用户id | int
user_name | 用户名 | varchar
password   | 密码 | varchar
email	 | 邮箱	| varchar	
register_date | 注册时间 | date
enable	| 用户账号是否可以用 | tinyint

## 注册
因为我最近在做一个网站，刚好做了一个注册功能，所以这个我就不写了，你们到这里体验一下：[网址](http://112.74.180.179/)。

## 登录

>1 UI界面
![UI界面](https://lcn-public.oss-cn-shenzhen.aliyuncs.com/18-7-27/88765338.jpg)

>2 流程图
![流程图](https://lcn-public.oss-cn-shenzhen.aliyuncs.com/18-7-27/18088755.jpg)


# 第二
## 表结构

>1. 用户表

列名 | 类型
| - | :-: |
用户id | int
用户名 | varchar
邮箱		| varchar	
联系电话 | varchar
所属公司 | varchar

>2. 产品表

列名 | 类型
| - | :-: |
产品id   | int
产品名   | varchar
图片		| varchar	
组成 	| varchar

>3. 订单表

列名 | 类型
| - | :-: |
订单id | int
产品id | int
花号   | varchar
底标  | varchar
数量  | int
白胎级别 | varchar
包装方式 | varchar
数量 | varchar
备注 | varchar
样品单id | int

>4. 样品单表

列名 | 类型
| - | :-: |
样品单id | int
样品单名 | varchar
下单用户id | int
接单用户id |	 int
下单时间 | date
交单时间 | date
备注     | varchar
注意事项 | varchar

## 类

>1. 用户类
```java
/**
 * @description: 用户信息
 * @author: LCN
 * @date: 2018-07-27 13:45
 */

@Data
@NoArgsConstructor
public class User {
	private int userId;
	private String userName;
	private String email;
	private String phone;
	private String company;
}
```

>2. 产品信息
```java
/**
 * @description: 产品信息
 * @author: LCN
 * @date: 2018-07-27 13:48
 */
@Data
@NoArgsConstructor
public class Produce {

	private int produceId;
	private String produceName;
	private String produceImg;
	private String produceDetail;
}
```

>3. 订单信息
```java
/**
 * @description: 订单信息
 * @author: LCN
 * @date: 2018-07-27 13:51
 */
@Data
@NoArgsConstructor
public class Order {

	private int orderId;
	private int produceId;
	private String designNumber;
	private String backStamp;
	private int amount;
	private String whiteLevel;
	private String packingType;
	private String remark;
	private String notice;
}
```

>4. 样品单
```java
/**
 * @description: 样品单信息
 * @author: LCN
 * @date: 2018-07-27 14:29
 */
@Data
@NoArgsConstructor
public class StampOrder {
	private int stampOrderId;
	private String stampOrderName;
	private User fromUser;
	private User toUser;
	private List<Order> orderList;
	private Date orderTime;
	private Date presentationTime;
	private String remarek;
	private String notice;
}

```

