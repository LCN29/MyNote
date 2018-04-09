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
