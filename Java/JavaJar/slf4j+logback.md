# slf4j+logback

## slf4j
类似于一个接口,内部定义了许多关于日志的方法，但是没有具体的实现，需要提供具体的实现

## logback
类似于接口的实现，内部有日志的具体实现

有个sl4fj和logback，那么我们就可以在代码中以接口的形式进行编程，但某一天我们不需要用logback进行日志输出了
我们可以修改配置，让slf4j的实现类转为log4j等，不需要重新修改代码和编译了(前提是：一开始的代码里面已经有了
这个jar包)

## 简单入门
> 1. 需要的jar包
>> 1. slf4j-api
>> 2. logback-core
>> 3. logback-classic

> 2. Maven依赖
```xml
dependencies>
    <dependency>
        <groupId>org.slf4j</groupId>
        <artifactId>slf4j-api</artifactId>
        <version>1.8.0-beta2</version>
    </dependency>

    <dependency>
        <groupId>ch.qos.logback</groupId>
        <artifactId>logback-classic</artifactId>
        <version>1.3.0-alpha4</version>
        <exclusions>
             <exclusion>
                 <groupId>org.slf4j</groupId>
                 <artifactId>slf4j-api</artifactId>
             </exclusion>
         </exclusions>
    </dependency>
</dependencies>
```

> 3. 配置日志如何输出格式等的配置文件
```xml
<?xml version="1.0" encoding="UTF-8"?>
<configuration>
	<appender name="STDOUT" class="ch.qos.logback.core.ConsoleAppender">
		<encoder>
			<pattern>%d{HH:mm:ss.SSS} [%thread] %-5level %logger{36} - %msg%n</pattern>
		</encoder>
	</appender>

	<root level="debug">
		<appender-ref ref="STDOUT" />
	</root>
</configuration>
```

> 4. 使用
```java
private static Logger logger = LoggerFactory.getLogger(MyLogger.class);
logger.info("日志内容----------->{}",str);
```

> 5. 查看logback的内部状态（当logback出现问题时，可以通过这个进行排查）
```java
LoggerContext lc = (LoggerContext) LoggerFactory.getILoggerFactory();
StatusPrinter.print(lc);
```

## 学习

#### 1.logback 的体系结构
目前，logback 分为三个模块：Core、Classic 和 Access。
> 1. Core模块是其他两个模块的基础
> 2. Classic 模块扩展了core模块,Classic 模块相当于 log4j的显著改进版
> 3. Access 模块与 Servlet 容器集成，提供 HTTP 访问记录功能

#### logback可以有以下三种配置文件
> 1. logback.groovy
> 2. logback-test.xml
> 3. logback.xml
logback加载时也是按以上顺序在classpath进行加载的。，当加载到其中一个时，就停止加载。如果都没有的话，使用自身默认的

当三个文件都没有，logback默认地会调用BasicConfigurator，创建一个最小化配置。效果和这个差不多
```xml
<?xml version="1.0" encoding="UTF-8"?>
<configuration>
    <appender name="STDOUT"  class="ch.qos.logback.core.ConsoleAppender">
        <encoder>
            <pattern>%d{HH:mm:ss.SSS} [%thread] %-5level %logger{36}- %msg%n</pattern>
        </encoder>
    </appender>

    <root level="debug">
        <appender-ref ref="STDOUT" />
    </root>
</configuration>
```

#### 启动时打印logback的内部信息
代码的形式
```java
LoggerContext lc = (LoggerContext)
LoggerFactory.getILoggerFactory();
StatusPrinter.print(lc);
```

配置的形式1
```xml
<configuration debug="true">
  ...
</configuration>
```
`debug=true` : 可以在启动的时候，打印logback内部的状态信息

配置的形式2
```xml
<configuration>
  <statusListener class="ch.qos.logback.core.status.OnConsoleStatusListener"/>
</configuration>
```
设置了一个监听器`OnConsoleStatusListener`，最终效果和`debug=true`一样，2选1。

