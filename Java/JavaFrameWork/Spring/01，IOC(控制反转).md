# 01，IOC(控制反转)
## 介绍
`IOC: Inversion of Control，即“控制反转”，不是什么技术，而是一种设计思想。在Java开发中，Ioc意味着将你设计好的对象交给容器控制，而不是传统的在你的对象内部直接控制。` 在平时的java应用开发中，我们要实现某一个功能或者说是完成某个业务逻辑时至少需要两个或以上的对象来协作完成。每个对象在需要使用他的合作对象时，自己均要使用像new object() 这样的语法来将合作对象创建出来，这个合作对象是由自己主动创建出来的，创建合作对象的主动权在自己手上，自己需要哪个合作对象，就主动去创建，创建合作对象的主动权和创建时机是由自己把控的，而这样就会使得对象间的耦合度高了，A对象需要使用合作对象B来共同完成一件事，A要使用B，那么A就对B产生了依赖，也就是A和B之间存在一种耦合关系，并且是紧密耦合在一起，而使用了Spring之后就不一样了，`创建合作对象B的工作是由Spring来做的`，Spring创建好B对象，`然后存储到一个容器里面`，当A对象需要使用B对象时，Spring就从存放对象的那个容器里面取出A要使用的那个B对象，然后交给A对象使用。至于Spring是如何创建那个对象，以及什么时候创建好对象的，A对象不需要关心这些细节问题(你是什么时候生的，怎么生出来的我可不关心，能帮我干活就行)，A得到Spring给我们的对象之后，两个人一起协作完成要完成的工作即可。

## DI
`DI: Dependency Injection，即“依赖注入”`组件之间依赖关系由容器在运行期决定，形象的说，即由容器动态的将某个依赖关系注入到组件之中。依赖注入的目的并非为软件系统带来更多功能，而是为了提升组件重用的频率，并为系统搭建一个灵活、可扩展的平台。理解DI的关键是：“谁依赖谁，为什么需要依赖，谁注入谁，注入了什么”，那我们来深入分析一下：
  >谁依赖于谁：当然是`应用程序依赖于IoC容器`
  >为什么需要依赖：`应用程序需要IoC容器来提供对象需要的外部资源`
  >谁注入谁: 很明显是`IoC容器注入应用程序某个对象，应用程序依赖的对象`
  >注入了什么: 就是注入`某个对象所需要的外部资源（包括对象、资源、常量数据）`
  
`IoC的一个重点是在系统运行中，动态的向某个对象提供它所需要的其他对象。这一点是通DI（Dependency Injection，依赖注入）来实现的。` 比如对象A需要操作数据库，以前我们总是要在A中自己编写代码来获得一个Connection对象，有了 spring我们就只需要告诉spring，A中需要一个Connection，至于这个Connection怎么构造，何时构造，A不需要知道。在系统运行时，spring会在适当的时候制造一个Connection，然后像打针一样，注射到A当中，这样就完成了对各个对象之间关系的控制。那么DI是如何实现的呢？ Java 1.3之后一个重要特征是反射（reflection），它允许程序在运行的时候动态的生成对象、执行对象的方法、改变对象的属性，spring就是通过反射来实现注入的。

## IoC和DI由什么关系呢？
`其实它们是同一个概念的不同角度描述。`由于控制反转概念比较含糊（可能只是理解为容器控制对象这一个层面，很难让人想到谁来维护对象关系），所以2004年大师级人物Martin Fowler又给出了一个新的名字：“依赖注入”，相对IoC 而言，“依赖注入”明确描述了“被注入对象依赖IoC容器配置依赖对象”。

## 讲解
假设现在有个场景: 一部喜剧，由刘德华饰演主角。做的事是说了一句话:你好。

### 情况一
```java
public class Drama { 
  public void start(){
    LiuDeHua Liu= new LiuDeHua();
    liu.say("你好");
  }
}
```
由上面可以发现刘德华直接在剧本中了( `LiuDeHua Liu= new LiuDeHua()`)，如果刘德华有事了，就无法演戏了。剧本和演员直接耦合了。

### 情况二
```java

//person接口
public interface Person { 
  public void say(String word);
}

public LiuDeHua implements Person{
  public void say(String word){
    System.out.println(word);
  }
}

public class Drama { 
  public void start(){
    Person person= new LiuDeHua();
    person.say("你好");
  }
}
```

剧本的角色是一个人，在拍戏时，由刘德华饰演。这样如果刘德华有事了，还可以让其他人来饰演( ` Person person= new LiuDeHua();`)

### 情况三
从2可以看出，剧本还是；依赖于Person接口和LiuDeHua类，没有做到剧本一栏于角色。但是角色又需要人来饰演。怎么办呢？
当然是在影片投拍时，导演将LiuDeHua安排在Person的角色上，导演将剧本、角色、饰演者装配起来

```java
  public class Drama { 
    public void start(Person person){
      person.say("你好");
    }   
  }
  
  public class Director{
    Drama drama= new Drama();
    Person Liudehua= new LiuDeHua();
    //派遣刘德华去演戏
    drama.start(Liudehua);
  }
```
这样，剧本就和刘德华完全分离了。剧本就依赖于Person。当拍摄中，需要演员。导演就直接派一个人过去就可以了。(`当戏剧需要演员时，导演就将人注入可以了，此处的导演就相当于Spring，当某个类需要哪个对象，就由Spring将需要的资源注入到里面`)

