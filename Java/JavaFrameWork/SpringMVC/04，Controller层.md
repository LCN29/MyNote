# 04，Controller层


### 注解：@RequestMapping

```java

//情况一

@Controller
public class ItemController {
  //省略
  @RequestMapping("/queryItem")
  public ModelAndView queryItem(HttpServletRequest request, HttpServletResponse response) throws Exception {
    //处理
  }
}

//情况二

@Controller
@RequestMapping("/item")
public class ItemController {
  //省略
  @RequestMapping("/queryItem")
  public ModelAndView queryItem(HttpServletRequest request, HttpServletResponse response) throws Exception {
    //处理
  }
}

//情况三

@Controller
public class ItemController {
  //省略
  @RequestMapping(value="/queryItem",method= {RequestMethod.GET,RequestMethod.POST})
  public ModelAndView queryItem(HttpServletRequest request, HttpServletResponse response) throws Exception {
    //处理
  }
}

```
**作用**
> `1.`用在Controller中，指定某条链接应该由这个方法进行处理，
> `2.`也可以直接放在类名上（窄化请求映射），则这个类里面的方法对应的url，需要在加上这个属性,如情况一，/queryItem由queryItem这个方法处理，情况二，变成了 /item/queryItem 由queryItem处理
> `3.`限制http的请求方法 如情况三，通过method={}指定哪些形式的请求由这个方法进行处理

<br/>

### 方法的返回值

**1.返回ModelAndView**
```java
@Controller
public class ItemController {
  
  @RequestMapping("/one")
  public ModelAndView one(HttpServletRequest request, HttpServletResponse response) throws Exception {
    //数据处理
    //new 出 ModelAndView
    ModelAndView modelAndView= new ModelAndView();
    modelAndView.addObject("key值", "value值");
     //此处的itemsList为逻辑视图 返回的视图= 前缀+逻辑视图+后缀
    modelAndView.setViewName("itemsList");
    //返回结果
    return modelAndView;
  }
}

```
**2.返回String**

```java

@Controller
public class ItemController {

    //情况一，返回逻辑视图
    @RequestMapping("/two")
    public String queryItem(Model model) {
        model.addAttribute("key值", "value值");
        //返回逻辑视图
        return "success";
    }
    
    //情况二，返回逻辑视图
    @RequestMapping("/three")
    public String queryItem() {
        model.addAttribute("key值", "value值");
        //重定向到success页面 在一个controller里面，重定向会自动添加这个类的跟路径
        //如已下的success，如果类名也有requestmapper，就相当于 /类名的url/success
        return "redirect:success";
    }
    
    //情况三，页面转发
    @RequestMapping("/three")
    public String queryItem() {
        model.addAttribute("key值", "value值");
        //页面转发，和redirect一样，会自动添加类名的requestmapper
        //和redirect的区别:（1）地址栏不会变，（2）request可以共享
        return "forward:success";
    }   
}
```

**3.void**

```java

@Controller
public class ItemController {
  
  @RequestMapping("/one")
  public void one(HttpServletRequest request, HttpServletResponse response) throws Exception {
    //由上面的参数可以，controller里面的方法的参数有一个response，
    //所以页面之间可以直接通过response进行处理，而无需返回值
    //如 返回json
    response.setCharacterEncoding("UTF-8");
    response.setContentType("application/json;charset=utf-8");
    response.getWriter().write("json字符串");
        
     //如重定向
      response.sendRedirect("url");
  }
}

```

### 参数绑定
**在springMVC中，页面提交的参数是通过方法的形参接受的**

```java

@Controller
public class ItemController {
  
  //情况一
  @RequestMapping("/one")
  public void one(@RequestParam("id") Integer id,@RequestParam(value="content",request=true)) throws Exception {
    //此处请求的url为 /one？id=1232
    //形参的id等于url后面的id
    //如果方法的形参名和url的key(id)一致，RequestParam一样，可以省略注解
    //request 参数是否必须传递
    //defaultValue 默认值
  }
  
  //情况二
  @RequestMapping(value = "/two/{id}")
  public String deleteTenant(@PathVariable(value = "id") Integer id) {
    //此处请求的url为 /one/1234
    //形参的id等于/one后面的值 既 1234，如果后面还有值可以继续拼接
  } 
  
  //情况三
  @RequestMapping(value = "/two")
  public String deleteTenant(Item item) {
    //页面提交的属性和pojo的属性一致，则pojo对应的属性有值
    // <input type="text" name="name"/>
    //页面提交了name属性 则这个方法的item的name有值了
    // <input type="text" name="obj.name"/>
    //Item 里面有个Obj的对象 这样可以给item里面的obj的name赋值
  }  
}
```

