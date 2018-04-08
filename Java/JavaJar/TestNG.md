# TestNG

## 01.入门

需要测试的类
```java
public class HelloWordGenerator {
    public String generateHelloWord() {
        return "Hello Word !";
    }
}
```
测试类
```java
public class HelloWordGeneratorTest {

    @Test
    public void testGenerateEmail() {
        HelloWordGenerator generator = new HelloWordGenerator();
        String str = generator.generateHelloWord();
        // 不为空判断
        Assert.assertNotNull(str);
        // 相同判断
        Assert.assertEquals(str, "Hello Word !");
    }

}
```

配置文件
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE suite SYSTEM "http://testng.org/testng-1.0.dtd">
<suite name="HelloWordGeneratorSuite">
    <test name="HelloWordGeneratorTest">
        <classes>
            <class name="com.eigpay.test.HelloWordGeneratorTest"/>
        </classes>
    </test>
</suite>

```


## 02.注解的运行顺序

```java
@Test(groups = "base-group")
public class AnnotaionLifeCycleTest {

    @BeforeSuite
    public void beforeSuite() {
        System.out.println("@BeforeSuite执行了");
    }

    @BeforeTest
    public void beforeTest() {
        System.out.println("@BeforeTest执行了");
    }

    @BeforeClass
    public void beforeClass() {
        System.out.println("@BeforeClass执行了");
    }

    /** 如果想要使 group相关的注解起作用，需要指定groups属性 */
    @BeforeGroups(groups = "base-group")
    public void beforeGroups() {
        System.out.println("@BeforeGroups执行了");
    }

    /** method相关的注解比较特殊，其他的注解只在整个测试过程运行一次，但是method会在每个test方式执行都执行一次 */
    @BeforeMethod
    public void beforeMethod() {
        System.out.println("@BeforeMethod执行了");
    }

    @Test
    public void test01() {
        System.out.println("@Test执行了");
    }

    @AfterMethod()
    public void afterMethod() {
        System.out.println("@AfterMethod执行了");
    }

    @AfterGroups(groups = "base-group")
    public void afterGroups() {
        System.out.println("@AfterGroups执行了");
    }

    @AfterClass
    public void afterClass() {
        System.out.println("@AfterClass执行了");
    }

    @AfterTest
    public void afterTest() {
        System.out.println("@AfterTest执行了");
    }

    @AfterSuite
    public void afterSuite() {
        System.out.println("@AfterSuite执行了");
    }
}

```

配置文件

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE suite SYSTEM "http://testng.org/testng-1.0.dtd">
<suite name="AnnotaionLifeCycleSuite">
    <test name="AnnotaionLifeCycleTest">
        <groups>
            <run>
                <include name="base-group" />
            </run>
        </groups>
        <classes>
            <class name="com.eigpay.test.AnnotaionLifeCycleTest">
            </class>
        </classes>
    </test>
</suite>

```

结果
```xml
@BeforeSuite执行了
@BeforeTest执行了
@BeforeClass执行了
@BeforeGroups执行了
@BeforeMethod执行了
@Test执行了
@AfterMethod执行了
@AfterGroups执行了
@AfterClass执行了
@AfterTest执行了
@AfterSuite执行了
```

## 03.Group 讲解
在每个注解的属性里面都有一个`groups`属性，说明这个注解属于哪个组，当运行了某个组，如果这个注解属于这个组，那么这个注解就会执行。
总的作用就是：分类，运行测试时，哪些方法可以运行，哪些不可以。

#### 定义组的方式有2种
##### 方式一
在测试类的注解进行声明

```java
@Test(groups = {"base-group"})
public class Test {

	@Test(groups = {"group01", "group03"})
    public void test01() {
        System.out.println("@Test01注解");
    }

    @Test(groups = {"group02"})
    public void test02() {
        System.out.println("@Test02注解");
    }

    @Test
    public void test03() {
    	System.out.println("@Test03注解");
    }
}

```

> 1. 一个注解可以属于多个组
> 2. 类也可以声明为组，则这个类里面的所有的注解都会默认属于这个组,上面的例子的效果等同于下面(在注解原先的注解上多了一个组)

```java
public class Test {

    @Test(groups = {"group01", "group03", "base-group"})
    public void test01() {
        System.out.println("@Test01注解");
    }

    @Test(groups = {"group02", "base-group"})
    public void test02() {
        System.out.println("@Test02注解");
    }

    @Test(groups = {"base-group"})
    public void test03() {
    	System.out.println("@Test03注解");
    }
}
```

