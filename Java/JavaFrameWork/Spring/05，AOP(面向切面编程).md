# 05，AOP(面向切面编程)

![Alt 'aop'](E:\LearningNote\Boostnote\Picture\Java\JavaFrameWork\Aop.png)
在程序运行到某个切入点时，调用切面，通过通知，将切面里面的某些代码织入到对应的切入点

## 五种通知
#### before通知
`在切入点时，先执行before，在执行需要执行的代码`
**1.配置的用法**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    xmlns:context="http://www.springframework.org/schema/context"
    xmlns:aop="http://www.springframework.org/schema/aop"
    xsi:schemaLocation="http://www.springframework.org/schema/beans 
        http://www.springframework.org/schema/beans/spring-beans.xsd  
        http://www.springframework.org/schema/context
        http://www.springframework.org/schema/context/spring-context.xsd
        http://www.springframework.org/schema/aop 
        http://www.springframework.org/schema/aop/spring-aop.xsd">
  <!-- 切面 -->     
  <bean id="beforeAspectConfig" class="com.eigpay.before.one.BeforeAspect"/> 
  <bean id="beroreBiz"  class="com.eigpay.before.BeforeBiz" />
  
  <aop:config>
    <aop:aspect id="myAspect" ref="beforeAspectConfig">
      <!-- 切入点: com.eigpay.before下的Biz界面的类的任意参数的方法 -->
      <aop:pointcut id="pointCut" expression="execution(* com.eigpay.before.*Biz.*(..))" />
      <!-- before通知 执行切面的before方法-->
      <aop:before method="before" pointcut-ref="pointCut"/>
    </aop:aspect>
  </aop:config>
</beans>        
```

```java
//切面类
public class BeforeAspect { 
    public void before() {
        System.out.println("我是配置的切面类：before");
    }
}

//执行类

public class BeforeBiz {
  public void biz() {
      System.out.println("业务类的方法");
  }
}

  //测试类
  @Test
  public void testBiz() {
      BeforeBiz biz = getBean("beforeBiz");
      biz.biz();  
  }
  
  /*
    结果 ：
    我是配置的切面类：before
    业务类的方法
  */
```
**注解的方式**

```xml
  <context:component-scan base-package="com.eigpay.before">
        <context:include-filter   type="annotation"expression="org.aspectj.lang.annotation.Aspect"/>
  </context:component-scan>  

  <!-- 启动@AspectJ支持 -->  
  <aop:aspectj-autoproxy/>
```

```java

//切面
@Aspect
public class BeforeAspect {
    
    @Before("execution(* com.eigpay.before..*(..))")
    public void before() {
        System.out.println("我是注解的切面类：before");
    }
}

//业务类和测试类不变

  /*
    结果 ：
    我是注解的切面类：before
    业务类的方法
  */
```

#### after-returning通知
`在切入点时，需要执行的代码执行完了,并且有返回值，可以获取到返回值，但是对返回值的修改，不会影响到程序的真正的返回值`

**配置的方式**

```xml
  <aop:config>
	   <aop:aspect id="myAspect" ref="myAfterReturnAspect" >
	       <aop:pointcut expression="execution(* com.afterreturning..*(..))" id="afterReturningPointCut"/>
         <!-- returning="获取到的返回值存放的变量" -->
	       <aop:after-returning method="afterReturning" returning="value" pointcut="execution(* com.eigpay..*(..))"/>
	   </aop:aspect>
	</aop:config>
```

```java
  //参数value必须和 after-returning里面的 returning的参数一致
  public void afterReturning(Object value) {
      System.out.println("配置切面收到了业务类的返回值了:"+(String)value);
  }
```

**注解的方式**
```java

    @AfterReturning(returning="value",pointcut="execution(* com.eigpay.afterreturning.*(..))")
    public void afterReturning(Object value) {
        System.out.println("注解切面收到了业务类的返回值了:"+(String)value);
        //对获取到的返回值进行修改，无法对类的方法的返回值进行改变的
    }
```

#### after-throwing通知
`在切入点时，需要执行的代码执行过程，抛出了异常时,需要执行的代码结束，此处捕获异常`

**配置方法**
```xml
  <aop:config>
       <aop:aspect id="myAspect" ref="myAfterThrowingAspect" >
           <aop:pointcut expression="execution(* com.eigpay.afterthrowing.*Biz.*(..))" id="afterThrowingPointCut"/>
           <!-- throwing 异常的别名 -->
           <aop:after-throwing method="afterThrowing" throwing="ex" pointcut-ref="afterThrowingPointCut" />
       </aop:aspect>
    </aop:config>
```
```java
  public void afterThrowing(Throwable ex) {
      System.out.println("配置切面收到了业务类的异常:"+ex.getMessage());
  }
```
**注解的方式**
```java
  @AfterThrowing(throwing="ex",pointcut="execution(* com.eigpay.afterthrowing.*Biz.*(..))")
    public void afterThrowing(Throwable ex) {
        System.out.println("注解切面收到了业务类的异常:"+ex.getMessage());
    }
