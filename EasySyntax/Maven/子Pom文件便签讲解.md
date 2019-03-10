
# 子Pom文件标签讲解

```xml
<project  xmlns="http://maven.apache.org/POM/4.0.0"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://maven.apache.org/POM/4.0.0http://maven.apache.org/maven-v4_0_0.xsd">

  <!--说明这个子模块的父级，里面为父模块的maven坐标-->
  <parent>
    <groupId>com.alibaba</groupId>
    <artifactId>dubbo-parent</artifactId>
    <version>1.0-SNAPSHOT</version>
  </parent>

  <artifactId>dubbo-admin</artifactId>
	<packaging>war</packaging>
  <name>dubbo-admin</name>
	<description>The admin module of dubbo project</description>

  <!-- 导入父级中声明的模块 -->
  <dependencies>
    <dependency>
      <groupId>org.apache.maven</groupId>
      <artifactId>maven-artifact</artifactId>
    </dependency>
  </dependencies>

</project>
```
l