`运行组最终还是需要依靠配置文件`

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE suite SYSTEM "http://testng.org/testng-1.0.dtd">
<suite name="AnnotaionLifeCycleSuite">
    <test name="AnnotaionLifeCycleTest">
    	<!--
    	运行AnnotaionLifeCycleTest里面的包含group01，不包含group02的组, 当include和exclude有重叠的部分，组exlude的部分
    	所以当某个注解属于group01，也属于group02，则这个注解将不会被执行
    	-->
		<groups>
		    <run>
		        <include name="group01" />
		        <exclude name="group02" />
		    </run>
		</groups>

		<classes>
            <class name="com.eigpay.test.AnnotaionLifeCycleTest" />
        </classes>
    </test>
</suite>

```

##### 方式二
方式二最终还是依靠于方式一,我们在方式一基础上进行重新定义组

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE suite SYSTEM "http://testng.org/testng-1.0.dtd">

<suite name="AnnotaionLifeCycleSuite">
    <test name="AnnotaionLifeCycleTest">
    	<groups>
    		<define name="new-group">
		      	<include name="group01"/>
		      	<include name="group02"/>
		    </define>

		     <run>
		      	<include name="all"/>
		    </run>
    	</groups>
    </test>
<suite>

```

一开始注解上面已经有相应的组了，现在我们新建了一个组"new-group"，他包含了注解里面有"group01"和"group02"的注解。所以此时属于"new-group"的有方法test01和方法test02。

##### 分析
TestNG的运行方式有2种。一种是直接运行测试类，一种是运行测试文件。
> 1. 直接运行测试类，@BeforeGroups和@AfterGroups是没法执行到的，但是其他的生命周期注解都可以运行到
> 2. 在配置文件中如果我们排除某个组，里面包含方法A，但是在class的methods的include了这个方法A，方法A最终还是会执行到。
> 3. 如果我们配置文件里面没有配置运行组，只配置了相应的方法，那么运行时，对应的生命周期的注解可以一一运行，但是如果配置
了组运行的话，注解里面没有指定对应的组，这个注解是不会执行到的。
> 4. 所以，最终测试是以类的形式运行，还是配置文件，如果是配置文件的话，是以组运行，还是以类，需要考虑好。

## 04.异常捕获同时测试通过
```java
@Test(expectedExceptions = {ArithmeticException.class, UnsupportedOperationException.class})
public void testException() {
    int a = 10 / 0;
    System.out.println(a+"多少");
}
```
如果testException方法抛出了ArithmeticException或者UnsupportedOperationException异常这个方法是正确的，如果没有这是错误的(异常也可以为自定义的)

## 05.忽略某个测试方法
```java
@Test(enabled = false)
public void test01() {
    System.out.println("test01");
}
```
在需要忽略的测试方法上面添加`enabled=false`就能跳过这个测试方法

## 06.超时测试
```java
@Test(timeOut = 5000)
public void noTimeoutTest() throws InterruptedException {
    Thread.sleep(4000);
}

@Test(timeOut = 300)
public void timeoutTest() {
    while (true){
        // do nothing
    }
}
```
测试某个方法是否会超时时，可以在test标签里面添加`timeOut = 时间` 来进行测试

## 07.分组测试
有一个方法A,A的执行前提是组G01和G02执行完成了才会进行，
```java
public class GroupTest {

    @BeforeGroups("database")
    public void setupDB() {
        System.out.println("setupDB()");
    }

    @AfterGroups("database")
    public void cleanDB() {
        System.out.println("cleanDB()");
    }

    @Test(groups = "transcation")
    public void runTransaction() {
        System.out.println("transcation");
    }

    @Test(groups = "transcation")
    public void runTransaction01() {
        System.out.println("transcation01");
    }

    @Test(groups = "database")
    public void testConnectDB() {
        System.out.println("testConnectDB");
    }

    @Test(groups = "database")
    public void testUseSQL() {
        System.out.println("testUserSQL");
    }

    /** dependsOnGroups 指定这个方法的执行需要依赖哪些组 */
    @Test(dependsOnGroups = { "database", "transcation" })
    public void runFinal() {
        System.out.println("runFinal");
    }
}
```
> 1. `runTransaction01`和`runTransaction`属于分组`transcation`
> 2. `testConnectDB`和`testUseSQL0`属于分组`database`
> 3. 分组`transcation`和`database`都执行成功了，方法`runFinal`才会执行

## 08.套件(suite)测试
套件测试需要依靠配置文件，因为我们无法在代码里面进行配置。
套件suite的属性

|属性 | 描述 | 
| -   |  :- | 
|name |强制属性，指定这个条件的名字|
|verbose      |运行的级别或详细程度                              |
|parallel     |TestNG是否运行不同的线程来运行这个套件             |
|thread-count | 如果启用并行模式(忽略其他方式)，则要使用的线程数   |
|annotations  | 在测试中使用的注释类型                           |
|time-out     | 在本测试中的所有测试方法上使用的默认超时           |


先声明三个基础的类作为准备工作

