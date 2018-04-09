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

##### 1.logback 的体系结构
目前，logback 分为三个模块：Core、Classic 和 Access。
> 1. Core模块是其他两个模块的基础
> 2. Classic 模块扩展了core模块,Classic 模块相当于 log4j的显著改进版
> 3. Access 模块与 Servlet 容器集成，提供 HTTP 访问记录功能

##### 2.Logger
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


`Appender介绍`
> 1. 输出目的
在 logback 里，一个输出目的地称为一个appender（日志输出的地方）。目前有控制台、文件、远程套接字服务器、MySQL、PostreSQL、Oracle和其他数据库、JMS和远程UNIX Syslog守护进程等多种 appender。

一个 logger 可以被关联多个 appender。addAppender（）为指定的 logger 添加一个appender

> 2. Appender 叠加性
Logger L 的记录语句的输出会发送给 L 及其祖先的全部 appender。这就是“appender叠加性”的含义。例如:`L.info（"123"）`输出到控制台，那么L的祖先也会将这条记录输出到自身的appender。设置 logger的additivity 为 false，则可以取消这种默认的appender累积行为。然而，如果 logger L的某个祖先P设置叠加性标识为 false，那么，L的输出会发送给L与 P之间(含P)的所有 appender，但不会发送给P的任何祖先的 appender。

> 3. Layout
通过给Appender关联一个Layout可以对日志格式进行定制。
如定制了输出的格式为:
`"%-4relative [%thread] %-5level %logger{32} - %msg%n"`
打印出来的日志会是这样的:
`176 [main] DEBUG manual.architecture.HelloWorld2 - Hello world.`
> 176 :自程序启动以来的逝去时间，单位是毫秒
> [main] :发出记录请求的线程
> DEBUG : 是记录请求的级别
> manual.architecture.HelloWorld2 : logger的名称
> Hello world. : 请求的消息文字
