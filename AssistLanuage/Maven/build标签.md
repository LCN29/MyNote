# build标签学习

## 2种build

```xml
<project>

  <!-- Project Build -->
  <build>...</build>

  <profiles>
    <profile>
      <!--Profile Build -->
      <build>...</build>
    </profile>
  </profiles>

</project>
```
> 1. `Project Build` : build便签是project标签的直接子元素.针对整个项目的所有情况都有效，可以被profile build 继承
> 2. `Profile Build` : builid便签是profile标签的直接子元素，用于重写覆盖掉 project build 中的配置，是 project build 的子集

# build内部标签讲解
```xml
<build>

  <defaultGoal>install</defaultGoal>
  <directory>${basedir}/target</directory>
  <finalName>test</finalName>
  <filters>
    <filter>${basedir}/src/main/filters/filter.properties</filter>
  </filters>

  <resources>
    <resource>
      <directory>${basedir}/src/main/resource</directory>
      <targetPath>C:/Users/LCN/Desktop/test/one</targetPath>
      <filtering>true</filtering>
      <includes>
        <include>**/test.xml</include>
        <include>**/spring.xml</include>
      </includes>
      <excludes>
        <exclude>**/do.xml</exclude>
      </excludes>
    </resource>
  </resources>

  <!-- testResource的标签属性和resources类似 -->
  <testResources>
    ...
  </testResources>

  <!--使用的插件列表-->
  <plugins>
    <!--参见build/pluginManagement/plugins/plugin元素-->
    <plugin>
      <groupId/>
      <artifactId/>
      <version/>
      <executions>
        <execution>
          <id/>
          <phase/>
          <goals/>
          <inherited/>
          <configuration/>
        </execution>
      </executions>

      <dependencies>
        <!--参见dependencies/dependency元素-->
        <dependency>......</dependency>
      </dependencies>
      <goals/>
      <inherited/>
      <configuration/>
    </plugin>
  </plugins>

</build>
```
1. `defaultGoal`: 执行 mvn 命令时，如果没有指定目标，指定使用的默认目标。 如上配置：在命令行中执行 mvn，则相当于执行： mvn install
2. `directory`: 项目构建的结果所在的路径，默认为\${basedir}/target目录。\${basedir}的是当前项目的的里面第一层，同src同级。
3. `finalName`: 打包出来的jar的名字，默认为\${artifactId}-${version}
4. `resource`: 对资源文件进行处理
5. `direcotory`: 资源文件所在的地方
6. `targetPath`: 资源文件输出的地方

7. `includes`: 指定哪些资源文件需要打包的
8. `excludes`: 指定哪些资源文件不需要打包的，当exclude和include有重合时，取exclude的值
9. `filtering`: 是否启用键值对替换，既资源文件里面的${key}要不要替换为`properties`里面的键值对
10. `fliter`: 当指定了这个的时候，资源文件里面的${key}的值会在指定的这个里面的properties文件进行寻找
