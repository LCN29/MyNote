# Maven 主Pom文件便签讲解


```xml
<project  xmlns="http://maven.apache.org/POM/4.0.0"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://maven.apache.org/POM/4.0.0http://maven.apache.org/maven-v4_0_0.xsd">

  <!-- 指定了当前Maven模型的版本号  -->
  <modelVersion>4.0.0</modelVersion>

  <!--组织id,通常为公司域名的逆向,如 com.baidu -->
  <groupId>com.alibaba</groupId>
  <!-- 项目名称 -->
  <artifactId>dubbo-parent</artifactId>
  <!-- 版本号，SNAPSHOT意为快照，说明该项目还在开发中，是不稳定的版本 -->
  <!-- 通常groupId,artifactId和version三个生成了一个Maven项目的基本坐标 -->
  <version>1.0-SNAPSHOT</version>
  <!--这个项目的打包方式，默认为jar,还能为war等 -->
  <packaging>pom</packaging>

  <!--项目名称 -->
  <name>dubbo</name>
  <!--这个项目的简单描述-->
	<description>The parent project of dubbo</description>
  <!-- 项目的访问网址  -->
	<url>http://code.alibabatech.com/wiki/display/dubbo</url>
  <!-- 项目开始的年份 -->
  <inceptionYear>2011</inceptionYear>

  <!--子模块的信息 -->
  <modules>
    <!--字模块-->
    <module>dubbo-admin</module>
  </modules>

  <!--这个项目构建环境中的前提条件-->
  <prerequisites>
      <!--构建该项目或使用该插件所需要的Maven的最低版本 -->
      <maven>4.0.2</maven>
  </prerequisites>

  <!--项目的问题管理系统信息-->
  <issueManagement>
    <!-- 问题管理系统的名字-->
    <system>jira</system>
    <!--该项目使用的问题管理系统的URL-->
    <url>http://code.alibabatech.com/jira/browse/DUBBO</url>
  </issueManagement>

  <ciManagement>
    <!--持续集成系统的名字，例如continuum-->
    <system>Travis CI</system>
    <!--该项目使用的持续集成系统的URL（如果持续集成系统有web接口的话）。-->
    <url>https://travis-ci.org/mybatis/spring</url>
    <!--构建完成时，需要通知的开发者/用户的配置项。包括被通知者信息和通知条件（错误，失败，成功，警告）-->
    <notifiers>
	    <!--配置一种方式，当构建中断时，以该方式通知用户/开发者-->
	    <notifier>
	      <!--传送通知的途径-->
	      <type>mail</type>
	      <!--发生错误时是否通知-->
	      <sendOnError>true</sendOnError>
	      <!--构建失败时是否通知-->
	      <sendOnFailure>true</sendOnFailure>
	      <!--构建成功时是否通知-->
	      <sendOnSuccess>true</sendOnSuccess>
	      <!--发生警告时是否通知-->
	      <sendOnWarning>true</sendOnWarning>
	      <!--不赞成使用。通知发送到哪里-->
	      <address>testemail.@qq.com</address>
	      <!--扩展配置项-->
	      <configuration>
          <!-- 自定义的key和value  -->
          <my-key>my-value</my-key>
        </configuration>
	    </notifier>
	  </notifiers>
  </ciManagement>

  <!--项目相关邮件列表信息-->
  <mailingLists>
    <!--该元素描述了项目相关的所有邮件列表。自动产生的网站引用这些信息。-->
    <mailingList>
      <!--邮件的名称-->
      <name>Demo</name>
      <!--发送邮件的地址或链接，如果是邮件地址，创建文档时，mailto: 链接会被自动创建-->
      <post>banseon@126.com</post>
      <!--订阅邮件的地址或链接，如果是邮件地址，创建文档时，mailto: 链接会被自动创建-->
      <subscribe>banseon@126.com</subscribe>
      <!--取消订阅邮件的地址或链接，如果是邮件地址，创建文档时，mailto: 链接会被自动创建-->
      <unsubscribe>banseon@126.com</unsubscribe>
      <!--你可以浏览邮件信息的URL-->
      <archive>http:/hi.baidu.com/banseon/demo/dev/</archive>
    </mailingList>
  </mailingLists>

  <!--项目开发者列表-->
  <developers>
    <!--某个项目开发者的信息-->
    <developer>
      <!--SCM里项目开发者的唯一标识符-->
      <id>shawn.qianx</id>
      <!--项目开发者的全名-->
      <name>QianXiao(Shawn)</name>
      <!--项目开发者的email-->
      <email>shawn.qianx (AT) alibaba-inc.com</email>
      <!--项目开发者的主页的URL-->
      <url>http:www.baidu.com</url>
      <!--项目开发者在项目中扮演的角色，角色元素描述了各种角色-->
      <roles>
      	<role>Developer</role>
        <role>Project Manager</role>
      </roles>
      <!--项目开发者所属组织-->
      <organization>alibaba</organization>
      <!--项目开发者所属组织的URL-->
      <organizationUrl>https://www.alibaba.com/</organizationUrl>
      <!--项目开发者属性，如即时消息如何处理等-->
      <properties>
        <dept>No</dept>
      </properties>
      <!--项目开发者所在时区， -11到12范围内的整数。-->
      <timezone>+8</timezone>

    </developer>
  </developers>

  <!--项目的其他贡献者列表-->
  <contributors>
    <!--项目的其他贡献者-->
    <contributor>
      <name/>
      <email/>
      <url/>
      <organization/>
      <organizationUrl/>
      <roles/>
      <timezone/>
      <properties/>
    </contributor>
  </contributors>

  <!--项目所有License列表  -->
  <licenses>
    <!--描述了项目的license，用于生成项目的web站点的license页面，其他一些报表和validation也会用到该元素-->
    <license>
       <!--license用于法律上的名称-->
      <name>Apache 2</name>
      <!--官方的license正文页面的URL-->
      <url>http://www.apache.org/licenses/LICENSE-2.0.txt</url>
      <!--项目分发的主要方式：repo，可以从Maven库下载
	              manual， 用户必须手动下载和安装依赖-->
      <distribution>repo</distribution>
      <!--关于license的补充信息-->
      <comments>A business-friendly OSS license</comments>
    </license>
  </licenses>

  <!--SCM(Source Control Management)标签允许你配置你的代码库，供Maven web站点和其它插件使用。-->
  <scm>
    <!--指向项目的可浏览SCM库（例如ViewVC或者Fisheye）的URL。-->
    <url>http://code.alibabatech.com/svn/dubbo/trunk</url>
    <!--SCM的URL,该URL描述了版本库和如何连接到版本库。欲知详情，请看SCMs提供的URL格式和列表。该连接只读。-->
    <connection>scm:svn:http://code.alibabatech.com/svn/dubbo/trunk</connection>

    <!--给开发者使用的，类似connection元素。即该连接不仅仅只读-->
    <developerConnection>scm:git:ssh://git@github.com/mybatis/spring.git</developerConnection>
    <!--当前代码的标签，在开发阶段默认为HEAD-->
    <tag>HEAD</tag>
  </scm>

  <!--描述项目所属组织的各种属性。Maven产生的文档用-->
  <organization>
    <!--组织的全名-->
    <name>Alibaba</name>
    <!--组织主页的URL-->
    <url>http://www.alibaba.com</url>
  </organization>

  <!-- 自定义键值对，在这个文件内可以通过${key}获取到对应的value -->
  <properties>
    <maven.compiler.source>1.8</maven.compiler.source>
    <maven.compiler.target>1.8</maven.compiler.target>
    <junit.version>5.1.0</junit.version>
  </properties>

  <!--发现依赖和扩展的远程仓库列表，也就是私服 -->
	<repositories>
    <!--包含需要连接到远程仓库的信息-->
    <repository>
      <!--远程仓库唯一标识符。可以用来匹配在settings.xml文件里配置的远程仓库-->
      <id>nexus-proxy</id>
      <!--远程仓库名称-->
	    <name>banseon-repository-proxy</name>
      <!--远程仓库URL，按protocol://hostname/path形式-->
      <url>http://192.168.246.91:8081/nexus/content/groups/public/</url>
      <!-- 用于定位和排序构件的仓库布局类型-可以是default（默认）或者legacy（遗留）-->
      <layout>default</layout>
      <!--如何处理远程仓库里发布版本的下载-->
      <releases>
        <!-- 可以从仓库里面下载 发布版，false:不可以  -->
        <enabled>true</enabled>
        <!--该元素指定更新发生的频率,Maven会比较本地POM和远程POM的时间戳。这里的选项是：
        always（一直），
        daily（默认，每日），
        interval：X（这里X是以分钟为单位的时间间隔），
        never（从不）-->
        <updatePolicy>interval: 180</updatePolicy>
        <!--当Maven验证构件校验文件失败时该怎么做
        ignore（忽略），fail（失败），或者warn（警告）
        -->
        <checksumPolicy>warn</checksumPolicy>
      </releases>

        <!--如何处理远程仓库里快照版本的下载-->
      <snapshots>
        <enabled/>
        <updatePolicy/>
        <checksumPolicy/>
      </snapshots>
    </repository>

  </repositories>

  <!-- 发现插件的远程仓库列表， -->
  <pluginRepositories>
    <pluginRepositorie>
      <!-- 这里里面的属性和repositories/repositorie一样   -->
      <id/>
      <url/>
      ....
    </pluginRepositorie>
  </pluginRepositories>

  <!--项目分发信息，在执行mvn deploy后表示要发布的位置。
  有了这些信息就可以把网站部署到远程服务器或者把构件部署到远程仓库。-->
  <distributionManagement>
    <!--部署项目产生的构件到远程仓库需要的信息-->
    <repository>
      <!--是分配给快照一个唯一的版本号（由时间戳和构建流水号）,还是每次都使用相同的版本号,-->
      <uniqueVersion>false</uniqueVersion>
      <id>banseon-maven2</id>
      <name>banseon maven2</name>
      <url>file://${basedir}/target/deploy</url>
      <layout>default</layout>
    </respository>

    <!--构件的快照部署到哪里？如果没有配置该元素
    默认部署到distributionManagement/repository元素配置的仓库-->
    <snapshotRepository>
      <uniqueVersion>true</uniqueVersion>
      <id>banseon-maven2</id>
      <name>Banseon-maven2 Snapshot Repository</name>
      <url>scp://svn.baidu.com/banseon:/usr/local/maven-snapshot</url>
      <layout>default</layout>
    </snapshotRepository>

    <!--部署项目的网站需要的信息-->
    <site>
      <!--部署位置的唯一标识符，用来匹配站点和settings.xml文件里的配置-->
      <id>banseon-site</id>
      <!--部署位置的名称-->
      <name>business api website</name>
      <!--部署位置的URL，按protocol://hostname/path形式-->
      <url>scp://svn.baidu.com/banseon:/var/www/localhost/banseon-web</url>
    </site>

    <!--项目下载页面的URL。如果没有该元素，用户应该参考主页。使用该元素的原因是：
    帮助定位那些不在仓库里的构件（由于license限制）-->
    <downloadUrl>http://www.baidu.com</downloadUrl>


    <!--如果构件有了新的group ID和artifact ID（构件移到了新的位置），这里列出构件的重定位信息。-->
    <relocation>
      <!--构件新的group ID-->
      <groupId/>
      <!--构件新的artifact ID-->
      <artifactId/>
      <!--构件新的版本号-->
      <version/>
      <!--显示给用户的，关于移动的额外信息，例如原因。-->
      <message>天气热了</message>
    </relocation>
    <!-- 给出该构件在远程仓库的状态。不得在本地项目中设置该元素，因为这是工具自动更新的.有效的值有：
      none（默认）
      converted（仓库管理员从 Maven 1 POM转换过来）
      partner（直接从伙伴Maven 2仓库同步过来）
      deployed（从Maven 2实例部 署）
      verified（被核实时正确的和最终的）
    -->
    <status></status>
  </distributionManagement>

  <!--该元素描述使用报表插件产生报表的规范。当用户执行“mvn site”，
  这些报表就会运行。 在页面导航栏能看到所有报表的链接。-->
  <reporting>
    <!--true，则，网站不包括默认的报表。这包括“项目信息”菜单中的报表。-->
    <excludeDefaults></excludeDefaults>
    <!--所有产生的报表存放到哪里。默认值是${project.build.directory}/site。-->
    <outputDirectory>D://output<outputDirectory>
    <!--使用的报表插件和他们的配置。-->
    <plugins>
      <!--plugin元素包含描述报表插件需要的信息-->
      <plugin>
        <!--报表插件在仓库里的group ID-->
        <groupId/>
        <!--报表插件在仓库里的artifact ID-->
        <artifactId/>
        <!--被使用的报表插件的版本（或版本范围）-->
        <version/>
        <!--任何配置是否被传播到子项目-->
        <inherited/>
        <!--报表插件的配置-->
        <configuration/>

        <!--组报表的多重规范，每个规范可能有不同的配置,一个规范（报表集）对应一个执行目标
        例如，有1，2，3，4，5，6，7，8，9个报表。
        1，2，5构成A报表集，对应一个执行目标。
        2，5，8构成B报表集，对应另一个执行目标
        -->
        <reportSets>
          <!--表示报表的一个集合，以及产生该集合的配置-->
          <reportSet>
            <!--报表集合的唯一标识符，POM继承时用到-->
            <id/>
            <!--产生报表集合时，被使用的报表的配置-->
            <configuration/>
            <!--配置是否被继承到子POMs-->
            <inherited/>
            <!--这个集合里使用到哪些报表-->
            <reports/>
          </reportSet>
        </reportSets>

      </plugin>
    <plugins>

  </reporting>

  <!--继承自该项目的所有子项目的默认依赖信息.这部分的依赖信息不会被立即解析, 而是当子项目声明一个依赖
  有且只有group ID和 artifact ID信息,没有以外的一些信息没有描述,则通过group ID和artifact ID 匹配到这里的依赖，
  并使用这里的依赖信息-->
  <dependencyManagement>
    <dependencies>
      <!-- maven坐标 -->
      <groupId>org.mybatis</groupId>
      <artifactId>mybatis</artifactId>
      <!--此处通过 ${}引入 版本号 -->
      <version>${spring.version}</version>
      <!-- 依赖类型 默认为jar -->
      <type>jar</type>
      <!--
        依赖范围。在项目发布过程中，帮助决定哪些构件被包括进来
        - compile ：默认范围，用于编译
        - provided：测试和编译起作用，但是运行时不起作用，由其他的容器提供
        - runtime: 测试运行期作用，如jdbc,编译时可以用jdk的进行编译，测试和运行才需要具体的实现
        - test:    用于test任务时使用
        - system: 作用范围和provider一致。通过systemPath来取得
        - systemPath: 仅用于范围为system。提供相应的路径
        - optional:   当项目自身被依赖时，标注依赖是否传递。用于连续依赖时使用
      -->
      <scope>system</scope>
      <!-- 当 scope为systemPath，起作用，指定系统路径 -->
      <systemPath>${java_home}/lib/rt.jar</systemPath>
      <!-- 不导入这个jar包依赖的这个jar包 -->
      <exclusions>
        <exclusion>
          <artifactId>spring-core</artifactId>
          <groupId>org.springframework</groupId>
        </exclusion>
      </exclusions>
      <!--可选依赖，此处为true，可以阻断依赖这个模块导入这个jar包
      比如 ： A，将spring设置为true, B依赖于A，此时spring在B中是没有的，依赖被阻断了
      -->
      <optional>true</optional>

      <!--依赖的分类器,分类器可以区分属于同一个POM，但不同构建方式的构件
      如果你想要构建两个单独的构件成 JAR，一个使用Java 1.4编译器，另一个使用Java 6编译器,
      你就可以使用分类器来生成两个单独的JAR构件
      -->
      <classifier/>
    </dependencies>
  </dependencyManagement>

  <!-- 构建项目,针对整个项目的所有情况都有效。该配置可以被 profile全部继承 -->
  <build>
    <!-- 项目的源码存放的地方，默认为src/main/java
    该路径是相对于pom.xml的相对路径 -->
    <sourceDirectory>src/java</sourceDirectory>
    <!--该元素设置了项目脚本源码目录 绝大多数情况下，该目录下的内容 会被拷贝到输出
    目录(因为脚本是被解释的，而不是被编译的) -->
    <scriptSourceDirectory/>
    <!-- 该元素设置了项目单元测试使用的源码目录，当测试项目的时候，构建系统会编译目录里的源码。
    该路径是相对于pom.xml的相对路径。 -->
    <testSourceDirectory/>

    <!--被编译过的应用程序class文件存放的目录。-->
    <outputDirectory/>

    <!--被编译过的测试class文件存放的目录。-->
    <testOutputDirectory/>

    <!--使用来自该项目的一系列构建扩展-->
    <extensions>
      <!--描述使用到的构建扩展。-->
      <extension>
        <!--构建扩展的groupId-->
        <groupId/>
        <!--构建扩展的artifactId-->
        <artifactId/>
        <!--构建扩展的版本-->
        <version/>
      </extension>
    </extensions>

    <!-- 当项目没有规定目标（Maven2 叫做阶段）时的默认值
      在命令行中执行 mvn，则相当于执行： mvn install
      -->
    <defaultGoal>install</defaultGoal>

    <!--构建产生的所有文件存放的目录 默认在 \\${basedir}/target 目录-->
    <directory>${basedir}/target</directory>

    <!--产生的构件的文件名，默认值是${artifactId}-${version}。-->
    <finalName>my-jar</finalName>

    <!--当filtering开关打开时，使用到的过滤器属性文件列表-->
    <filters>
        <!--定义在filter的文件中的name = value键值对，会在build时代替\${name} 值应用到
        resources标签中 ,既将resources标签内的\${name}替换成真正的内容,
        默认filter文件夹为\${basedir}/src/main/filters-->
        <filter>filters/filter1.properties</filter>
    </filters>

    <!--这个元素描述了项目相关的所有资源路径列表，例如和项目相关的属性文件，这些资源被包含在最终的打包文件里。-->
    <resources>
      <!--这个元素描述了项目相关或测试相关的所有资源路径-->
      <resource>
        <!-- 描述了资源的目标路径.该路径相对target/classes目录（例如${project.build.outputDirectory})
        举个例子，如果你想资源在特定的包里(org.apache.maven.messages)，你就必须该元素设置为org/apache/maven/messages。
        然而，如果你只是想把资源放到源码目录结构里，就不需要该配置-->
        <targetPath>META-INF</targetPath>
        <!--是否使用参数值代替参数名。参数值取自properties元素或者文件里配置的属性，文件在filters元素里列出。-->
        <filtering>true</filtering>
        <!--描述存放资源的目录，该路径相对POM路径-->
        <directory>${project.basedir}</directory>
        <!--包含的模式列表，例如**/*.xml.-->
        <includes>
          <include>LICENSE</include>
          <include>configuration.xml</include>
        </includes>
        <!--排除的模式列表，例如**/*.xml-->
        <excludes>
          <exclude>**/*.java</exclude>
        </excludes>

      </resource>
    </resources>

    <!--这个元素描述了单元测试相关的所有资源路径，例如和单元测试相关的属性文件。-->
    <testResources>
      <!--这个元素描述了测试相关的所有资源路径，参见build/resources/resource元素的说明-->
      <testResource>
        <targetPath/>
        <filtering/>
        <directory/>
        <includes/>
        <excludes/>
      </testResource>
    </testResources>

    <!-- 子项目可以引用的默认插件信息 该插件配置项直到被引用时才会被解析或绑定到生命周期
    给定插件的任何本地配置都会覆盖这里的配置-->
    <pluginManagement>
      <!--使用的插件列表 。-->
      <plugins>
        <!--plugin元素包含描述插件所需要的信息。-->
        <pluging>
          <!--插件在仓库里的group ID-->
          <groupId/>
          <!--插件在仓库里的artifact ID-->
          <artifactId/>
          <!--被使用的插件的版本（或版本范围）-->
          <version/>
          <!--是否从该插件下载Maven扩展（例如打包和类型处理器），由于性能原因，只有在真需要下载时，该元素才被设置成enabled。-->
          <extensions/>

          <!--在构建生命周期中执行一组目标的配置。每个目标可能有不同的配置。-->
          <executions>
            <!--execution元素包含了插件执行需要的信息-->
            <execution>
            <!--执行目标的标识符，用于标识构建过程中的目标，或者匹配继承过程中需要合并的执行目标-->
            <id/>
            <!--绑定了目标的构建生命周期阶段，如果省略，目标会被绑定到源数据里配置的默认阶段-->
            <phase/>
            <!--配置的执行目标-->
            <goals/>
            <!--配置是否被传播到子POM-->
            <inherited/>
            <!--作为DOM对象的配置-->
            <configuration/>
            </execution>
          </executions>
          <!--项目引入插件所需要的额外依赖-->
          <dependencies>
            <!--参见dependencies/dependency元素-->
            <dependency>......</dependency>
          </dependencies>
          <!--任何配置是否被传播到子项目-->
          <inherited/>
          <!--作为DOM对象的配置-->
          <configuration/>
        </plugin>
      </plugings>

    </pluginManagement>

    <!--使用的插件列表-->
    <plugins>
      <!--参见build/pluginManagement/plugins/plugin元素-->
      <plugin>
        <groupId/>
        <artifactId/>
        <version/>
        <!--是否加载plugin的extensions，默认为false  -->
        <extensions>false</extensions>
        <executions>
          <execution>
            <id/>
            <!-- 起作用的阶段 -->
            <phase/>
            <!--起作用的目标  -->
            <goals/>
            <!-- 子模块是否可以引用 -->
            <inherited/>
            <!-- 配置该plugin期望得到的properties -->
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

  <!--在列的项目构建profile，如果被激活，会修改构建处理-->
  <profiles>
    <!--根据环境参数或命令行参数激活某个构建处理-->
    <profile>
      <!--构建配置的唯一标识符。即用于命令行激活，也用于在继承时合并具有相同标识符的profile。-->
      <id/>
      <!--自动触发profile的条件逻辑。Activation是profile的开启钥匙。profile的力量来自于它
      能够在某些特定的环境中自动使用某些特定的值；这些环境通过activation元素指定。activation元素并不是激活profile的唯一方式。-->
      <activation>
        <!--profile默认是否激活的标志-->
        <activeByDefault/>
        <!--当匹配的jdk被检测到，profile被激活。例如，1.4激活JDK1.4，1.4.0_2，而!1.4激活所有版本不是以1.4开头的JDK。-->
        <jdk/>
        <!--当匹配的操作系统属性被检测到，profile被激活。os元素可以定义一些操作系统相关的属性。-->
        <os>
          <!--激活profile的操作系统的名字-->
          <name>Windows XP</name>
          <!--激活profile的操作系统所属家族(如 'windows')-->
          <family>Windows</family>
          <!--激活profile的操作系统体系结构 -->
          <arch>x86</arch>
          <!--激活profile的操作系统版本-->
          <version>5.1.2600</version>
        </os>
        <!--如果Maven检测到某一个属性（其值可以在POM中通过${名称}引用），其拥有对应的名称和值，Profile就会被激活。如果值
        字段是空的，那么存在属性名称字段就会激活profile，否则按区分大小写方式匹配属性值字段-->
        <property>
          <!--激活profile的属性的名称-->
          <name>mavenVersion</name>
          <!--激活profile的属性的值-->
          <value>2.0.3</value>
        </property>
        <!--提供一个文件名，通过检测该文件的存在或不存在来激活profile。missing检查文件是否存在，如果不存在则激活
        profile。另一方面，exists则会检查文件是否存在，如果存在则激活profile。-->
        <file>
          <!--如果指定的文件存在，则激活profile。-->
          <exists>/usr/local/hudson/hudson-home/jobs/maven-guide-zh-to-production/workspace/</exists>
          <!--如果指定的文件不存在，则激活profile。-->
          <missing>/usr/local/hudson/hudson-home/jobs/maven-guide-zh-to-production/workspace/</missing>
        </file>
      </activation>
      <!--构建项目所需要的信息。参见build元素-->
      <build>
			  <defaultGoal/>
        <resources>...</resources>
        <testResources>...</testResources>
        <directory/>
			  <finalName/>
			  <filters/>
        <pluginManagement>...</pluginManagement>
        <plugins>...</plugins>
      </build>

      <repositories>...</repositories>
      <pluginRepositories>...</pluginRepositories>
      <dependencies>...</dependencies>
      <reporting>...</reporting>
      <dependencyManagement>...</dependencyManagement>
      <distributionManagement>
        ...
      </distributionManagement>

      <!--参见properties元素-->
      <properties>...</properties>
    </profile>

  </profiles>

</project>
```