```java
public class TestConfig {

    @BeforeSuite
    public void testBeforeSuite() {
        System.out.println("testBeforeSuite()");
    }

    @AfterSuite
    public void testAfterSuite() {
        System.out.println("testAfterSuite()");
    }

    @BeforeTest
    public void testBeforeTest() {
        System.out.println("testBeforeTest()");
    }

    @AfterTest
    public void testAfterTest() {
        System.out.println("testAfterTest()");
    }
}


public class TestDatabase {

    @Test(groups = "db")
    public void testConnectOracle() {
        System.out.println("testConnectOracle()");
    }

    @Test(groups = "db")
    public void testConnectMsSQL() {
        System.out.println("testConnectMsSQL");
    }

    @Test(groups = "db-nosql")
    public void testConnectMongoDB() {
        System.out.println("testConnectMongoDB");
    }

    @Test(groups = { "db", "brokenTests" })
    public void testConnectMySQL() {
        System.out.println("testConnectMySQL");
    }

}

public class TestOrder {

    @Test(groups={"orderBo", "save"})
    public void testMakeOrder() {
        System.out.println("testMakeOrder");
    }

    @Test(groups={"orderBo", "save"})
    public void testMakeEmptyOrder() {
        System.out.println("testMakeEmptyOrder");
    }

    @Test(groups="orderBo")
    public void testUpdateOrder() {
        System.out.println("testUpdateOrder");
    }

    @Test(groups="orderBo")
    public void testFindOrder() {
        System.out.println("testFindOrder");
    }

}
```

配置文件: 以class的形式运行
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE suite SYSTEM "http://testng.org/testng-1.0.dtd">
<suite name="TestAll">
  <test name="order">
      <classes>
          <class name="com.eigpay.test.suite.TestConfig" />
          <class name="com.eigpay.test.suite.TestOrder" />
      </classes>
  </test>

  <test name="database">
      <classes>
          <class name="com.eigpay.test.suite.TestConfig" />
          <class name="com.eigpay.test.suite.TestDatabase" />
      </classes>
  </test>
</suite>
```

运行结果
```xml
testBeforeSuite()
testBeforeTest()
testFindOrder()
testMakeEmptyOrder()
testMakeOrder()
testUpdateOrder()
testAfterTest()
testBeforeTest()
testConnectMongoDB()
testConnectMsSQL()
testConnectMySQL()
testConnectOracle()
testAfterTest()
testAfterSuite()
```
有的生命周期注解的执行次数和配置文件标签的个数有关，一个suite只执行了一个，2个test执行了2次test生命周期

配置文件: 以包的形式运行
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE suite SYSTEM "http://testng.org/testng-1.0.dtd">
<suite name="TestAll">
    <test name="order">
        <packages>
            <package name="com.eigpay.test.suite.*" />
        </packages>
    </test>
</suite>
```

结果
```xml
testBeforeSuite()
testBeforeTest()
testConnectMongoDB()
testConnectMsSQL()
testConnectMySQL()
testConnectOracle()
testFindOrder()
testMakeEmptyOrder()
testMakeOrder()
testUpdateOrder()
testAfterTest()
testAfterSuite()
```

配置文件: 以组的形式运行
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE suite SYSTEM "http://testng.org/testng-1.0.dtd">
<suite name="TestAll">
    <test name="database">
        <groups>
            <run>
                <exclude name="brokenTests" />
                <include name="db" />
            </run>
        </groups>
        <classes>
            <class name="com.eigpay.test.suite.TestDatabase" />
        </classes>
    </test>
</suite>
```
结果
```xml
testConnectMsSQL()
testConnectOracle()
```

## 09.依赖测试
> 1.可以按照特定顺序调用测试用例中的方法,

> 2.在方法之间共享一些数据和状态

`dependsOnMethods`和`dependsOnGroups`可以实现方法或者租之间的依赖

`dependsOnMethods`方法级别的依赖，上一个方法执行失败了,下一个方法是不会执行的
```java
public class DependenceTest {
    @Test
    public void method1() {
        System.out.println("This is method 1");
    }

    @Test(dependsOnMethods = { "method1" })
    public void method2() {
        System.out.println("This is method 2");
    }
}
```

`dependsOnGroup`在一开始的分组讲过了

## 09.参数化测试

##### xml提供数据
```java
@Test
@Parameters({ "dbconfig", "poolsize" })
public void createConnection(String dbconfig, int poolsize) {
    System.out.println("数据库配置文件 : " + dbconfig);
    System.out.println("连接池的数量 : " + poolsize);

    String path = System.getProperty("user.dir")+"\\src\\test\\resources\\"+dbconfig;
    System.out.println("数据库配置文件的地址 ："+path);
}
```

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE suite SYSTEM "http://testng.org/testng-1.0.dtd">
<suite name="test-parameter">
    <test name="example1">
        <parameter name="dbconfig" value="db.properties" />
        <parameter name="poolsize" value="10" />
        <classes>
            <class name="com.eigpay.test.parameterization.XmlTest" />
        </classes>
    </test>
</suite>
```
结果
```xml
数据库配置文件 : db.properties
连接池的数量 : 10
数据库配置文件的地址 ：F:\MyProject\exercise-project\test-testng\src\test\resources\db.properties
```

