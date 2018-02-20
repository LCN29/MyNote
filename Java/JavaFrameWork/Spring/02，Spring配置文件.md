# 02，Spring配置文件

## 01,注入

**xml**文件

```xml
  <?xml version="1.0" encoding="UTF-8"?>
  <beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    xsi:schemaLocation="http://www.springframework.org/schema/beans 
      http://www.springframework.org/schema/beans/spring-beans.xsd">
      
      <bean id="injectionDao" class="com.injection.dao.InjectionDaoImpl"></bean>
      
      <!-- 取值注入 类中有对应的set方法，可以直接给正式属性赋值 name对应了类中的某个属性名
      <bean id="injectionService" class="com.injection.service.InjectionServiceImpl">
        <property name="injectionDao" ref="injectionDao"></property>
      </bean> -->
      
      <!-- 构造注入 直接将属性注入到属性中 -->
      <bean id="injectionService" class="com.injection.service.InjectionServiceImpl">
        <constructor-arg name="injectionDao" ref="injectionDao"></constructor-arg>
      </bean>	    
  </beans>
```

**dao层**

```java
  //数据操作类的接口
  public interface InjectionDao {
    public void save(String arg);
  }
  
  public class InjectionDaoImpl implements InjectionDao {
	
	@Override
	public void save(String arg) {
      // TODO Auto-generated method stub
      System.out.println("保存数的数据:"+arg);
    }
  }
```
**service层**

```java
  //服务层接口
  public interface InjectionService {
    public void input(String arg);
  }
  
  
  //接口实现类
  public class InjectionServiceImpl implements InjectionService {
    private InjectionDao injectionDao;

    //构造函数注入 给构造函数的属性赋值
    public InjectionServiceImpl(InjectionDao injectionDao) {
      // TODO Auto-generated constructor stub
      this.injectionDao= injectionDao;
    }

    @Override
    public void input(String arg) {
      System.out.println("数据输入"+arg);
      arg= arg+hashCode();
      injectionDao.save(arg);
    }

  /*	//1，设值注入 给某个属性赋值，
    public void setInjectionDao(InjectionDao injectionDao) {
      this.injectionDao = injectionDao;
    }*/
  }
```

## 02,自动装配

**xml**文件

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
	xsi:schemaLocation="http://www.springframework.org/schema/beans 
  http://www.springframework.org/schema/beans/spring-beans.xsd"
  default-autowire="byName" >
  
  <bean id="autoWiringDao" class="com.autowriting.AutoWiringDao"></bean>
  
  <!-- 
	  以前的做法	一个类引用了其他类做属性 如service需要一个dao的属性
	  <bean id="autoWiringService" class="com.autowriting.AutoWiringService">
		  <property name="dao" ref="autoWiringDao"></property>
	  </bean>
  -->
 
 
  <!--
 		 111, 现在只需要声明defaul-autowire="byName"(和id挂钩)
     1，引用的类的某个属性的类型在这个配置文件中有声明 
     2，这个属性，有对应的set方法
     3，这个属性的属性名和配置文件中对应的类的id名一致

 		 如
     (1)service 类中有 Dao类的属性的属性: Dao dao;
     (2)Dao dao,有自己的set方法  setDao();
     (3)Dao 在配置文件中已经声明 <bean class="Dao"></bean>
     (4) Dao dao 的属性名dao和配置文件的<bean id="dao"></beans>的id一致
 		 就不用配置property属性
 	  -->
    <bean id="autoWiringService" class="com.autowriting.AutoWiringService"></bean>
    
    <!--
      222, default-autowire其他的类型
      byType :当bean中的某个属性的类型在这个配置文件中声明了，就自动装配
      constructor: 当bean的构造函数中，对应的参类型和这个配置文件中声明的bean中
      有类型一致的，就自动装配
    -->
    
    <!--
      3, 如果只想针对某个类起到自动装配，只需要在这个bean中加上 autowire
      <bean autowire="byName" ></bean>
    -->
  
