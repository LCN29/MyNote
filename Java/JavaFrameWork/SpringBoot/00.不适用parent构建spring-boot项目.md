# 使用Spring-Boot

## 1. 构建
在入门里面，我们搭建spring-boot的时候，我们在pom文件里面继承了一个父级
```xml
<parent>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-parent</artifactId>
    <version>2.0.1.RELEASE</version>
</parent>
```

但是有时候我们的项目是多模块，或者有其他父级需要继承(maven和java一样无法多重继承)我们可以让pom不需要继承`spring-boot-starter-parent`。
```xml
<!-- 导入spring-boot的依赖-->
<dependencyManagement>
    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-dependencies</artifactId>
            <version>2.0.1.RELEASE</version>
            <type>pom</type>
            <scope>import</scope>
        </dependency>

    </dependencies>
</dependencyManagement>
```
把spring-boot的依赖通过上面的方式导入到dependencyManagement。如果我们需要修改导入的spring-boot里面一些jar包的版本，需要这样，是没法直接导入dependency进行覆盖的。
```xml
<dependencyManagement>
  <dependencies>
    <!-- 覆盖Spring Boot提供的Spring Data发行版本 -->
    <dependency>
        <groupId>org.springframework.data</groupId>
        <artifactId>spring-data-releasetrain</artifactId>
        <version>Fowler-SR2</version>
        <scope>import</scope>
        <type>pom</type>
    </dependency>
  </dependencies>
</dependencyManagement>
```
`注意点`：修改成上面那样后，项目打包是无法启动的。运行时提示“没有主清单属性”。修复: 在spring-boot的项目的pom的打包文件里面添加
```xml
<plugins>
    <plugin>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-maven-plugin</artifactId>
        <executions>
            <execution>
                <goals>
                    <goal>repackage</goal>
                </goals>
            </execution>
        </executions>
        <configuration>
            <!-- 具体项目具体分析，此处应该放的是spring-boot的启动类的全限定名 -->
            <mainClass>com.eigpay.MyApplication</mainClass>
        </configuration>
    </plugin>
</plugins>
```
