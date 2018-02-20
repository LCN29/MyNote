# 01，传统的jdbc使用上有什么问题

## 传统的jdbc操作数据库代码
```java
   	Connection connection = null;
		
	//预编译的statement  好处：用过一次的sql语句会存在内存中，下次使用时，可以直接使用，不需要在编译了

	PreparedStatement preparedStatement = null;
	//结果集
	ResultSet resultSet = null;

	try {
		//加载数据库驱动
		Class.forName("com.mysql.jdbc.Driver");
		connection =  DriverManager.getConnection("jdbc:mysql://localhost:3306/javastudy?characterEncoding=utf-8", "root", "123456");

		//定义sql语句 ?表示占位符
		String sql = "select * from user where username = ?";
		//获取预处理statement
		preparedStatement = connection.prepareStatement(sql);
		//设置参数，第一个参数为sql语句中参数的序号（从1开始），第二个参数为设置的参数值
		preparedStatement.setString(1, "王五");

		//向数据库发出sql执行查询，查询出结果集
		resultSet =  preparedStatement.executeQuery();

		//遍历查询结果集
		while(resultSet.next()){
			System.out.println(resultSet.getString("id")+"  "+resultSet.getString("username"));
		}

	}catch(Exception e){
		e.printStackTrace();
	}finally{

		//释放资源
		if(resultSet!=null){
			try {
				resultSet.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}

		if(preparedStatement!=null){
			try {
				preparedStatement.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}

		if(connection!=null){
			try {
				connection.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}

	}
	}
```

## 问题总结


1. 数据库连接，需要时连接，不需要释放，对数据库频繁的连接开启和释放造成数据库资源的浪费，影响数据库的性能

`解决: 使用数据库连接池`
  
```java
  //连接
connection=DriverManager.getConnection("jdbc:mysql://localhost:3306/数据库", "用户名", "密码");

  //中间操作...

  //释放资源
if(connection!=null){
  try {
    connection.close();
  } catch (SQLException e) {
  e.printStackTrace();
  }
}
```


2. 把sql语句硬编码到java代码中，如果sql语句修改，需要重新编译java代码，不利于维护
`解决: 将sql语句配置在xml配置文件中，即使sql变化，也不需要重新编译java代码`

```java
  //定义sql语句 ?表示占位符
  String sql = "select * from user where username = ?";
```




3. 向preparedStatement 设置参数，对占位符的位置和设置的参数，也是硬编码在java代码中
`解决: 将sql语句和占位符和参数全部配置在xml中`

```java
  preparedStatement.setString(1, "王五");
```




4. 从resultReset中遍历结果集时，存在硬编码，将需要获取的表的参数写死了，解决，
`解决: 将查询的结果，映射成java对象`
  
  ```java
    resultSet.getString("id")
  ```