**`情况二，如果post可能会出现乱码，解决，在web.xml中添加`**
```xml
<!--过滤器，解决post乱码  -->
    <filter>
        <filter-name>encodingFilter</filter-name>
        <filter-class>org.springframework.web.filter.CharacterEncodingFilter</filter-class>
        <init-param>
            <param-name>encoding</param-name>
            <param-value>UTF-8</param-value>
        </init-param>
        <init-param>
            <param-name>forceEncoding</param-name>
            <param-value>true</param-value>
        </init-param>
    </filter>
```
### 自定义参数绑定
**`在上面中的参数绑定时，对于日期的绑定回馈出错，解决：自定义参数绑定`**
**解决将请求的日期参数转为对应得Date类型**
**步骤**
>1,配置转换器
>2,向处理器适配器注入自定义参数绑定组件

```java
public class CustomDateConverter implements Converter<String, Date>{

    public Date convert(String source) {
      //将日期字符串转为 Date格式
        try {
            SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            return simpleDateFormat.parse(source);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

}
```

```xml
  <!-- 在web.xml中配置 -->
  <!-- 向处理器适配器注入自定义参数绑定组件 -->
  <mvc:annotation-driven conversion-service="conversionService"></mvc:annotation-driven>
  
  <bean id="conversionService" class="org.springframework.format.support.FormattingConversionServiceFactoryBean">
	   <!-- 转换器 -->
	   <property name="converters">
	       <list>
	           <bean class="com.example.ssm.converter.CustomDateConverter"></bean>
	       </list>
	   </property>
 </bean>
```

### 包装类型的参数绑定
有时候，我们查询时，需要传入条件，这些条件可以多个，如用户信息，订单日期等，如果直接将这些信息拼接在一个简单的pojo(属性都是简单类型)中，会很乱。建议使用包装类型的pojo(属性可以又是一个pojo)

```html
<!-- 页面的定义 需要和包装类型的pojo的属性要对应 -->
<input type="text" name="goods.name"/>
```
<br/>

```java

  //方法
  @RequestMapping("/queryItem")
  public String queryItem(Item item) {
      //省略代码处理
      return "success";
  } 
  
  //pojo
  public class Item{
    private Goods good;
  }
  
  //pojo
  public class Goods{
    private String name;
  }
  
```
**由上可知，页面中的goods.name表示传给方法的形参的Item的goods的name**
<br/>
### 集合类型的参数绑定

#### 1.数组绑定
```html
<!-- 注意name的属性值。 forEach 通过循环后，itemId的值会变成多个，既数组信息 -->
<c:forEach items="${itemList }" var="item">
    <input type="text" value="item.id" name="itemId"/>
</c:forEach>
```

```java
  //方法
  @RequestMapping("/queryItem")
  public String queryItem(Integer[] itemId) {
      //省略代码处理
      //形参的属性名需要和页面中的name值一致，这样页面就可以将数组传递过来了
      return "success";
  } 
```

#### 2.list绑定
```html
<!-- 注意name的属性值。itemList是pojo属性中的List,itemList[index]list中的第几个
    .id list中的第几个的VO的id属性
  -->
<c:forEach items="${itemList }" var="item">
     <input type="text" value="item.id" name="itemList[${status.index} }].id"/>
</c:forEach>
```

```java
  //方法
  @RequestMapping("/queryItem")
  public String queryItem(ItemVO vo) {
      //省略代码处理
      
      //形参不能直接输入List,需要用一个包装类型的pojo包装起来
      //通过ItemVO 接受批量的数据，把数据存储在他的属性中的itemList
      return "success";
  } 
  
  //pojo
  public class ItemVo{
  
    //此处的itemList名字需要和页面的itemList对应
    private List<Item> itemList;
    
    //get set 方法省略
  }
  
```

#### 3.map绑定
```html
<!-- 注意name的属性值。itemInfo['name'] 表示map的key值-->
<c:forEach items="${itemList }" var="item">
     姓名：<input type="text" name="itemInfo['name']"/>
     年龄：<input type="text" name="itemInfo['price']"/>
</c:forEach>
```

```java
  //方法
  @RequestMapping("/queryItem")
  public String queryItem(ItemVO vo) {
      //省略代码处理
      
      //形参不能直接输入Map,需要用一个包装类型的pojo包装起来
      //通过ItemVO 接受批量的数据，把数据存储在他的属性中的itemInfo
      return "success";
  } 
  
  //pojo
  public class ItemVo{
  
    //此处的itemInfo名字需要和页面的itemInfo对应
    private Map<String, Object> itemInfo = new HashMap<String, Object>();
    
    //get set 方法省略
  }
  
```

<br/>

### 方法里面隐藏的属性
> 1. HttpServletRequest
> 2. HttpServletResponse
> 3. HttpSession
> 4. Model/ModelMap(作用：将model数据填充到request中)