</beans>
```

## 03, bean的作用范围

```xml
  <?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
	xsi:schemaLocation="http://www.springframework.org/schema/beans 
		http://www.springframework.org/schema/beans/spring-beans.xsd">
    
    <!-- scope bean的作用域范围，默认单例模式singleton -->
    <!-- prototype 每次请求都会创建一个新的 既每次getBean都是不同的bean对象 -->
    <!--
      scope的其他属性(针对的是http的)
      request 每次http请求都会创建一个实例，并且仅在当前的request中有效
      session 每次http请求创建，当前的session有效
      global session 基于portlet的web有效，如果在web中相对于session
    -->
    <bean id="beanScope" class="com.beanscope.BeanScope" scope="prototype"></bean>
</beans>
```

## 04, bean的生命周期(要在bean的创建或者销毁时，执行某些行为)
**三种方式**

**方式一 继承InitializingBean(初始执行),DisposableBean(销毁执行)**
```java
  public class BeanLifeCycleTwo implements InitializingBean,DisposableBean {
    //注意这个类还是需要注册在配置文件中的
    @Override
    public void afterPropertiesSet() throws Exception {
      // TODO Auto-generated method stub
      System.out.println("BeanTwo 初始");
    }
    
    @Override
    public void destroy() throws Exception {
      // TODO Auto-generated method stub
      System.out.println("BeanTwo 销毁");
    }
  }
```


**方式二 在bean中显示声明初始和销毁方法**
```xml

  <bean id="beanLifeCycleOne" class="com.lifecycle.BeanLifeCycleOne" init-method="init" destroy-method="destroy" ></bean>
```

```java
  public class BeanLifeCycleOne {
	
    public void init() {
      System.out.println("BeanOne初始");
    }

    public void destroy(){
      System.out.println("BeanOne销毁");
    }
  }
```

**方式三 在beans中配置全局的**

```xml
  <beans default-destroy-method="init" default-init-method="destory"></beans>
```
然后和方式二一样，在类中声明名字一样的方法


**执行顺序**
当三种方式同时出现是:执行顺序为 接口的方法==》自定义的初始方法==》全局的配置方法（对应的方法不会被执行）

**注意**

(1)在设置了全局的方法时,还设置了其他2种生命周期方式，类中没有全局的配置方法也可以
(2)声明了全局的配置方法，没有其他的声明生命周期的方式，即使类中没有,对应的方法声明，不影响bean的执行


## 05,获取application

**实现ApplicationContextAware这个接口**

```java
  public class MyApplicationContextAware implements ApplicationContextAware {
    //记得把这个类注册到配置文件
    private ApplicationContext applicationContext;
    
    @Override
    public void setApplicationContext(ApplicationContext arg0) throws BeansException {
      // TODO Auto-generated method stub
      System.out.println(arg0.getBean("MyApplicationContextAware"));
      this.applicationContext= arg0;
    }
  }
```

**还有一个类型的接口BeanNameAware**

```java
  public class MyBeanNameAware implements BeanNameAware{

    @Override
    public void setBeanName(String arg0) {
      // TODO Auto-generated method stub
      System.out.println("我的名字"+arg0); //arg0:这个类的名字
    }
  }
```

## 06,Resources的使用

```java
  public class MyResource implements ApplicationContextAware{
    private ApplicationContext applicationContext;
    
    // 所有的Application Context 都实现了ResourceLoader的接口，
    // 可以通过 getResource(String location);获取对应的资源
    
    @Override
    public void setApplicationContext(ApplicationContext arg0) throws BeansException {
      // TODO Auto-generated method stub
      this.applicationContext= arg0;
    }
    
    public void getResoure(){
      // file: 直接读取磁盘文件
      //	Resource resource= applicationContext.getResource("file:C:\\新建文本文档.txt");
      
      // classpath: 读取classpath里面的文件
      //  Resource resource= applicationContext.getResource("classpath:spring/resource-test.txt");
      
      // url: 读取网络资源
      //	Resource resource= applicationContext.getResource("url:https://www.baidu.com");
      
        Resource resource= applicationContext.getResource("spring/resource-test.txt");
        //当读取的文件没有前缀时,这个文件依赖于applicationContext的创建方式
        // 如application的创建为 new ClassPathXmlApplicationContext("classpath:spring/spring.xml");
        //用的是classpath:  这个文件的前缀就定为 classpath;
        
        System.out.println(resource.getFilename());
          try {
            System.out.println(resource.contentLength());
          }catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
          }
    }
    
    
  }
```







