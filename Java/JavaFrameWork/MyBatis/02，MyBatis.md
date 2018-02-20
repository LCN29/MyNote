# 02，MyBatis

## MyBatis介绍
1. 本是apache的一个开源项目iBatis，后来改名为MyBatis，实质上Mybatis对ibatis进行一些改进。 

2. 是一个持久层框架,它对jdbc的操作数据库的过程进行封装，使开发者只需要关注 SQL 本身，而不需要花费精力去处理例如注册驱动、创建connection、创建statement、手动设置参数、结果集检索等jdbc繁杂的过程代码,通过mybatis的映射方式，自由灵活（半自动化，大部分需要程序员编写sql）的生成满足的sql语句。
 
3. 通过xml或注解的方式将要执行的各种statement（statement、preparedStatemnt、CallableStatement）配置起来，并通过java对象和statement中的sql进行映射生成最终执行的sql语句`(输入映射)`，最后由mybatis框架执行sql并将结果映射成java对象并返回`(输出映射)`。

## MyBatis的结构
![Alt MyBatisStruction](https://github.com/LCN29/MyNote/blob/picture-branch/Picture/Java/JavaFrameWork/MyBatisStruction.png?raw=true '鼠标覆盖标题')

1. SqlMapConfig.xml（mybatis的全局配置文件，名称不是唯一的）
  >配置了数据源，事务等mybatis的运行环境
  >配置了映射文件（配置了sql语句）`mapper.xml（映射文件,重点）`。
  
2. SqlSessionFactory（会话工厂）根据配置文件，创建工厂
  >作用：创建SqlSession
  
3. SqlSession（会话）是一个接口，面向用户（程序员）的接口
  >作用:操作数据库（发送sql语句）

4. excutor（执行器），是一个接口（接口的2种实现方式：基本执行器，缓存执行器）
  >	将SqlSession内部通过执行器操作数据库

5. mapped statement（底层封装对象）
  >作用:对数据库存储封装，包括sql语句，`输入参数，输出结果类型`
  
## 开始使用
1. 在项目下新建一个 source folder, 名字为:config
2. 为了方便测试，可以将myBatis包含的log4j的包导入,用于测试 步骤：在config下新建一个log4j.properties,内容如下
  ```xml
    log4j.rootLogger=DEBUG, stdout
    log4j.appender.stdout=org.apache.log4j.ConsoleAppender
    log4j.appender.stdout.layout=org.apache.log4j.PatternLayout
    log4j.appender.stdout.layout.ConversionPattern=%5p [%t] - %m%n
  ```
  
    
3. 在config下新建一个SqlMapConfig.xml,内容如下
  ```xml
    <?xml version="1.0" encoding="UTF-8" ?>
    <!DOCTYPE configuration PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
          "http://mybatis.org/dtd/mybatis-3-config.dtd">
      <configuration>
        <environments default="development">
          <environment id="development">
            <!-- 使用jdbc事务管理-->
			      <transactionManager type="JDBC" />
            <!-- 数据库连接池-->
            <dataSource type="POOLED">
              <property name="driver" value="com.mysql.jdbc.Driver" />
	      <property name="url" value="jdbc:mysql://localhost:3306/javastudy?characterEncoding=utf-8" />
	      <property name="username" value="root" />
	      <property name="password" value="123456" />
            </dataSource>
          </environment>
        </environments>
      </configuration>      
  ```
  4. 在config下，再新建一个package 名字为 sqlmap
  5. 在sqlmap下，新建一个xml文件，名字最后为对应操作的表名,文件的初始内容如下
  ```xml
    <?xml version="1.0" encoding="UTF-8" ?>
    <!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
    "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
      
      <!--
        namespace: 命名空间，此处自定义 
        作用: 将sql分类化管理（也就是将sql隔离开来）以后，如果使用mapper代理的方式开发，namespace将有特殊的作用
      -->
      <mapper namespace="user">
         <!--
          select: 执行查询sql语句的标签 
          
          id: statement的id  标识映射文件中的sql语句(通过id,可以查询到这条sql语句)
          
          parameterType: 指定输入参数类型(也就是sql语句中将要取代？的那个参数)
          
          resultType: 指定sql输出的结果的类型，指定为所映射的java对象类型(User这个类需要和查询出来的数据一一对应，属性对应列名)，既返回了这个对象
          
          #{id}: #{} 相当于占位符，
                  里面的id: 参数 ，既传给sql语句的参数，如果输入的参数是简单的数据类型，名字是随意的
          
         -->
        <select id="findUserById" parameterType="int" resultType="com.exampel.po.User">
          SELECT * FROM USER WHERE id=#{id}
        </select>
      </mapper>    
  ```
  
6. 将这个user.xml注册到SqlMapConfig.xml中 在和environments同级下，建立mappers
```xml
  <environments>
    ....
  </environments>
  
  <!-- 加载映射文件 -->
  <mappers>
    <!-- resource的内容为 sqlmap包下的xml文件 -->
    <mapper resource="sqlmap/User.xml"/>
  </mappers>
```
  
7. 配置完了，开始使用，首先新建一个和上面 resultType 路径一致的po(javabean)对象User，属性名和表名要一致

8. 新建一个类，开始使用
  ```java
      public void findUserByIdTest() throws IOException{
        //找到全局配置文件
        String resource = "SqlMapConfig.xml";
        //将文件转为流 (Resources使用的是org.apache.ibatis.io.Resources)
        InputStream inputStream = Resources.getResourceAsStream(resource);
        //通过 SqlSessionFactoryBuilder.build(InputStrem strem) 获取sqlsesseionFactory
        SqlSessionFactory sqlSessionFactory= new SqlSessionFactoryBuilder().build(inputStream);
        //获取sqlSession 对象
        SqlSession sqlSession= sqlSessionFactory.openSession();
        
        //执行sql语句，并返回po结果
        // 参数1，命名空间.statement id 对应到 一开始sqlMap下的user.xml的Sql语句
        // 参数2， 传给sql语句的参数,注意参数类型(不一致，是不会报错的)
        User user=sqlSession.selectOne("user.findUserById", 1);
        //打印结果
        System.out.println(user.toString());
        //最后需要把连接关闭释放资源
	      sqlSession.close();
      }
  ``` 
  
## 使用加深
1. 例子1，通过用户名模糊查询一组用户
    在user.xml声明sql语句
```xml
  <!-- 改变1，输入的参数为字符串 属于完整的路径 java.lang.String  -->
  <!-- 提示2，查询完，返回的可能是一组用户，但是返回类型，还是User,不是list,需要修改 -->
  <!-- 改变3 sql语句没有使用#{参数}的占位符，而是了 ${}
        ${} 将接受到的内容不加任何修饰的拼接在sql中 如传入小明
        变成 SELECT * FROM USER WHERE USERNAME LIKE '%小明%'
        
        ${} 可能引起sql注入
        
        ${value} 如果传入的参数为简单数据类型，参数名只能为value
  -->
  <select id="findUsersByUserName" parameterType="java.lang.String" resultType="com.exampel.po.User">
	SELECT * FROM USER WHERE USERNAME LIKE '%${value}%'
  </select>
```

  使用
  
  ```java
    //查询一组的话，不用selectOne，而是selectList,会返回一个List对象
    List<User> list= sqlSession.selectList("user.findUsersByUserName", "小明");
    System.out.print(list.size());
  ```
  
2. 添加用户，同时返回其id（可以用于生成其他表）
  ```xml
  
  <!--
    当参数比较多时，可以传入一个pojo类型，如下的User,
    #{} 只需要指定pojo的属性名,就可以了
    数据库中，自增列，不需要写
    
    LAST_INSERT_ID():可以用于刚刚插入时，获取自增列的id,不是自增的没有
    keyProperty: 将查询到的主键设置到parameterType对象中的哪个属性
    order: 相对于外层的sql语句的执行顺序
    
    不是自增序列的话，可以通过mysql的uuid进行解决
    首先po的id字段应该为String，不能是int,(uuid()的返回值就是String),
    同时数据库中的id的长度为35位(char(35)
    然后在插入之前，先通过uuid()获取到主键，赋给po对象
    最后在执行po对象的插入 具体做法和自增的类似
    
    
    还有注意此处是插入，使用的标签为insert了，不是select
  -->
    <insert id="addUser" parameterType="com.exampel.po.User">
      <selectKey keyProperty="id" order="AFTER" resultType="java.lang.Integer">
	SELECT LAST_INSERT_ID()
      </selectKey>
	insert into user(username,birthday,sex,address) value(#{username},#{birthday},#{sex},#{address})
    </insert>
  ```
  
   使用
  
  ```java
    //创建对象
    User user= new User();
    user.setUsername("李星云");
    user.setAddress("西藏拉萨");
    user.setSex("男");
    user.setBirthday(new Date());
    
    //调用insert方法
    sqlSession.insert("user.addUser", user);
    //提交事务
		sqlSession.commit();
    //释放资源
    sqlSession.close();
    
    System.out.println(user.getId());
    
  ``` 
  
  3. 当查询结果的列名和po的属性名不一致是
  
  ```xml
    <select id="findUserList" parameterType="com.exampel.po.User" resultType="com.exampel.po.User">
	SELECT id _id,username _username,sex _sex,address FROM user WHERE user.sex=# {sex}
    </select>
  
  <!--
    给列起了别名，查询出来的列将是 _id,_username,address
    和user类对应的只有address，所以最终的结果为，数据库查询出来有多少个
    那么结果的List的size就是几个,里面的item，对不上列名的，要么等于null,
    要么就是默认值(int 默认值为0)，所以上面查询出来的List<User>的item只有
    address有值。
    当查询出来的列和user类的属性名，一个都对不上是，List<User>的结果将是null
  -->
  ```
  
解决可以使用resultMap解决，过程如下
  ```xml
  
  <!-- 首先定义resultMap-->
  
  <!-- 
	type: resultMap 最终对应的java对象
	id：唯一标示这个resultMap的名字
 -->
  <resultMap type="com.exampel.po.User" id="userResultMap">
	  <!-- 
		此处的id为列的唯一标识，主键
		column: 查询出来的列名
		property: 对应的java对象的属性
		最终,resultMap会将column和property进行映射 
	 -->
		<id column="_id" property="id" />
    <!-- 
	result 普通列的名称映射
	column 和property 作用和上面一样
    -->
	<result column="_username" property="username"/>
	<result column="_sex" property="sex" />
  </resultMap>
  
  
  
  <!-- 返回一个resultMap  resultMap和select同级-->
  <!-- resultMap的值就是对应的resultMap标签的id值
    如果这个resultMap在其他的文件里面，前面需要加上对应的命名空间
  -->
	<select id="findUserListResultMap" parameterType="com.exampel.po.User" resultMap="userResultMap">
		SELECT id _id,username _username,sex _sex, address FROM user WHERE user.sex=#{userCustom.sex} AND user.address LIKE '%${address}%'
	</select>
  
  ```
  
  <font color="red">使用和普通的使用一样</font>
  
  
  
  4. 根据id删除用户
  ```xml
  <delete id="deleteUser" parameterType="java.lang.Integer" >
		DELETE FROM USER WHERE id=#{id}
	</delete>
  ```
    
   使用
  
  ```java
    int id= 28;
		sqlSession.delete("user.deleteUser", id);
		//提交事务
		sqlSession.commit();
		sqlSession.close();
  ```
  
  5. 根据id更新用户
  ```xml
    <update id="updateUser" parameterType="com.exampel.po.User">
      UPDATE USER SET username=#{username},birthday=#{birthday},sex=#{sex},address=#      {address} WHERE id=#{id}
    </update>
  ```
  
      
   使用
  
  ```java
    User user= new User();
		user.setId(1);
		user.setUsername("王老五");
		user.setAddress("黑龙江哈尔滨");
		user.setSex("男");
		user.setBirthday(new Date());
		
		sqlSession.update("user.updateUser", user);
		
		//提交事务
		sqlSession.commit();
		sqlSession.close();
  
  ```
  
  ## 总结
  1. #{}, ${}接受的类型可以为： 简单类型，pojo,hashmap
  2. 接收pojo对象时,通过OGNL读取属性 如对象里面又有一个对象User的属性也有一个User,通过属性.属性获取值 #{user.user.id}。
  3. ${}的简单类型的参数只能value
