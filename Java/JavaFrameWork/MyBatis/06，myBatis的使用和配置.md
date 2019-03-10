# 06，myBatis的使用和配置

## 新建项目和环境配置
1. 新建一个source folder===>config
2. 新建一个日志输出配置文件 log4j.properties
  内容如下:
```xml
  log4j.rootLogger=DEBUG, stdout
  log4j.appender.stdout=org.apache.log4j.ConsoleAppender
  log4j.appender.stdout.layout=org.apache.log4j.PatternLayout
  log4j.appender.stdout.layout.ConversionPattern=%5p [%t] - %m%n
```
3. 新建数据库连接配置文件 db.properties
  内容如下:
```xml
  jdbc.driver=com.mysql.jdbc.Driver
  jdbc.url=jdbc:mysql://localhost:3306/javastudy?characterEncoding=utf-8
  jdbc.username=root
  jdbc.password=123456
```
4. 新建myBatis的全局配置文件 SqlMapConfig.xml
  内容如下
```xml
  <?xml version="1.0" encoding="UTF-8" ?>
  <!DOCTYPE configuration PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
  "http://mybatis.org/dtd/mybatis-3-config.dtd">
  <configuration>
    <!-- 引用数据库文件 db.properties -->
    <properties resource="db.properties"></properties>
    
     <!-- 环境配置 -->
    <environments default="development">
      <environment id="development">
        <transactionManager type="JDBC" />
        <dataSource type="POOLED">
          <property name="driver" value="${jdbc.driver}" />
          <property name="url" value="${jdbc.url}" />
          <property name="username" value="${jdbc.username}" />
          <property name="password" value="${jdbc.password}" />
        </dataSource>
      </environment>
    </environments>

  </configuration>
```
5. 使用代理的开发模式
  >新建对应的po对象包 com.example.po
  >新建对应的po类 
  >将对应的po对象包，注册到SqlMapConfig.xml，方便使用po对象时，不需要写完整的路径
  >内容如下
```xml

  <properties resource="db.properties"></properties>
  
  <!-- 别名 在properties的下面-->
  <typeAliases>
	<package name="com.example.po"/>
  </typeAliases>  
```
  >1,新建对应的map接口包 com.example.mapper
  >2,将这个包注册到sqlMapConfig.xml文件中，方便使用mapper.xml文件
  >内容如下
```xml
  <environments>
    ......
  </environments>
  
  <!-- 和environments同级 -->
  <mappers>
	<package name="com.example.mapper"/>
  </mappers>
```
  >3,在包下新建对应的mapper.xml文件(假设叫做 UserMapper.xml)
  >内容如下
```xml
  <?xml version="1.0" encoding="UTF-8" ?>
  <!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
  "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
  <!-- 此处的namespace 必须填写这个包下对应的 mapper接口文件 -->
  <mapper namespace="com.example.mapper.XXXXXXXXMapper">
  
    <select id="方法id" parameterType="输入映射的数据类型" resultType="输出映射的数据类型">
      对应的sql语句
    </select>
  </mapper>
```
  >4,在mapper接口包的下面新建对应的接口.java文件，注意类名必须和3中建立的mapper.xml的文件名一致(此处应该为 UserMapper.java)
  >UserMapper.java的内容如下
  
```java
  public interface UserMapper {
    // 方法名和对应的mapper.xml的SQL语句下的id名
    //返回值，考虑sql语句的查询结果
    public List<OrdersCustom> findsUser() throws Exception;
  }
```

  >5,开始使用
  
```java
  private SqlSessionFactory sqlSessionFactory;
  
  public 构造函数(){
     try {
	String file= "SqlMapConfig.xml";
	InputStream is = Resources.getResourceAsStream(file);
	sqlSessionFactory= new SqlSessionFactoryBuilder().build(is);
     } catch (IOException e) {
	e.printStackTrace();
     }
  }
  
  public void use(){
    SqlSession sqlSession= sqlSessionFactory.openSession();
    //根据接口，生成对应的代理类，用它来实现sql语句
    UserMapper mapper= sqlSession.getMapper(UserMapper.class);

    try {
	List<User> list= mapper.接口内的方法名();
	System.out.println(list.get(1).getUsername());
    } catch (Exception e) {
	e.printStackTrace();
    }
  }
  
```