##### @DataProvider提供参数
```java
public class ParameterDataProviderTest {
    @DataProvider(name = "provideNumbers")
    public Object[][] provideData() {
        return new Object[][] { { 10, 20 }, { 100, 110 }, { 200, 210 } };
    }

    @DataProvider(name = "dbconfig")
    public Object[] provideDbConfig() {
        Map<String, String> map = new HashMap<>(16);
        map.put("a", "123");
        map.put("b", "234");
        return new Object[]{ map };
    }


    @Test(dataProvider = "provideNumbers")
    public void test(int number, int expected) {
        System.out.println("Number: "+ number + "  Number: "+ expected);
    }

    @Test(dataProvider = "dbconfig")
    public void testConnection(Map<String, String> map) {
        for (Map.Entry<String, String> entry : map.entrySet()) {
            System.out.println("[Key] : " + entry.getKey() + " [Value] : " + entry.getValue());
        }
    }
}
```
结果
```
Number: 10  Number: 20
Number: 100  Number: 110
Number: 200  Number: 210

[Key] : a [Value] : 123
[Key] : b [Value] : 234
```

##### @DataProvider+Method提供参数(可以根据不同的测试方法给予不同的数据)
```java
public class ParameterDataProvider3Test {

    /** 如果dataProvider没有指定对应的name属性，默认为方法名 */
    @DataProvider(name = "provideNumbers")
    public Object[][] provideNumbers(Method method) {
        Object[][] result = null;
        if (method.getName().equals("two")) {
            result = new Object[][] { new Object[] { 2 }};
        }
        else if (method.getName().equals("three")) {
            result = new Object[][] { new Object[] { 3 }};
        }
        return result;
    }

    @Test(dataProvider = "provideNumbers")
    public void two(int param) {
        System.out.println("Two received: " + param);
    }

    @Test(dataProvider = "provideNumbers")
    public void three(int param) {
        System.out.println("Three received: " + param);
    }
}
```
结果
```xml
Three received: 3
Two received: 2
```
##### @DataProvider+ITestContext提供参数(可以根据不同的组给予不同的数据)
```java
public class ParameterDataProvider4Test {

    @DataProvider(name = "dataProvider")
    public Object[][] provideData(ITestContext context) {
        Object[][] result = null;
        for (String group : context.getIncludedGroups()) {
            System.out.println("group : " + group);
            if ("groupA".equals(group)) {
                result = new Object[][] { { 1 } };
                break;
            }
        }
        if (result == null) {
            result = new Object[][] { { 2 } };
        }
        return result;
    }

    @Test(dataProvider = "dataProvider", groups = {"groupA"})
    public void test1(int number) {
        System.out.println(number+"");
    }

    @Test(dataProvider = "dataProvider", groups = "groupB")
    public void test2(int number) {
        System.out.println(number+"");
    }

}
```
配置文件
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE suite SYSTEM "http://testng.org/testng-1.0.dtd">
<suite name="test-parameter">
    <test name="example1">
        <groups>
            <run>
                <include name="groupA" />
            </run>
        </groups>
        <classes>
            <class name="com.eigpay.test.parameterization.ParameterDataProvider4Test" />
        </classes>
    </test>
</suite>
```
结果
```xml
group : groupA
1
```

## 10.负载测试
```java

public class MultipleThreadsTest {

    /** invocationCount 指定调用的次数为3次 */
    @Test(invocationCount = 3)
    public void loadTestThisWebsite() {
        System.out.println("你好");
    }

    /** 用3个线程池进行这个方法10次 */
    @Test(invocationCount = 10, threadPoolSize = 3)
    public void testThreadPools() {
        System.out.printf("线程Id : %s%n", Thread.currentThread().getId());
    }
}

```

## 11.和Spring整合
```java
@ContextConfiguration(locations = { "classpath:spring-test-config.xml" })
public class SpringTest extends AbstractTestNGSpringContextTests {

    @Autowired
    private SpringInterface springInterface;

    @Test
    public void testSaySpring() {
        String str = springInterface.saySpring();
        System.out.println(str);
        Assert.assertEquals(str, "Spring");
    }
}
```
> 1.需要依赖`spring-test`

> 2.测试类需要继承AbstractTestNGSpringContextTests类

> 3.指定配置文件@ContextConfiguration(locations=“”)
