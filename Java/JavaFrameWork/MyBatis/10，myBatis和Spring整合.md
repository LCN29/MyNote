# 10，myBatis和Spring整合

## 实现
>需要Spring通过单例方式管理SqlSessionFactory
>持久层的mapper交给Spring管理
>生成代理对象，通过SqlSessionFactory创建SqlSession

## Maven依赖
```xml
<!-- mysql驱动 -->
<dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
</dependency>

<!-- mybatis-spring -->
<dependency>
    <groupId>org.mybatis</groupId>
    <artifactId>mybatis-spring</artifactId>
</dependency>

<!-- mybatis -->
<dependency>
    <groupId>org.mybatis</groupId>
    <artifactId>mybatis</artifactId>
</dependency>

<!-- druid连接池 -->
<dependency>
    <groupId>com.alibaba</groupId>
    <artifactId>druid</artifactId>
</dependency>

<!-- spring config -->
<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-context-support</artifactId>
</dependency>
<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-jdbc</artifactId>
</dependency>
<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-orm</artifactId>
</dependency>
```

## 项目结构
![Alt '项目结构'](https://github.com/LCN29/MyNote/blob/picture-branch/Picture/Java/JavaFrameWork/project-struction.png?raw=true)

## 配置
#### 1.日志文件log4j.properties
```xml
log4j.rootLogger=DEBUG, stdout
log4j.appender.stdout=org.apache.log4j.ConsoleAppender
log4j.appender.stdout.layout=org.apache.log4j.PatternLayout
log4j.appender.stdout.layout.ConversionPattern=%5p [%t] - %m%n
```

#### 2.数据库连接信息文件 db.properties
```xml
jdbc.url=jdbc:mysql://127.0.0.1:3306/rpc-db?useUnicode=true&amp;characterEncoding=utf-8&amp;zeroDateTimeBehavior=convertToNull&amp;transformedBitIsBoolean=true&amp;allowMultiQueries=true
jdbc.driver=com.mysql.jdbc.Driver
jdbc.username=root
jdbc.password=123456
jdbc.validationQuery=select 1 from dual
jdbc.removeAbandonedTimeout=180
jdbc.initialSize=10
jdbc.minIdle=30
jdbc.maxActive=100
jdbc.maxWait=30000
```
  
#### 3.二级缓存ehcache ehcache.xml
```xml
<ehcache xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xsi:noNamespaceSchemaLocation="../config/ehcache.xsd">

<diskStore path="F:\develop\ehcache" />
	<defaultCache 
		maxElementsInMemory="1000" 
		maxElementsOnDisk="10000000"
		eternal="false" 
		overflowToDisk="false" 
		timeToIdleSeconds="120"
		timeToLiveSeconds="120" 
		diskExpiryThreadIntervalSeconds="120"
		memoryStoreEvictionPolicy="LRU">
	</defaultCache>
</ehcache>
```

#### 4.myBatis的全局配置文件 SqlMapConfig.xml
```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE configuration PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
"http://mybatis.org/dtd/mybatis-3-config.dtd">

<configuration>

</configuration>
```

#### 5.Spring的配置文件 applicationContext.xml
```xml
  <beans xmlns="http://www.springframework.org/schema/beans"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:mvc="http://www.springframework.org/schema/mvc"
	xmlns:context="http://www.springframework.org/schema/context"
	xmlns:aop="http://www.springframework.org/schema/aop" xmlns:tx="http://www.springframework.org/schema/tx"
	xsi:schemaLocation="http://www.springframework.org/schema/beans 
		http://www.springframework.org/schema/beans/spring-beans-3.2.xsd 
		http://www.springframework.org/schema/mvc 
		http://www.springframework.org/schema/mvc/spring-mvc-3.2.xsd 
		http://www.springframework.org/schema/context 
		http://www.springframework.org/schema/context/spring-context-3.2.xsd 
		http://www.springframework.org/schema/aop 
		http://www.springframework.org/schema/aop/spring-aop-3.2.xsd 
		http://www.springframework.org/schema/tx 
		http://www.springframework.org/schema/tx/spring-tx-3.2.xsd ">
	
	<!-- 加载数据库配置文件 -->
	<context:property-placeholder location="classpath:db.properties"/>	
		
	<!-- 配置数据源 既数据库的连接池 -->	
	<bean id="dataSource" class="com.alibaba.druid.pool.DruidDataSource" init-method="init" destroy-method="close">
		<property name="driverClassName" value="${jdbc.driver}" />
		<property name="url" value="${jdbc.url}" />
		<property name="username" value="${jdbc.username}" />
		<property name="password" value="${jdbc.password}" />
	        <property name="maxActive" value="${jdbc.maxActive}" />
		<property name="initialSize" value="${jdbc.initialSize}" />
		<property name="removeAbandoned" value="true" />
		<property name="removeAbandonedTimeout" value="${jdbc.removeAbandonedTimeout}" />
		<property name="testOnBorrow" value="true" />
		<property name="minIdle" value="${jdbc.minIdle}" />
		<property name="maxWait" value="${jdbc.maxWait}" />
		<property name="validationQuery" value="${jdbc.validationQuery}" />
		<property name="connectionProperties" value="clientEncoding=UTF-8" />
	 </bean>
	
	<!-- 配置SqlSessionFatory -->	
	<bean id="sqlSessionFactory" class="org.mybatis.spring.SqlSessionFactoryBean">
		
    		<!-- 数据源  -->
		<property name="dataSource" ref="dataSource"></property>
    
    		<!-- 配置myBatis的配置文件 -->
		<property name="configLocation" value="classpath:mybatis/SqlMapConfig.xml"></property>
	</bean>		
		
</beans>
```

## 原始的dao开发模式（Spring整合开发）

#### 1.新建对应的mapper.xml文件(在cofig的下面新建一个资源包sqlmap，再其下面新建mapper.xml文件，此处命名为User.xml)

内容如下
```xml
  <?xml version="1.0" encoding="UTF-8" ?>
  <!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
  "http://mybatis.org/dtd/mybatis-3-mapper.dtd">

  <mapper namespace="user">

    <!-- 通过id查找用户 -->
    <select id="findUserById" parameterType="int" resultType="Users" >
      SELECT * FROM USERS WHERE id=#{id}
    </select>

  </mapper>
```
#### 2. 向sqlMapConfig.xml注册这个mapper.xml文件

```xml
<mappers>
	<mapper resource="sqlmap/User.xml"/>
</mappers>
```


#### 3.新建对应的dao包，在包下新建接口UserDao.java和实现类UserDaoImpl.java

UserDao.java的内容
```java
  public interface UserDao {

    //根据id查找用户
    public Users findUserById(int id) throws Exception;

  }
```

UserDaoImpl.java的内容
```java

  //继承 SqlSessionDaoSupport 可以不用创建sqlSessionFactory工厂
  public class UserDaoImpl extends SqlSessionDaoSupport implements UserDao{
	
	@Override
	public Users findUserById(int id) throws Exception {
		//继承了SqlSessionDaoSupport 可以通过getSqlSession()；获取到sqlSession
		SqlSession sqlSession= this.getSqlSession();
		Users user=sqlSession.selectOne("user.findUserById", id);
	   	System.out.print(user.toString());
		return user;
	}
}
```

#### 4.在spring的applicationContext.xml增加bean
内容如下

```java
  <!--原始的dao开发  -->
  <bean id="UserDao" class="com.example.ssm.dao.UserDaoImpl">
    <!-- ref表示参照上方的id为sqlSessionFactory的bean -->
    <property name="sqlSessionFactory" ref="sqlSessionFactory"></property>
  </bean>

```

#### 5.测试

```java
  
  String path= "classpath:spring/applicationContext.xml";
  //获取applicationContext对象
  ApplicationContext	applicationContext= new ClassPathXmlApplicationContext(path);
  //获取实现类 UserDao为applicationContext.xml 对应bean的id
  UserDao userDao= (UserDao) applicationContext.getBean("UserDao");
  
  Users user = null;
  try {
    user = userDao.findUserById(1);
  } catch (Exception e) {
    e.printStackTrace();
  }
  System.out.println(user.getUsername());
```

## 代理的开发模式

#### 1.在mapper包下创建对应的mapper.xml文件
内容如下
```xml
  <?xml version="1.0" encoding="UTF-8" ?>
  <!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
  "http://mybatis.org/dtd/mybatis-3-mapper.dtd">

  <mapper namespace="com.example.ssm.mapper.UserMapper">

    <select id="findUserById" parameterType="int" resultType="Users" >
      SELECT * FROM USERS WHERE id=#{id}
    </select>

  </mapper>
```

#### 2. 向sqlMapConfig.xml注册这个mapper.xml文件
```xml
  <mappers>
    <!-- 此处直接注册了整个包 -->
    <package name="com.example.ssm.mapper"/>
  </mappers>
```

#### 3. 创建对应的接口文件
内容如下
```java

  public interface UserMapper {
	  //根据id查找用户
	  public Users findUserById(int id) throws Exception;
  }

```

#### 4. 向applicationContext.xml注册这个bean
内容如下
```xml
  <!-- MapperFactoryBean 可以根据接口生成代理对象 -->
  <bean id="UserMapper" class="org.mybatis.spring.mapper.MapperFactoryBean">
	<!--指定接口 -->
	<property name="mapperInterface" value="com.example.ssm.mapper.UserMapper"></property>
	<!-- 配置sqlSessionFactory -->
	<property name="sqlSessionFactory" ref="sqlSessionFactory"></property>
  </bean> 
```

#### 5.测试

```java
  String path= "classpath:spring/applicationContext.xml";
  //获取applicationContext对象
  ApplicationContext	applicationContext= new ClassPathXmlApplicationContext(path);
  
  //获取实现类 UserDao为applicationContext.xml 对应bean的id
  UserMapper userMapper = (UserMapper) applicationContext.getBean("UserMapper");
  
  Users user = null;
  try {
    user = userDao.findUserById(1);
  } catch (Exception e) {
    e.printStackTrace();
  }
  System.out.println(user.getUsername());
```

## 代理方式（升级版）

#### 1.普通代理的问题
**一个接口就需要在applicationContext.xml声明一个对应的接口实现bean。如果以后业务多了，会有很多的bean对象**

#### 2.解决（使用mapper批量扫描）
**mapper批量扫描,从mapper包中扫描出mapper接口，自动创建代理对象并且在spring中注册**

#### 3.使用前提
>使用扫描器 需要mapper.java和mapper.xml的文件名一致，在同一个包中
>自动扫描出来的mapper的bean的id为mapper的类名(首字母小写)

#### 4.注册
```xml
  <bean class="org.mybatis.spring.mapper.MapperScannerConfigurer">
	<!--指定扫描的包名 ,如果需要扫描多个包，每个包之间以逗号隔开-->
	<property name="basePackage" value="com.example.ssm.mapper"/>

	<!-- 指定包中的sqlSessionFactory-->
	<property name="sqlSessionFactoryBeanName" value="sqlSessionFactory"/>
  </bean>
```

#### 5.使用和正常的代理一样（注意bean的类名为小写了就可以了）
