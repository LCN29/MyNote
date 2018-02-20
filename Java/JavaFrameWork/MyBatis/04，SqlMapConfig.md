# 04，SqlMapConfig.xml

## 配置内容和顺序

### properties（属性）
加载其他的.properties文件,例如数据库的配置文件db.properties
```xml
    <!-- 和environments同级 -->
    <properties resource="db.properties"></properties>
```      
 里面参数的获取可以这样 ${jdbc.driver} 获取到db.properties里面的
 jdbc.driver=com.mysql.jdbc.Driver的值
 
 properties里面还可以声明自己的属性
 ```xml
  <properties resource="db.properties">
    <property name="key" value="value" />
  </properties>
 ```
 读取顺序
  >	在 properties 元素体内定义的属性首先被读取。
  >	然后会读取properties 元素中resource或 url 加载的属性，它会覆盖已读取的同名属性。
  >	最后读取parameterType传递的属性，它会覆盖已读取的同名属性。

 使用
 >建议不要在properties里面定义property
 >properties加载的资源，命名尽量有一些特殊含义，例如xxx.xxx.xx  
 
 ### settings(全局的配置参数)
 可以调整myBatis运行时的一些参数，如二级缓存，延迟加载（需要时在设置，设置错了，可能会出问题）
 参数:
 ![Alt 'settings参数'](https://github.com/LCN29/MyNote/blob/picture-branch/Picture/Java/JavaFrameWork/MyBatis-settings01.png?raw=true)
 ![Alt 'settings参数'](https://github.com/LCN29/MyNote/blob/picture-branch/Picture/Java/JavaFrameWork/MyBatis-settings02.png?raw=true)
 ![Alt 'settings参数'](https://github.com/LCN29/MyNote/blob/picture-branch/Picture/Java/JavaFrameWork/MyBatis-settings03.png?raw=true)
 
 ### typeAliases(别名)
 在mapper.xml中，parameterType,resultType都需要我们知道相对应的类型，但是这些类型有的会很长，所以可以给这些类型起个别名，将parameterType或者resultType的类型指定为别名。
 
 **官方内置好的别名**
 
 别名  |  映射类型
 | - | :-: |
_byte|byte 
_long|long 
_short|short 
_int|int 
_integer|int 
_double|double 
_float|float 
_boolean|boolean 
string|String 
byte|Byte 
long|Long 
short|Short 
int|Integer 
integer|Integer 
double|Double 
float|Float 
boolean|Boolean 
date|Date 
decimal|BigDecimal 
bigdecimal|BigDecimal 

**自定义别名**

```xml
  <!-- 和environment同级 -->
  <typeAliases>
    <!--单个别名的定义 使用时 parameterType="user" -->
		<typeAlias type="com.exampel.po.User" alias="user"/>
    
    <!--批量导入 -->
    <!--myBatis会自动扫描定义的包里面的po, 对应的别名为 类名（首字母大小写都可以) -->
    <package name="com.exampel.po"/>
    <!--如果还有多个包的话,只需要在多打一次package，输入对应的包名就行了-->
    
  </typeAliases>
```

### typeHandlers（类型处理器）
用于java类型和jdbc类型的映射(数据库类型)，如java的String和数据库的varchar(20)映射等(一般不需要进行自定义)

**官方内置好的处理器**

类型处理器              |  Java类型              | JDBC类型
| ------------- |:-------------:| -----:|
BooleanTypeHandler      | Boolean，boolean      	     | 任何兼容的布尔值
ByteTypeHandler         |	Byte，byte            | 任何兼容的数字或字节类型
ShortTypeHandler        |	Short，short          | 任何兼容的数字或短整型
IntegerTypeHandler 	    | Integer，int          | 任何兼容的数字和整型
LongTypeHandler         |	Long，long            | 任何兼容的数字或长整型
FloatTypeHandler        |	Float，float          | 任何兼容的数字或单精度浮点型
DoubleTypeHandler 	    | Double，double        | 任何兼容的数字或双精度浮点型
BigDecimalTypeHandler   |	BigDecimal            |	任何兼容的数字或十进制小数类型
StringTypeHandler       |	String                |	CHAR和VARCHAR类型
ClobTypeHandler         | String                |	CLOB和LONGVARCHAR类型
NStringTypeHandler      |	String                |	NVARCHAR和NCHAR类型
NClobTypeHandler        | String                |	NCLOB类型
ByteArrayTypeHandler    | byte[]                |	任何兼容的字节流类型
BlobTypeHandler         |	byte[]                |	BLOB和LONGVARBINARY类型
DateTypeHandler         |	Date（java.util）     |	TIMESTAMP类型
DateOnlyTypeHandler     |	Date（java.util）     |	DATE类型
TimeOnlyTypeHandler     |	Date（java.util）     |	TIME类型
SqlTimestampTypeHandler |	Timestamp（java.sql） |	TIMESTAMP类型
SqlDateTypeHandler      | Date（java.sql）      |	DATE类型
SqlTimeTypeHandler      |	Time（java.sql）      |	TIME类型
ObjectTypeHandler       |	任意	                |其他或未指定类型
EnumTypeHandler         |	Enumeration类型       |	VARCHAR-任何兼容的字符串类型，作为代码存储（而不是索引）。

### mappers（映射器,映射配置）
加载mappper.xml

```xml
  <!--一次加载一个文件  -->
  
   <!--相对于类路径的资源  -->
	<mapper resource="mapper/UserMapper.xml"/>
   <!--完全限定路径 -->
  <mapper url="file:///D:\workspace_spingmvc\mybatis_01\config\sqlmap\User.xml" />
  
   <!-- mapper接口类路径  -->
   <!--使用要求
    1,使用的是mapper代理的方法
    2,接口和mapper.xml文件名字一致，同时在同一个目录下(既同一个包里面)
   -->
  <mapper class="cn.itcast.mybatis.mapper.UserMapper"/>
  
  
  <!--批量加载 -->
  <!-- name为mapper接口的包名
	使用要求
    	1,使用的是mapper代理的方法
    	2,接口和mapper.xml文件名字一致，同时在同一个目录下(既同一个包里面)
   -->
<package name="com.example.mapper"/>
  
  
```
