# Profile

主要用于定义各种运行环境和这些环境中的不同配置

```xml
<build>
  ...
  <plugin>
    ...
    <configuration>
      <test-key>${db.url}</test-key>
    </configuration>
    ...
  </plugin>
  ...
</build>

<profiles>
  <profile>
    <id>dev</id>
    <properties>
      <db.url>jdbc:mysql://localhost:3306/dev</db.url>
    </properties>
    <activation>
    <!--默认激活这个-->
    <activeByDefault>true</activeByDefault>
    </activation>
  </profile>
  <profile>
    <id>test</id>
    <properties>
      <db.ulr>jdbc:mysql://localhost:3306/test</db.ulr>
    </properties>
  </profile>
</profiles>
```
写在project里面的绝大部分标签都可以写到profile里面。起到运行的是这个配置时，加载这个里面的配置。如上面，如果运行了dev环境，这到时build里面的test-value的值会被替换成---/dev,运行了test环境，则就是---/test

## 设置profile激活
1. 显示的指定运行那个profile
`mvn -Denv=dev integration-test`

`mvn clean install -Pdev,dev2` 显示的调用了2个profile：dev,dev2

2. 通过maven的setting显示指定激活的是那个profile
```xml
<settings>
  ...
  <profiles>...</profiles>
  <activeProfiles>
    <activeProfile>dev</activeProfile>
  </activeProfiles>
  ...
</settings>
```

3. 通过环境决定
```xml
<profile>
  ...
  <activation>
    <!-- 当运行的环境是jdk1.4时，使用这个profile  -->
    <jdk>1.4</jdk>
  </activation>
</profile>

<profile>
  ...
  <activation>
    <!-- 当system存在 'debug'属性，使用这个profile  -->
    <!-- 测试 mvn install -Ddebug -->
    <property>
      <name>debug</name>
    </property>
  </activation>
</profile>

<profile>
  ...
  <activation>
    <!-- 当system存在 'environment'属性，并且他的值是test,
    使用这个profile  -->
    <!-- 测试 mvn install -Denvironment=test -->
    <property>
      <property>
        <name>environment</name>
        <value>test</value>
      </property>
    </property>
  </activation>
</profile>
```

4. 基于操作系统
```xml
<profile>
  <id>test-dev</id>
  <activation>
    <!-- 当操作系统是Window XP,使用这个profile -->
    <os>
      <name>Windows XP</name>
      <family>Windows</family>
      <arch>x86</arch>
      <version>5.1.2600</version>
    </os>
  </activation>
</profile>
```

5. 根据某个文件的存在状态
```xml
<profile>
  <id>dev-2</id>
  <activation>

    <!--这个文件不存在，激活这个状态-->
    <file>
      <missing>target/generated-sources/axistools/wsdl2java/org/apache/maven</missing>
    </file>

    <!--
      这个文件存在是激活这个profile
    <file>
      <exists>target/generated-sources/axistools/wsdl2java/org/apache/maven</exists>
    </file>
    -->
  </activation>
</profile>

```

6. 默认激活
```xml
<profile>
  <id>dev</id>
    <activation>
    <!--默认激活这个-->
    <activeByDefault>true</activeByDefault>
  </activation>
</profile>
```
