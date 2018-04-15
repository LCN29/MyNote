# Dubbo

## Maven依赖
```xml
<!-- spring核心依赖省略 -->

<!-- dubbo 此处的version为 2.6.1 -->
<dependency>
    <groupId>com.alibaba</groupId>
    <artifactId>dubbo</artifactId>
    <version>${dubbo.version}</version>
    <exclusions>
        <exclusion>
            <groupId>org.springframework</groupId>
            <artifactId>spring-expression</artifactId>
        </exclusion>
        <exclusion>
            <groupId>org.springframework</groupId>
            <artifactId>spring-context</artifactId>
        </exclusion>
    </exclusions>
</dependency>

<!-- zookeeper注册中心，其中的日志jar包根据自己项目的日志jar决定是否需要过滤 -->
<dependency>
    <groupId>org.apache.zookeeper</groupId>
    <artifactId>zookeeper</artifactId>
    <version>${zookeeper.version}</version>
    <exclusions>
        <exclusion>
            <groupId>org.slf4j</groupId>
            <artifactId>slf4j-log4j12</artifactId>
        </exclusion>
        <exclusion>
            <groupId>log4j</groupId>
            <artifactId>log4j</artifactId>
        </exclusion>
        <exclusion>
            <groupId>org.slf4j</groupId>
            <artifactId>slf4j-api</artifactId>
        </exclusion>
    </exclusions>
</dependency>

```

## 配置的优先级
在dubbo中，各种配置的优先级规则是这样的: 方法(method) > 接口(service/reference) > 全局配置(provider/consumer),如果provider和consumer同时都有设置，以consumer的为主。既 consumer's method > provider's method > consumer's reference > provider's service > consumer > provider

## 官方文档

>1. 使用手册(http://dubbo.apache.org/books/dubbo-user-book/)
>2. 开发手册(http://dubbo.apache.org/books/dubbo-dev-book/)

## dubbo中的几个二级标签
>1 `Provider`:
>>1. `dubbo:service`: 用于提供服务
>>2. `dubbo:protocol`: 用于协议配置
>>3. `dubbo:provider`: 可以为`dubbo:service`和`dubbo:protocol`设置默认值，如果2个本身有设置，以本身的设置为主。

>2. `Consumer`:
>>1. `dubbo:reference`: 用于引用服务
>>2. `dubbo:consumer`: 为'duboo:reference'设置默认值

>3. `Provider`和`Consumer`共用的
>>1. `dubbo:registry`: 注册中心配置
>>2. `dubbo:application`: 这个应用的名称，如果项目既是Provider，也是Consumer,以Provider为主
>>3. `dubbo:method`: 方法级设置，既将设置具体到接口中的某个具体的方法
>>4. `dubbo:argument`: 方法参数配置
>>5. `dubbo:parameter`: 选项参数配置


>4. 不确定
>>1. `dubbo:monitor`:用于服务的可视化页面
>>2. `dubbo:module`: 模块配置，（？？？）

