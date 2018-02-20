# 01,SpringMVC了解

## 架构图
![ALt "SpringMVC"](https://github.com/LCN29/MyNote/blob/picture-branch/Picture/Java/JavaFrameWork/springMVC-process.png?raw=true '悬浮的提示')

## 流程
> 1. 用户发送请求至前端控制器DispatcherServlet
> ----
> 2. DispatcherServlet收到请求调用HandlerMapping处理器映射器。
> ----
> 3. 处理器映射器根据请求url找到具体的处理器，生成处理器对象及处理器拦截器(如果有则生成)一并返回给DispatcherServlet。(中间涉及到了HandlerExecutionChain)
>  ----
> 4. DispatcherServlet通过HandlerAdapter处理器适配器调用处理器
>  ----
> 5. 执行处理器Handler(平常叫做Controller，也叫后端控制器)
>  ----
> 6. Handler执行完成返回ModelAndView
>  ----
> 7. HandlerAdapter将Handler执行结果ModelAndView返回给DispatcherServlet
>  ----
> 8. DispatcherServlet将ModelAndView传给ViewReslover视图解析器
>  ----
> 9. ViewReslover解析后返回具体View
>  ----
> 10. DispatcherServlet对View进行渲染视图（即将模型数据填充至视图中）
>  ----
> 11. DispatcherServlet响应用户

## 组件说明

**DispatcherServlet: 前端控制器**
`用户请求到达前端控制器，它就相当于mvc模式中的c，dispatcherServlet是整个流程控制的中心，由它调用其它组件处理用户的请求，dispatcherServlet的存在降低了组件之间的耦合性`

**	HandlerMapping: 处理器映射器**
`HandlerMapping负责根据用户请求找到Handler即处理器，springmvc提供了不同的映射器实现不同的映射方式，例如：配置文件方式，实现接口方式，注解方式等`

**	Handler: 处理器**
`Handler 是继DispatcherServlet前端控制器的后端控制器，在DispatcherServlet的控制下Handler对具体的用户请求进行处理(由于Handler涉及到具体的用户业务请求，所以一般情况需要程序员根据业务需求开发Handler)`

**	HandlAdapter: 处理器适配器**
`通过HandlerAdapter对处理器进行执行，这是适配器模式的应用，通过扩展适配器可以对更多类型的处理器进行执行`

**	View Resolver: 视图解析器**
`View Resolver负责将处理结果生成View视图，View Resolver首先根据逻辑视图名解析成物理视图名即具体的页面地址，再生成View视图对象，最后对View进行渲染将处理结果通过页面展示给用户。 springmvc框架提供了很多的View视图类型，包括：jstlView、freemarkerView、pdfView等(一般情况下需要通过页面标签或页面模版技术将模型数据通过页面展示给用户，需要由程序员根据业务需求开发具体的页面。)`

## 入门程序
1. **在web.xml中配置前端控制器**

```xml
<?xml version="1.0" encoding="UTF-8"?>  
<web-app 
	version="3.0"  id="WebApp_ID"
	xmlns="http://java.sun.com/xml/ns/javaee"  
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"  
    xsi:schemaLocation="http://java.sun.com/xml/ns/javaee http://java.sun.com/xml/ns/javaee/web-app_3_0.xsd"> 
    
   <display-name>Archetype Created Web Application</display-name> 
   <!-- 配置前端控制器 -->
   <servlet>
      <servlet-name>springmvc(自定义)</servlet-name>
      <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
      <init-param>
        <!-- contextConfigLocation说明: springMVC加载的配置文件(里面配置了处理映射器，适配器等-->
        <!--如果不配置，默认加载的是/WEB-INF/(<servlet-name>的值)-servlet.xml(这里为springmvc-servlet.xml)-->
        <param-name>contextConfigLocation</param-name>
        <param-value>classpath:springmvc.xml</param-value>
      </init-param>
   </servlet>
    
    <servlet-mapping>
      <!-- 和上边的servlet-name的值一样 -->
      <servlet-name>springmvc</servlet-name>
      <!--
        拦截的url
        第一种：*.action 所有以.action结尾的url 都由 DispatcherServlet控制
        第二种: / 所有的url 都由DispatcherServlet控制（因为所有放入信息都由dispatcherServlet
  		         控制了，静态资源也会受到拦截）,所以静态资源需要配置不让dispatcherServlet解析
  		         使用这种方式，可以实现RESTful风格的url
      -->
      <url-pattern>*.action</url-pattern>
    </servlet-mapping>
</web-app>
```
2. **在springmvc.xml中书写配置**
> 1.配置处理适配器

```xml
<beans 
	xmlns="http://www.springframework.org/schema/beans"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"        xmlns:mvc="http://www.springframework.org/schema/mvc"
	xmlns:context="http://www.springframework.org/schema/context"
	xmlns:aop="http://www.springframework.org/schema/aop"    xmlns:tx="http://www.springframework.org/schema/tx"
	xsi:schemaLocation="http://www.springframework.org/schema/beans 
		http://www.springframework.org/schema/beans/spring-beans-3.2.xsd 
		http://www.springframework.org/schema/mvc 
		http://www.springframework.org/schema/mvc/spring-mvc-3.2.xsd 
		http://www.springframework.org/schema/context 
		http://www.springframework.org/schema/context/spring-context-3.2.xsd 
		http://www.springframework.org/schema/aop 
		http://www.springframework.org/schema/aop/spring-aop-3.2.xsd 
		http://www.springframework.org/schema/tx 
		http://www.springframework.org/schema/tx/spring-tx-3.2.xsd ">
    
    <!-- 第一 处理适配器 所有的处理器适配器都实现了HandlerAdapter接口 -->
    <bean class="org.springframework.web.servlet.mvc.SimpleControllerHandlerAdapter"></bean>
    
</beans>

```

> 2.编写控制器

```java
  
public class ItemControllerOne implements Controller{
  public ModelAndView handleRequest(HttpServletRequest request, HttpServletResponse response) throws Exception {
    //模拟查询数据库
    List<Item> itemList= new ArrayList<Item>();
		
		Item item_1 = new Item();
		item_1.setName("联想笔记本");
		item_1.setPrice(6000f);
		item_1.setDetail("ThinkPad T430 联想笔记本电脑！");
		
		Item item_2 = new Item();
		item_2.setName("苹果手机");
		item_2.setPrice(5000f);
		item_2.setDetail("iphone6苹果手机！");
		
		itemList.add(item_1);
		itemList.add(item_2);
		
		//返回modelAndView
		ModelAndView modelAndView= new ModelAndView();
		//相当于request的setAttribute(Key, 数据) 在jsp页面中，可以通过itemList获取数据
		modelAndView.addObject("itemList", itemList);
		//指定视图
		modelAndView.setViewName("WEB-INF/jsp/item/itemsList.jsp");

		return modelAndView;
  }
}
```

>3. 在springmvc.xml中注册处理器

```xml
<beans>
    
  <!--第二， 配置Handler(既控制器) queryItem.action 由ItemCOntrollerOne进行处理 -->
	<bean name="/queryItem.action" class="com.example.ssm.controller.ItemControllerOne" ></bean>
  
   <!-- 第一 处理适配器 所有的处理器适配器都实现了HandlerAdapter接口 -->
  <bean class="org.springframework.web.servlet.mvc.SimpleControllerHandlerAdapter"></bean>
  
</beans>
```

>4. 在springmvc.xml中配置处理映射器和视图解析器
```xml
<beans>

   <!--第二， 配置Handler(既控制器) queryItem.action 由ItemCOntrollerOne进行处理 -->
	<bean name="/queryItem.action" class="com.example.ssm.controller.ItemControllerOne" ></bean>
  
  <!--第三 处理映射器 
    根据bean的name作为url进行查找,需要在配置Handler是指定beanName,既url
    既会根据url去查找 name和url匹配的Handler,Handler通过class找到处理器
    如 localhost:8080/One/queryItem.action  .action结尾，被拦截了，
    处理器通过/queryItem.action找到了处理器 ItemControllerOne
  -->
  <bean class="org.springframework.web.servlet.handler.BeanNameUrlHandlerMapping"></bean>
  
   <!-- 第一 处理适配器 所有的处理器适配器都实现了HandlerAdapter接口 
    要求:他控制下的处理器需要实现Controller接口
   -->
  <bean class="org.springframework.web.servlet.mvc.SimpleControllerHandlerAdapter"></bean>
  
  <!--
    第四 视图解析器 
    此处返回给用户的是一个jsp页面，配置jsp对应的bean
  -->
  <bean class="org.springframework.web.servlet.view.InternalResourceViewResolver"></bean>

</beans>
```