# build标签
  作用: 相当于pom的配置文件
  ****
  在 POM 4.00 XSD中，build 元素可以划分为两种级别的构建
    **1.基本构建： BaseBuild   2.正常构建： Build** 
    正常构建又可以划分为2个
    **1.project build（针对整个项目的所有情况都有效。该配置可以被 profile 全部继承）**
    **2.profile build（用于重写覆盖掉 project build 中的配置，是 project build 的子集）**
  
  ```xml
  <project xmlns="http://maven.apache.org/POM/4.0.0"    
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"    
    xsi:schemaLocation="http://maven.apache.org/POM/4.0.0    
    http://maven.apache.org/maven-v4_0_0.xsd">
    
    <!-- Project Build 除了包含 BaseBuild 集合外，还包含其它构建元素 -->
    <build>…</build>
    
    <!-- Profile Build 是 Project Build 的子集 -->
    <profiles>    
      <profile>  
        <build>…</build>    
      </profile>    
    </profiles> 
  </project>
  
  ```
  
  
  ### 配置说明1
  ```xml
    <build>    
          <defaultGoal>install</defaultGoal>    
          <directory>${basedir}/target</directory>    
          <finalName>${artifactId}-${version}</finalName>    
          <filters>    
                  <filter>filters/filter1.properties</filter>    
          </filters>    
           ...    
    </build>
  ```
   **1. defaultGoal**
  执行 mvn 命令时，如果没有指定目标，指定使用的默认目标。 如上配置：在命令行中执行 mvn，则相当于执行： mvn install 
  
 **2. directory** 
   目标文件的存放目录，默认在 \\${basedir}/target 目录
   
**3.finalName**
   目标文件的名称，默认情况为 \\${artifactId}-${version} 
   
 **4.filter**
定义在filter的文件中的name = value键值对，会在build时代替\${name} 值应用到 resources标签   中 ,既将resources标签内的\${name}替换成真正的内容,  
   maven的默认filter文件夹为\${basedir}/src/main/filters 
   
   ### 配置说明2
  ```xml
    <build>    
        ...    
         <resources>    
             <resource>    
                  <targetPath>META-INF/plexus</targetPath>    
                  <filtering>false</filtering>    
                  <directory>${basedir}/src/main/plexus</directory>    
                  <includes>    
                      <include>configuration.xml</include>    
                  </includes>    
                  <excludes>    
                      <exclude>**/*.properties</exclude>    
                  </excludes>    
           </resource>    
      </resources>    
      <testResources>    
          ...    
      </testResources>    
    </build>
  ```
  **1.resources**
  一个resources元素的列表,用于包含或者排除某些资源文件(资源文件通常不是源代码，如xml文件，properties文件等，当然有特殊要求，也可以直接将源码包含在内)，包含内容（编译时仅复制指定包含的内容）
  
  **2.targetPath**
  指定build后的resource存放的文件夹，默认是basedir，通常被打包在jar中的resources的目标路径是  META-INF 
  
  **3.filtering**
   true/false，表示这个resource是否过滤
   
  **4.directory**
  定义resource文件所在的文件夹，默认为： ${basedir}/src/main/resources
  
  **5.includes**
  指定哪些文件将被匹配，以*作为通配符
  
  **6.excludes**
  指定哪些文件将被忽略 
  
  **7.testResources**
  定义和resource类似，只不过在test时使用 
  
  
  ### 配置说明3
  ```xml
  <resources> 
    <resource>  
         <directory>  
             ${basedir}/src/main/content/META-INF  
         </directory>  
         <targetPath>../vault-work/META-INF</targetPath>  
         <filtering>true</filtering>  
     </resource>  
     <resource>  
         <directory>  
             ${basedir}/src/main/content/jcr_root  
         </directory>  
         <excludes>  
             <!-- 用法1：不包括一整个目录-->  
             <exclude>apps/ui/**</exclude>    
    
             <!-- 用法2：不包括某类文件（所有路径下）-->    
             <exclude>**/*.jpg</exclude>  
    
             <!-- 用法3：不包括某个文件（所有路径下）-->  
             <exclude>**/.DS_Store</exclude>  
         </excludes>  
         <targetPath>.</targetPath>  
         <filtering>false</filtering>  
     </resource>
  </resources>
  ```
  
  ### 配置说明4
  ```xml
    ...    
      <plugins>    
          <plugin>    
              <groupId>org.apache.maven.plugins</groupId>    
              <artifactId>maven-jar-plugin</artifactId>    
              <version>2.0</version>    
              <extensions>false</extensions>    
              <inherited>true</inherited>    
              <configuration>    
                  <classifier>test</classifier>    
              </configuration>    
              <dependencies>...</dependencies>    
              <executions>...</executions>    
          </plugin>    
      </plugins>
  ```
  **1.GAV (groupId, artifactId, version)**
  指定插件的标准坐标
  
  **2.extensions**
  是否加载plugin的extensions，默认为false 
  
  **3.inherited**
   true/false，这个plugin是否应用到该pom的孩子pom，默认为true 
   
  **4.configuration**
  配置该plugin期望得到的properties 
  
  **5.dependencies**
  作为plugin的依赖
  
  **6.executions**
  plugin可以有多个目标，每一个目标都可以有一个分开的配置，可以将一个plugin绑定到不同的阶段 
  假如绑定antrun：run目标到verify阶段 
  
  ### 配置说明5
  ```xml
  <build>    
      <plugins>    
          <plugin>    
              <artifactId>maven-antrun-plugin</artifactId>    
              <version>1.1</version>    
              <executions>    
                  <execution>    
                      <id>echodir</id>    
                      <goals>    
                          <goal>run</goal>    
                      </goals>    
                      <phase>verify</phase>    
                      <inherited>false</inherited>    
                      <configuration>    
                          <tasks>    
                              <echo>Build Dir: ${project.build.directory}</echo>    
                          </tasks>    
                      </configuration>    
                  </execution>    
              </executions>    
          </plugin>    
      </plugins>    
  </build> 
  ```
  **1. id**
  标识，用于和其他 execution 区分 当这个阶段执行时，它将以这个形式展示\\[plugin:goal execution:id],举例：在这里为：\\[antrun:run execution:echodir] 
  
  **2. goals**
  目标列表 
  
  **3.phase**
  目标执行的阶段 
  
  **4.inherit**
  子类pom是否继承
  
  **5.configuration**
  在指定目标下的配置
  
  ### 配置说明6
  ```xml
  <build>    
      ...    
      <pluginManagement>    
          <plugins>    
              <plugin>    
                <groupId>org.apache.maven.plugins</groupId>    
                <artifactId>maven-jar-plugin</artifactId>    
                <version>2.2</version>    
                  <executions>    
                      <execution>    
                          <id>pre-process-classes</id>    
                          <phase>compile</phase>    
                          <goals>    
                              <goal>jar</goal>    
                          </goals>    
                          <configuration>    
                              <classifier>pre-process</classifier>    
                          </configuration>    
                      </execution>    
                  </executions>    
              </plugin>    
          </plugins>    
      </pluginManagement>    
      ...    
  </build> 
  ```
  **1.pluginManagement**
  和dependencyManagement作用类似，在主pom配置好后，子pom就可以不用理会配置了
  
  子pom
  ```xml
  <build>    
      ...    
      <plugins>    
          <plugin>    
              <groupId>org.apache.maven.plugins</groupId>    
              <artifactId>maven-jar-plugin</artifactId>    
          </plugin>    
      </plugins>    
      ...    
  </build>
  ```