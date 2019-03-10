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

| Setting(设置)| Description(描述)| Vaild Values(有效值) | Default(默认值)|
| :-:| :- | :-:| :-: |
| cacheEnabled | 在全局范围内启用或禁用缓存配置, 任何映射器在此配置下 | true/false | true|
| 1azyLoadingEnabled| 在全局范围内启用或禁用延迟加载。禁用时,所有结果将热加载| true/false | true|
| aggressiveLazyLoading | 启用时, 有延迟加载属性的对象将被完全加载后, 调用懒惰的任何属性。 否则，每一个属性是按需加载| true/false | true|
| multipleResultSetsEnabled  | 允许或不允许从一个单独的语句(需要兼容的驱动程序)要返回多个结果集| true/false | true|
| useColumnLabel |使用列标签, 而不是列名。 在这方面, 不同的驱动有不同的行为。 参考驱动文档或测试两种方法来决定你的驱动程序的行为如何| true/false | true|
| useGeneratedKeys|允许JDBC支持生成的密钥。 兼容的驱动程序是必需的。 此设置强制生成的键被使用, 如果设置为true, —些驱动会不兼容性, 但仍然可以工作 | true/false | false|
| autoMappingBehavior | 指定MyBatis的应如何自动映射列到字段/厲性。 NONE自动映射。 PARTIAL只会
自动映射结果没有嵌套结果映射定义里面。 FULL会自动映射的结果映射任何复杂的(包含嵌套或其他)| NONE/PARTIAL/FULL| PARTIAL|
| defaultExecutorType |配置默认执行人。 SIMPLE执行人确实没有什么特别的。 REUSE执行器重用准备好的语句。 BATCH执行器重用语句和批处埋更新。 | SIMPLE/REUSE/BATCH|SIMPLE|
| defaultStatementTimeout | 设置驱动程序等待一个数据库响应的秒数。 | 任意一个有正的整型 | 没有设置 (null)|
| safeRovBoundsEnabled | 允许使用嵌套的语句RowBounds | true/false | false|
| mapUnderscoreToCamelCase | 从经典的数据库列名A_COLUMN启用自动映射到骆驼标识的经典的Java属
性名aColumn| true/false| false|
| localCacheScope | MyBatis的使用本地缓存, 以防止循坏引用, 并加快反复嵌套查询。 默认情況下(SESSION)会话期间执行的所有查询缓存。 如果localCacheScope=STATMENT本地会话将被用于语句的执行, 只是没有将数据共享之间的两个不同的调用相同的SqlSession| SESSION/STATEMENT| SESSIOn|
| dbcTypeForNull | 指定为空值时, 没有特定的JDBC类型的参数的JDBC类型。 有些驱动需要指定列的JDBC类型, 但其他像NULL,VARCHAR或OTHERS工作与通用值| jdbc的枚举类型，大部分为null, varchar 和 other| other|
| lazyLoadTriggerMethods | 指定触发延迟加载的对象的方法 | 一个由逗号分隔开的方法列表| equals,clone,hashCode,toString |
| defaultScriptingLanguage| 指定所使用的语言默认为动态SQL生成 | 一个类别名或者全限定类型 | org.apache.ibatis.scripting,xmltags.XMLDynamicLanguageDriver|
| callSettersOnNulls | 指定如果sette汸法或map的put方法时, 将调用检索到的值是否为null, 当你依靠Map.keySet()或null初始化。 注意原语(如整型, 布尔等)不会被设置为null | true/false| false|
| logPrefix | 指定的前缀字串，MyBatis将会堦加记录器的名称 | 任意的字符串| 没有设置 null |
| loglmpl | 指定MyBatis的日志实现使用, 如果此设置是不存在的, 记录的实施将自动查找| SLF4J/L0G4J/L0G4J2/JDK.LOGGING/COMMONS_LOGGING/STDOUT_LOGGING| 没有设置 null|
| proxyFactory| 指定代理工具, MyBatis将会使用其来创建懒加载能力的对象| CGLIB|JAVASSIST | 没有设置, null|

 
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
