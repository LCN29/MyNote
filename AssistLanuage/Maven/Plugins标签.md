# Maven 插件

#### 生命周期
maven生命周期：是对所有构建过程进行统一的抽象。如项目清理，初始化，编译，测试，打包等等。在maven中只定义了生命周期的顺序，而生命周期的具体实现由插件完成。类似于这样
```java
  public abstract class AbstractBuild{
    public void build（）{
      initialize();
      compile();
      ...
    }

    abstract void initialize();

    abstract void compile();
  }
```
同时maven为了用户的体验，本身实现了一套默认的实现方式



#### Maven的三套生命周期

##### 1. clear阶段(主要用于清理项目)
> 1. pre-clean    ：执行清理前的工作；
> 2. clean    ：清理上一次构建生成的所有文件；
> 3. post-clean    ：执行清理后的工作

##### 2. default(构建项目)
> 01. validate
> 02. initialize
> 03. generate-sources
> 04. process-sources
> 05. generate-resources
> 06. process-resources    ：复制和处理资源文件到target目录，准备打包；
> 07. compile    ：编译项目的源代码；
> 08. process-classes
> 09. generate-test-sources
> 10. process-test-sources
> 11. generate-test-resources
> 12. process-test-resources
> 13. test-compile    ：编译测试源代码；
> 14. process-test-classes
> 15. test    ：运行测试代码；
> 16. prepare-package
> 17. package    ：打包成jar或者war或者其他格式的分发包；
> 18. pre-integration-test
> 19. integration-test
> 20. post-integration-test
> 21. verify
> 22. install    ：将打好的包安装到本地仓库，供其他项目使用；
> 23. deploy    ：将打好的包安装到远程仓库，供其他项目使用；

##### 3. site(建立项目站点)
> 1. pre-site
> 2. site    ：生成项目的站点文档；
> 3. post-site
> 4. site-deploy    ：发布生成的站点文档

#### mvn命令行和生命周期的关系
> 1. `mvn clean` 调用clean生命周期的clean阶段,实际的阶段为clean阶段的pre-clean和clean阶段
> 2. `mvn test` 调用default阶段的test阶段，实际为default的vaildate到test的整个过程
> 3. `mvn clean install` 先clean的阶段，然后调用default的开始到install的阶段

#### 插件目标(plugin goal)
如果一个生命周期阶段(phase)对应的一个插件，那么就很多插件了。所以为了代码的复用，他能完成多个阶段。也就是一个生命周期的构建任务-->一个插件的某个具体的功能实现--->功能=目标。也就是目标就是实现生命周期中的某个任务。既mvn生命周期的一个阶段的具体实现由插件的一个功能,既目标实现。如maven-dependency-plugin的列出项目树功能，可以写成dependency:tree。冒号前是插件的前缀，后面是插件的目标。
执行mvn install 命令时打印的日志
```xml
maven-resources-plugin:2.6:testResources (default-testResources) @ my-project ---
```
`maven-resources-plugin:2.6` : maven内置的插件和版本
`testResource` : 插件的目标
`default-testResource` : 生命周期阶段

#### 自定义插件目标

```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-source-plugin</artifactId>
    <version>3.0.1</version>
    <!-- 作用：在原来的打包的基础上，在生成一个 -source.jar的jar包 -->
    <executions>
        <execution>
            <id>attach-source</id>
            <phase>package</phase><!-- 要绑定到的生命周期的阶段 -->
            <goals>
                <goal>jar-no-fork</goal><!-- 要绑定的插件的目标 -->
            </goals>
        </execution>
    </executions>
</plugin>
```

1. 执行结果
```xml
maven-source-plugin:3.0.1:jar-no-fork (attach-source) @ my-project
```

2. 分析
> 1. `GAV` : 指定了这个插件的位置
> 2. `excutions` : 指定了任务组
> 3. `execution` : 任务的描述
> 4. `id` : 任务的名字
> 5. `phase` : 在生命周期的什么阶段
> 6. `goal` : 执行什么插件的什么目标

如果去掉了上面的phase那一行，这个插件还是会执行的。因为很多插件的目标在编写时就设定好了默认绑定阶段。可以通过
```xml
mvn help:describe -Dplugin=org.apache.maven.plugins:maven-help-plugin:3.0.0 -Ddetail


mvn help:describe -Dplugin= GVA -Ddetail
```
查看信息的插件信息

3. 全局配置
```xml
<plugin>
  <groupId>org.apache.maven.plugins</groupId>
  <artifactId>maven-compiler-plugin</artifactId>
  <version>3.5.1</version>
  <configuration>
    <source>1.8</source>
    <target>1.8</target>
  </configuration>
</plugin>
```
这样不管是complie，还是testComplie都会以jdk1.8进行编译

4. 局部配置
```xml
<plugin>
  <groupId>org.apache.maven.plugins</groupId>
  <artifactId>maven-antrun-plugin</artifactId>
  <version>1.8</version>
  <executions>
    <execution>
      <id>ant-validate</id>
      <phase>validate</phase>
      <goals>
        <goal>run</goal>
      </goals>
      <configuration>
        <tasks>
          <echo>I'm running in vaildate</echo>
        </tasks>
      </configuration>
    </execution>
    <execution>
      <id>ant-verity</id>
      <phase>verify</phase>
      <goals>
        <goal>run</goal>
      </goals>
      <configuration>
        <tasks>
          <echo>I'm running in verity</echo>
        </tasks>
      </configuration>
    </execution>
  </executions>
</plugin>
```
在execution里面的configuration便签可以单独给这个任务设置对应的配置信息

5. 其他配置
```xml
<plugin>
  <groupId>org.apache.maven.plugins</groupId>
  <artifactId>maven-jar-plugin</artifactId>
  <version>2.0</version>
  <extensions>false</extensions>
  <inherited>true</inherited>
  <dependencies>...</dependencies>
</plugin>
```
1. `extensions` : 是否加载这个插件的扩展
2. `inherited` : 是否能让子模块继承
3. `dependencies` : 这个插件的依赖