```

#### after通知
`在切入点时，需要执行的代码执行完，无论过程是否抛出了异常，都会执行到`

**配置的方法**
```xml
<aop:config>
	   <aop:aspect id="myAspect" ref="myAfterAspect" >
	       <aop:pointcut expression="execution(* com.eigpay.after.*Biz.*(..))" id="afterPointCut"/>
	       <aop:after method="after" pointcut-ref="afterPointCut"/>
	   </aop:aspect>
	</aop:config>
```

```java
public void after() {
    System.out.println("配置切面执行完成");
}
```

**注解的方式**

```java
    @After("execution(* com.eigpay.after.*Biz.*(..))")
    public void after() {
        System.out.println("注解切面执行完成");
    }
```

#### around通知
`最强的通知，可以在代码的任意的时候运行，还可以真实的修改代码`

**配置**
```xml
  <aop:config>
    <aop:aspect id="myAspect" ref="aroundAspectConfig">
        <aop:pointcut id="pointCut" expression="execution(* com.eigpay.around.*Biz.*(..))" />
        <!-- 环绕通知的方法的必须有一个以上的参数，指定第一个参数的参数名 -->
        <aop:around method="around" arg-names="jp" pointcut-ref="pointCut"/>
    </aop:aspect>
  </aop:config>
```
```java

  public Object around(ProceedingJoinPoint jp) throws Throwable {
        System.out.println("我是配置的切面类：around");
        
        System.out.println("在方法的执行之前执行");
        
        // 获取目标方法原始的调用参数  
        Object[] args = jp.getArgs(); 
        
        if(args != null && args.length > 0) {  
            // 修改目标方法的第一个参数  
          
            args[0] = "【增加的前缀】" + args[0];  
        }  
        
       // 以改变后的参数去执行目标方法，并保存目标方法执行后的返回值  
       //只有调动了jp.proceed才会执行到真正的代码
       Object rvt = jp.proceed(args);
       
       System.out.println("在方法的执行之后执行");  
       
       // 如果rvt的类型是Integer，将rvt改为它的平方  
       if(rvt != null && rvt instanceof Integer)  
           rvt = (Integer)rvt * (Integer)rvt;
        
       return rvt; 
    }
```
**注解的方式**
```java
    @Around("execution(* com.eigpay.around.*Biz.*(..))")
    public Object around(ProceedingJoinPoint jp) throws Throwable {
        
        System.out.println("我是注解的切面类：around");
        
        System.out.println("在方法的执行之前执行");
        
        // 获取目标方法原始的调用参数  
        Object[] args = jp.getArgs(); 
        
        if(args != null && args.length > 0) {  
            // 修改目标方法的第一个参数  
          
            args[0] = "【增加的前缀】" + args[0];  
        }  
        
       // 以改变后的参数去执行目标方法，并保存目标方法执行后的返回值  
       Object rvt = jp.proceed(args);
       
       System.out.println("在方法的执行之后执行");  
       
       // 如果rvt的类型是Integer，将rvt改为它的平方  
       if(rvt != null && rvt instanceof Integer)  
           rvt = (Integer)rvt * (Integer)rvt;
        
       return rvt;  
    }
```

## 通知的总体执行时机

```java
  try{
    @Before
    你的方法();
    if(需要抛出异常吗){
      
      throw Execution;
      @After-Throwing()
      
    }
    @After-Returning
  }catch(){
  
  }finally{
    @After
  }
```

## @Introductions
`允许一个切面可以有一个接口和这个接口的实现类，切面里面满足条件的类，为他们赋予这个接口父级`

```java
//接口
public interface Fit {
    void filter();
}

//接口实现类
public class FitImpl implements Fit {
    @Override
    public void filter() {
        System.out.println("這是FitImpl中的filter方法執行了");
    }
}
```

配置
```xml
  <aop:config>
		<aop:aspect id="myAspectAnnaction" ref="myAspect">
			<aop:declare-parents 
			    types-matching="com.eigpay.introductions.biz.*(+)"
				implement-interface="com.eigpay.introductions.Fit" 
				default-impl="com.eigpay.introductions.FitImpl"/>
		</aop:aspect>
	</aop:config>
```
使用
```java
  Biz biz = getBean("MyBiz"); //满足types-matching
  biz.biz();   
  Fit fit = (Fit)biz;
  fit.filter();             //通过Introduction让 Biz实现了Fil接口，调用时使用默认的实现类的方法
```

## 自定义注解和使用

```java

//自定义注解
@Retention(RetentionPolicy.RUNTIME)  //在运行器作用
@Target(ElementType.METHOD) //只对方法起作用
public @interface Auditable {
    String value();
}

//切面

@Aspect
public class AnnocationClass {

    //声明切入点
    @Pointcut("com.eigpay.annotation.*Biz.*(..)")
    public void myPoint() {}
    
    //&& 并的作用 @annotation说明方法上因有注解
    @Before("myPoint && @annotation(status)")
    public void before(Auditable status) {
        String string = status.value();
        System.out.println("没事");
    }
}

```