#### 配置文件修改后自动重新加载
```xml
<configuration scan="true" scanPeriod="30 seconds">
  ...
</configuration>
```
`scan=true`:配置文件修改时能够重新加载
`scanPeriod=30 seconds` : 每隔30s扫描一次，默认为1m，如果不写单位是，默认为毫秒

#### 配置
![Alt '图片'](https://github.com/LCN29/MyNote/blob/picture-branch/Picture/Java/JavaJar/slf4j+logback/logback-config01.png?raw=true)

如图一个logback的配置文件的最外层是`configuration`,第二级可以0到无限个的`appender`，0到无限个`logger`,最多一个的`root`

##### root
定义了Logger的根logger
```xml
<!-- 定义了根logger的有效级别 -->
<root level="DEBUG">
	<appender-ref ref="appLogAppender" />
</root>
```

##### Logger
> 1. Logger上下文
Logger的实例是有联系的。比如，名为“com.foo"”的 logger 是名为“com.foo.Bar”之父。Logger内部维护了一个树结果，将各个logger关联起来。通过
`Logger rootLogger = LoggerFactory.getLogger(org.slf4j.Logger.ROOT_LOGGER_NAME);`
可以获取到根顶点。

> 2. Logger有效级别
Logger 可以被分配级别。级别包括：TRACE < DEBUG < INFO < WARN < ERROR 。如果一个Logger没有定义级别，这这个Logger会向上找到第一个级别不为null的Logger,直至到根Logger。而根Logger的默认级别为DEBUG。

> 3. 打印的基本规则
如果L是一个Logger实例，那么，语句L.info("..")是一条级别为 INFO的记录语句
记录的级别高于于其 logger的有效时被称为被启用，否则，称为被禁
用。`基本选择规则 :记录请求级别为 p，其 logger 的有效级别为 q，只有则当 p>=q时，该请求才会被执行`。 比如：现在有一个Logger，名为L,L的有效级别为 debug, `L.trace("日志")`是无法执行的。
因为trace的级别低于debug。

```java
// 取得名为"com.foo"的 logger 实例
Logger logger = LoggerFactory.getLogger("com.foo");
// 设其级别为 INFO
logger.setLevel(Level.INFO);
Logger barlogger = LoggerFactory.getLogger("com.foo.Bar");

// 该请求有效，因为 WARN >= INFO
logger.warn("Low fuel level.");
// 该请求无效，因为 DEBUG < INFO.
logger.debug("Starting search for nearest gas station.");

// 名为"com.foo.Bar"的 logger 实例 barlogger, 从"com.foo"继承级别
// 因此下面的请求有效，因为 INFO >= INFO.
barlogger.info("Located nearest gas station.");
// 该请求无效，因为 DEBUG < INFO.
barlogger.debug("Exiting gas station search");
```

> 4. 配置
```xml
 <logger name="org.hibernate" level="error" />

 <logger name="com.creditease" level="info" additivity="true">
      <appender-ref ref="appLogAppender" />
 </logger>
```

logger只有一个name,一个可选的level属性和一个可选的 additivity属性。
>1. name：表示匹配的logger类型前缀，也就是包的前半部分
>2. level：要记录的日志级别，包括 TRACE < DEBUG < INFO < WARN < ERROR
>3. additivity: 作用在于children-logger是否使用 rootLogger配置的appender进行输出，false：表示只用当前logger的appender-ref。true：表示当前logger的appender-ref和自身所有祖先的appender-ref都有效

`例子：如果不想看到com.eigpay.nodebug包下的的DEBUG 信息`
```xml
<configuration>
  <appender name="STDOUT"
  class="ch.qos.logback.core.ConsoleAppender">
    <encoder>
    <pattern>
      %d{HH:mm:ss.SSS} [%thread] %-5level %logger{36} - %msg%n
    </pattern>
    </encoder>
  </appender>
  <!-- 有效级别为info, debug的请求级别<info的有效级别， 所以不会输出 debug的信息 -->
  <logger name="com.eigpay.nodebug" level="INFO" />

  <root level="DEBUG">
    <appender-ref ref="STDOUT" />
  </root>
</configuration>
```


##### Appender(重点)
![Alt '图片'](https://github.com/LCN29/MyNote/blob/picture-branch/Picture/Java/JavaJar/slf4j+logback/logback-config02.png?raw=true)

###### 1.作用
在 logback 里，一个输出目的地称为一个appender（日志输出的地方）。目前有控制台、文件、远程套接字服务器、MySQL、PostreSQL、Oracle和其他数据库、JMS和远程UNIX Syslog守护进程等多种 appender。

###### 2.特点
例如:`L.info（"123"）`输出到控制台，那么L的祖先也会将这条记录输出到自身的appender。这就是`appender叠加性`。设置logger的additivity 为 false，则可以取消这种默认的appender累积行为
。然而，如果 logger L的某个祖先P设置叠加性标识为 false，那么，L的输出会发送给L与 P之间(含P)的所有 appender，但不会发送给P的任何祖先的 appender。

###### 3.必填属性
`name` :指定appender的名称

`class` :appender 类的全限定名

###### 4.子组件
`filter` : 过滤器

`layout` : 用于定制日志输出的格式，现在开始被`encoder`代替

```xml
<?xml version="1.0" encoding="UTF-8"?>
<configuration>

  <!-- 将日志输出为文件 -->
  <appender name="FILE" class="ch.qos.logback.core.FileAppender">
    <!-- 文件名 -->
    <file>/app/log/myApp.log</file>
    <!--输出格式  -->
    <encoder>
      <pattern>%date %level [%thread] %logger{10} [%file:%line] %msg%n</pattern>
    </encoder>
  </appender>

  <!--将日志输出到控制台  -->
  <appender name="STDOUT" class="ch.qos.logback.core.ConsoleAppender">
    <encoder>
      <pattern>%msg%n</pattern>
    </encoder>
  </appender>

  <logger name="com.eigpay.appender" level="INFO">
    <!-- 标准输出, 此次没有设置 additivity，rootLogger的appender-ref都有效 ，所以会输出到控制台和文件中 -->
    <appender-ref ref="STDOUT" />
  </logger>

  <!-- 跟logger输出为文件 -->
  <root level="DEBUG">
    <appender-ref ref="FILE" />
  </root>

</configuration>
```

###### 5. Appender的几个常用的class属性
> 1. `ConsoleAppender` : 将内容输出到控制台
```xml
<appender name="STDOUT" class="ch.qos.logback.core.ConsoleAppender">
    <encoder>
        <pattern>%msg%n</pattern>
    </encoder>
    <!--默认值为System.out   -->
    <target>System.err</target>
</appender>
```

> 2. `FileAppender` : 将内容输出到文件
```xml
<appender name="FILE" class="ch.qos.logback.core.FileAppender">
  <!--输出到哪里  -->
  <file>testFile.log</file>
  <!-- 文件已近存在时， true(默认): 追加，
      false: 清空，再添加 -->
  <append>true</append>
  <!-- 安全的写入到入指定文件中，即使运行在不同的主机上，
  默认为false, prudent模式比非prudent模式，耗时间
  -->
  <prudent>true</prudent>
  <encoder>
    <pattern>%-4relative [%thread] %-5level %logger{35} - %msg%n
    </pattern>
</encoder>
</appender>
```

> 3. `RollingFileAppender` : 先将内容记录到一个文件，满足条件后记录到另一个文件（归档）
```xml
<appender name="appLogAppender" class="ch.qos.logback.core.rolling.RollingFileAppender">
   <Encoding>UTF-8</Encoding>
   <file/>
   <append/>
   <encoder/>
   <prudent/>
   <!--当发生滚动时，决定 RollingFileAppender 的行为-->
   <rollingPolicy/>
   <!-- 告知 RollingFileAppender 何时激活滚动 -->
   <triggeringPolicy />
</appender>
```
要实现RollingFileAppender需要指定好rollingPolicy和triggeringPolicy。`rollingPolicy`指定了如何滚动(归档)
`triggeringPolicy`指定了什么时候滚动(归档)。如果 RollingPolicy的实现类也实现了 TriggeringPolicy 接口，那么只需要设置 RollingPolicy

`例子`
```xml
<appender name="FILE"
class="ch.qos.logback.core.rolling.RollingFileAppender">
  <file>testFile.log</file>
  <rollingPolicy
  class="ch.qos.logback.core.rolling.FixedWindowRollingPolicy">
    <fileNamePattern>testFile.%i.log.zip</fileNamePattern>
    <minIndex>1</minIndex>
    <maxIndex>3</maxIndex>
  </rollingPolicy>
  <triggeringPolicy
    class="ch.qos.logback.core.rolling.SizeBasedTriggeringPolicy">
    <maxFileSize>5MB</maxFileSize>
  </triggeringPolicy>
  <encoder>
    <pattern>%-4relative [%thread] %-5level %logger{35} - %msg%n</pattern>
  </encoder>
</appender>
```
>> 1. `file`: 指定了一开始记录的位置
>> 2. `fileNamePattern` : 指定了最终归档的文件名,其中的`%i`指定了归档文件的名字的一部分。`zip`指定了最终归档的压缩方式为zip。
>> 3. `minIndex`和`maxIndex`: %i的取值范围。同时也暗指了能够存在的归档文件的最大数

| 滚动次数 | 活动输出目标 | 归档记录文件 | 描述                         |
| --------| ----------| ------------ | ---------------------------- |
| 0       | foo.log | -            | 还没发生滚动，记录到初始文件 |
| 1       | foo.log | foo1.log     |  第 1 次滚动。foo.log 被重命名为 foo1.log。创建新 foo.log并成为活动输出目标 |
| 2       | foo.log | foo1.log ,foo2.log | 第2次滚动,foo1.log被重命名为foo2.log。foo.log被重命名为foo1.log。创建新foo.log并成为活动输出目标|
| 3       | foo.log | foo1.log，foo2.log，foo3.log |  如2，foo2-->foo3. foo1-->foo1, foo->foo1, 再生成 foo |
| 4       | foo.log | foo1.log，foo2.log，foo3.log |  此时及此后，发生滚动时会先删除 foo3.log, 其余按照3的形式重命名 |

>> 4. `TimeBasedRollingPolicy` 一个按时间进行滚动的RollingFileAppender子组件，本身还实现了triggeringPolicy接口
```xml
<appender name="FILE"
class="ch.qos.logback.core.rolling.RollingFileAppender">
  <file>logFile.log</file>
  <rollingPolicy
  class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
    <fileNamePattern>logFile.%d{yyyy-MM-dd}.%i.log.gz</fileNamePattern>
    <maxHistory>30</maxHistory>
    <timeBasedFileNamingAndTriggeringPolicy class="ch.qos.logback.core.rolling.SizeAndTimeBasedFNATP">
        <maxFileSize>100MB</maxFileSize>
    </timeBasedFileNamingAndTriggeringPolicy>
  </rollingPolicy>
  <encoder>
    <pattern>%-4relative [%thread] %-5level %logger{35} - %msg%n
    </pattern>
  </encoder>
</appender>
```
`fileNamePattern`: 记录滚动(归档)的文件名，其名字必须有%d

`maxHistory`: 归档文件的最大数量，超过了，删除旧的

`滚动策略(根据时间格式的最小时间段进行滚动)`:
>> `foo.%d{yyyy-MM-dd}`: 每天滚动（在午夜）(当声明了file属性和路径和fileNamePattern的相同时，会将file重名为foo.2012-12-12,然后新建一个file的文件。)
>> `%d{yyyy/MM}/foo.txt`: 每月初滚动
>> `foo.%d{yyyy-ww}.log`: 每周初滚动

`timeBasedFileNamingAndTriggeringPolicy`: 非必须，在滚动时，可以限制每个文件的大小，当文件超过了`maxFileSize`就会归档一个文件XXX.0.log,在超过就XXX.1.log（%i的索引从0开始）


> 4. `SocketAppender` 将记录输出到远程实体(前提是远程服务器做好处理)

> 5. `JMSTopicAppender`
> 6. `JMSQueueAppender`
> 7. `AsyncAppender`
> 8. `SMTPAppender`
> 9. `DBAppender`
> 10. `SyslogAppender`
> 11. `SiftingAppender`
> 12. `自定义Appender`

###### encoder
Encoder负责两件事，一是把事件转换为字节数组，二是把字节数组写入输出流

`转义字符的作用`:

1. c{length} == lo{length} == logger{length}
输出logger的名字
例如 `mainPackage.sub.sample.Bar`

%c ==> mainPackage.sub.sample.Bar

%c{0} ==> Bar

%c{5} ==> m.s.s.Bar

%c{10} ==> m.s.s.Bar

%c{15} ==> m.s.sample.Bar

2. C{length} == class{length}
输出类的全限定名

3. contextName == cn
输出事件源头关联的 logger 的 logger 上下文的名称

4. d{pattern} == date{pattern}
按照pattern的格式输出日期

5. F == file
输出执行记录请求的 Java 源文件的文件名（尽量不使用）

6. L == line
输出执行记录请求的行号（尽量不使用）

7. caller{depth} == caller{depth, evaluator-1,... evaluator-n}
输出生成记录事件的调用者的位置信息（后面的evaluator，用作条件，当条件都为true，才会输出）例如:

%caller{2}会输出：
`0 [main] DEBUG - logging statement`

`Caller+0 at mainPackage.sub.sample.Bar.sampleMethodName(Bar.java:22)`

`Caller+1 at mainPackage.sub.sample.Bar.createLoggingRequest(Bar.java:17)`

8. m == msg == message
输出与记录事件相关联的应用程序提供的消息

9. M == method
输出执行记录请求的方法名（尽量不使用）

10. n
输出和平台相关的换行符

11. p == le == level
输出记录事件的级别。

12. r == relative
输出从程序启动到创建记录事件的逝去时间，单位毫秒

13. t == thread
输出产生记录事件的线程名。

14. ex{length} == exception{length}== throwable{length} == ex{length, evaluator-1, ... ,evaluator-n}
输出堆栈的异常信息 ,{}里面可以填写的数据有，任意正整数(输出多少行堆栈信息)，full(输出全部堆栈信息),short(打印堆栈跟踪的第一行)。

15. xEx{length} == xException{length} == xThrowable{lengt
h} == xEx{length,evaluator-1, ..., evaluator-n}
和ex的作用一样，只是多了包信息。

16. nopex == nopexception
表示不输出任何堆栈跟踪

`格式修饰符作用：`
%20logger ==>如果 logger 名少于 20 个字符则左填充空格

%-20logger ==> 如果 logger 名少于 20 个字符则右填充空格

%.30logge ==> 如果 logger 名多于 30 个字符则从前截断

%20.30logger ==>如果 logger 名少于 20 个字符则左填充空格。
同时，如果logger名多于 30 个字符则从前截断

%.-30logger ==>如果 logger 名多于 30 个字符则从后截断

`圆括号()作用：`
用于将某些信息变成组
`%-30(%d{HH:mm:ss.SSS} [%thread]) ` ==>时间和线程组成一个组，右填充空格

`\( \)` ==> 括号作为普通字符进行输出

`Evaluator（求值式）作用：`
有些转义字符可以添加条件，条件的判断就是通过求值式得出的
```xml
<appender name="STDOUT" class="ch.qos.logback.core.ConsoleAppender">
  <layout class="ch.qos.logback.classic.PatternLayout">
    <param name="Pattern"
    value="%-4relative [%thread] %-5level - %msg%n \
     %caller{2, DISP_CALLER_EVAL}"
    />
  </layout>
</appender>

<evaluator name="DISPLAY_CALLER_EVAL">
  <expression>
    logger.contains("chapters.layouts") &amp;&amp;
    message.contains("who calls thee")
  </expression>
</evaluator>

<!-- 抛出异常，同时异常为TestException的子类 -->
<evaluator name="DISPLAY_EX_EVAL">
  <expression>throwable != null &amp;&amp; throwable instanceof
  chapters.layouts.TestException</expression>
</evaluator>

<appender name="STDOUT2" class="ch.qos.logback.core.ConsoleAppender">
  <layout class="ch.qos.logback.classic.PatternLayout">
    <param name="Pattern"
    value="%msg%n%xEx{full, DISPLAY_EX_EVAL}"
    />
  </layout>
</appender>
```

###### 过滤器（Filter）
```xml
<?xml version="1.0" encoding="UTF-8"?>
<configuration>

  <appender name="CONSOLE"
    class="ch.qos.logback.core.ConsoleAppender">

    <filter class="ch.qos.logback.classic.filter.LevelFilter">
      <level>INFO</level>
      <onMatch>ACCEPT</onMatch>
      <onMismatch>DENY</onMismatch>
    </filter>

    <encoder>
      <pattern>%-4relative [%thread] %-5level %logger{30} - %msg%n
      </pattern>
    </encoder>

  </appender>

  <root level="DEBUG">
    <appender-ref ref="CONSOLE" />
  </root>
</configuration>
```
作用：对日志进行过滤。执行一个过滤器会有返回个枚举值，即DENY，NEUTRAL，ACCEPT其中之一。
> 1. `DENY`: 日志将立即被抛弃不再经过其他过滤器
> 2. `NEUTRAL`: 交给下个过滤器过接着处理日志
> 3. `ACCEPT`: 对日志进行输出，不再经过剩余过滤器

几个常用的过滤器
`LevelFilter`: 级别过滤器，根据日志级别进行过滤。如果日志级别等于配置级别，过滤器会根据onMath 和 onMismatch接收或拒绝日志
```xml
<appender name="CONSOLE" class="ch.qos.logback.core.ConsoleAppender">
    <filter class="ch.qos.logback.classic.filter.LevelFilter">
      <level>INFO</level>
       <!-- 符合条件的直接返回 accept  -->
      <onMatch>ACCEPT</onMatch>
        <!-- 不符合条件的直接返回 deny  -->
      <onMismatch>DENY</onMismatch>
    </filter>
    <encoder>
      <pattern>
        %-4relative [%thread] %-5level %logger{30} - %msg%n
      </pattern>
    </encoder>
  </appender>
```

`ThresholdFilter`: 临界值过滤器。当日志级别等于或高于临界值时，过滤器返回NEUTRAL；当日志级别低于临界值时，日志返回 DENY
```xml
<appender name="CONSOLE" class="ch.qos.logback.core.ConsoleAppender">
    <!-- 过滤掉 TRACE 和 DEBUG 级别的日志-->
    <filter class="ch.qos.logback.classic.filter.ThresholdFilter">
      <level>INFO</level>
    </filter>
    <encoder>
      ...
    </encoder>
</appender>
```

`EvaluatorFilter`: 求值过滤器，评估、鉴别日志是否符合指定条件。需要额外的两个JAR包，commons-compiler.jar和janino.jar
```xml
<appender name="STDOUT" class="ch.qos.logback.core.ConsoleAppender">
  <filter class="ch.qos.logback.core.filter.EvaluatorFilter">

    <evaluator>
      <matcher>
        <!--匹配器mather的名字  -->
        <Name>odd</Name>
        <!-- 正则表达式  -->
        <regex>statement [13579]</regex>
      </matcher>
      <!-- 进行匹配 -->
      <expression>odd.matches(formattedMessage)</expression>
    </evaluator>
    <!-- mather返回true 由 onMatch处理，
      false由OnMismatch
    -->
    <OnMatch>DENY</OnMatch>
    <OnMismatch>NEUTRAL</OnMismatch>
  </filter>

  <encoder>
    ...
  </encoder>

</appender>
```


#### 5.时间戳
```xml
<configuration>
  <!-- datePattern 时间戳输出的格式 -->
  <timestamp key="bySecond" datePattern="yyyyMMdd'T'HHmmss" />

  <appender name="FILE" class="...">
    <file>log-${bySecond}.txt</file>
  </appender>
</configuration>
```

#### 6.文件包含
```xml
<configuration>
  <!-- 导入文件 -->
  <include
file="src/main/java/chapters/configuration/includedConfig.xml" />

  <root level="DEBUG">
    <appender-ref ref="includedConsole" />
  </root>
</configuration>
```
`被导入的文件includedConfig.xml的内容`
```xml
<included>
  <appender name="includedConsole"
  class="ch.qos.logback.core.ConsoleAppender">
    <encoder>
      <pattern>"%d - %m%n"</pattern>
    </encoder>
  </appender>
</included>
```
> 1. 被导入的文件的`included`是必须的。
> 2. include的属性还可以为
>> `file` : 可以使用相对路径，也可以为绝对路径
>> `resource` : 在classpath下面的
>> `url` : 一个url

#### 7.设置上下文名称
每个logger都关联到logger上下文。默认情况下，logger上下文名为“default”。可以通过<contextName>设置成其他名字，意一旦设置 logger 上下文名称后不能再改。设置上下文名称后，可以方便地区分来自不同应用程序的记录

```xml
<configuration>
  <contextName>myAppName</contextName>
  <appender>
    <encoder>
      <!--  可以通过 %contextName获取到这个值 -->
      <Pattern> %contextName </Pattern>
    </encoder>
  </appender>
</configuration>
```

#### 8.变量替换
```xml
<configuration>
  <property name="USER_HOME" value="/home/sebastien"/>

  <property name="base" value="/app/log" />
  <property name="fileName" value="myApp.log"/>
  <property name="localAddress"     value="${base}/${fileName}" />

  <property
    file="src/main/java/chapters/configuration/variables1.properties" />

  <appender name="FILE" class="ch.qos.logback.core.FileAppender">
    <file>${USER_HOME}/${localAddressy:-golden}/myApp.log</file>
    <encoder>
      <pattern>%msg%n</pattern>
    </encoder>
  </appender>
</configuration>
```
> 1. 在`configuration`里面设置了property属性，可以在文件中通过`${key}`获取到对应的值。
> 2. ${key}支持嵌套使用 `${base}/${fileName}`可以赋给一个新的key
> 3. 当属性的值很多时，可以单独的把属性提出来为一个properties文件，然后在里面通过property的file导入进去
> 4. `:-`可以给一个${key}赋予一个默认值，如果${key}找不到时，可以使用这个默认值
> 5. `HOSTNAME`: 主机名，可以不用设置，这个内部设置了

#### 9.条件判断
```xml
<configuration>
  <!-- if-then form -->
  <if condition='property("HOSTNAME").contains("torino")'>

    <then>

      <appender name="CON"
      class="ch.qos.logback.core.ConsoleAppender">
        <encoder>
          <pattern>%d %-5level %logger{35} - %msg %n</pattern>
        </encoder>
      </appender>

      <root>
        <appender-ref ref="CON" />
      </root>

    </then>

  </if>

  <!-- if-then-else form -->
  <if condition="some conditional expression">
    <then>
      ...
    </then>

    <else>
      ...
    </else>
  </if>

</configuration>
```
> 1. `condition` 是 java 表达式，只允许访问上下文属性和系统属性
> 2. property("key") 可以获取到对应的value值，缩写`p("k")`,`如果key值不存在，返回空字符串，而不是null`。