## IOC的注入方式

#### 1，构造函数注入
```java
  public cliass Drama(){
    private Person person;
    public Drama(Person person){
      this.person= person;
    }
    
    public void start(){
      person.say("你好");
    }
  }
  
```

#### 2，属性注入
```java
  public cliass Drama{
    private Person person;
    
    public void setPerson(Person person){
      this.person= person;
    }
    
    public void start(){
      person.say("你好");
    }
  }
```
属性注入可以有选择地通过Setter方法完成调用类所需依赖的注入，更加灵活方便：如上面的构造函数注入。一单戏剧开拍了。Person就定死了。而属性注入，可以通过set，临时更换演员等。

#### 3，接口注入 
接口注入将调用类所有依赖注入的方法抽取到一个接口中，调用类通过实现该接口提供相应的注入方法。

```java
  public interface ActorArrangable {  
   void injectPerson(Person person);  
  }  
  
   public cliass Drama implements ActorArrangable {
    private Person person;
    
    public void injectPerson(Person person){
      this.person= person;
    }
    
    public void start(){
      person.say("你好");
    }
  }
```

#### 4，通过容器完成依赖关系的注入 
虽然演员和戏剧已经分离开了，戏剧无需关注角色实现类的实例化工作，但这些工作在代码中依然存在，只是转移到Director类中而已,假设某一制片人想改变这一局面，在选择某个剧本后，希望通过一个“海选”或者第三中介机构来选择导演、演员，让他们各司其职，那剧本、导演、演员就都实现解耦了。 所谓媒体“海选”和第三方中介机构在程序领域即是一个第三方的容器，它帮助完成类的初始化与装配工作，让开发者从这些底层实现类的实例化、依赖关系装配等工作中脱离出来，专注于更有意义的业务逻辑开发工作。这无疑是一件令人向往的事情，Spring就是这样的一个容器，它通过配置文件或注解描述类和类之间的依赖关系，自动完成类的初始化和依赖注入的工作。下面是Spring配置文件的对以上实例进行配置的配置文件片断： 
```xml
  <?xml version="1.0" encoding="UTF-8" ?>  
<beans xmlns="http://www.springframework.org/schema/beans"  
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"  
    xmlns:p="http://www.springframework.org/schema/p"  
    xsi:schemaLocation="http://www.springframework.org/schema/beans   
       http://www.springframework.org/schema/beans/spring-beans-3.0.xsd">   
   <bean id="person" class="LiuDeHua"/>  
   <bean id="drama" class="com.baobaotao.ioc.Drama"   
         p:person-ref="person"/><!--②通过person-ref建立依赖关系-->  
</beans>  
```

#### 5，通过配置文件注入

##### 设值注入(给对应的属性赋值)
```java
  public class InjectionServiceImpl implements InjectionService {
    private InjectionDao injectionDao;
    
    //设值注入 这个set方法一定要，否则是无法给属性赋值的
    public void setInjectionDao(InjectionDao injectionDao) {
      this.injectionDao = injectionDao;
    }
  }
```

spring的配置文件
```xml

<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
	xsi:schemaLocation="http://www.springframework.org/schema/beans 
		http://www.springframework.org/schema/beans/spring-beans.xsd">
		
  <!-- id 唯一标识 class对应的class  可以看做是new了一个叫做id的class的 -->
	<bean id="injectionDao" class="com.injection.dao.InjectionDaoImpl"></bean>	
	
	<bean id="injectionService" class="com.injection.service.InjectionServiceImpl">
    <!-- 
      property 对应的就是上面那个class里面的的某个属性，属性名和property一致
      ref 就是给这个属性赋的值 ref里面的值通常为声明在配置文件中的某个id。
    -->
	<property name="injectionDao" ref="injectionDao"></property>
   </bean>	
</beans>
```

##### 构造注入(给构造函数对应的属性赋值)

```java
  public class InjectionServiceImpl implements InjectionService {

    private InjectionDao injectionDao;

    //构造函数注入
    public InjectionServiceImpl(InjectionDao injectionDao) {
      // TODO Auto-generated constructor stub
      this.injectionDao= injectionDao;
    }

    @Override
    public void input(String arg) {
      System.out.println("数据输入"+arg);
      arg+= arg+hashCode();
      injectionDao.save(arg);
    }
}
```

spring的配置文件
```xml
  <bean id="injectionDao" class="com.injection.dao.InjectionDaoImpl"></bean>
  <bean id="injectionService" class="com.injection.service.InjectionServiceImpl">
    <!-- constructor 给这个类的构造函数赋值 name和ref的作用不变 -->
	<constructor-arg name="injectionDao" ref="injectionDao"></constructor-arg>
  </bean>	
```

##### Spring架包的结构
![ALt '图片'](https://github.com/LCN29/MyNote/blob/picture-branch/Picture/Java/JavaFrameWork/spring-jar.png?raw=true)