# 08，multipart类型的处理

## multipart类型的处理

`使用springMVC处理multopart类型的数据，此处实例为上传图片`

**1.在页面的form中添加enctype="multipart/form-data"，才能上传图片**
```html
<form id="itemForm" action="${pageContext.request.contextPath }/items/editItemsSubmit.action" method="post" enctype="multipart/form-data">
  <input type="file"  name="items_pic"/> 
  <input type="submit" value="提交"/>
</form>
```
**2.在springmvc.xml中配置multipart类型的解析器**
```xml
  <bean id="multipartResolver"
		class="org.springframework.web.multipart.commons.CommonsMultipartResolver">
		<!-- 设置上传文件的最大尺寸为5MB -->
		<property name="maxUploadSize">
			<value>5242880</value>
		</property>
	</bean>
```
**3.上传需要的包**
```xml
<dependency>
  <groupId>commons-io</groupId>
  <artifactId>commons-io</artifactId>
  <version>2.4</version>
</dependency>

<dependency>
  <groupId>commons-fileupload</groupId>
  <artifactId>commons-fileupload</artifactId>
  <version>1.3.1</version>
</dependency>
```
**为tomcat配置一个虚拟目录(直接在eclipse里面的service的module的Add External Web Module)，用于上传图片时，图片的存放地方**
![ALt "SpringMVC"](https://github.com/LCN29/Picture-Repository/blob/master/MyNote/Java/JavaFrameWork/virtualDirectory.png?raw=true)

**(或者通过修改配置文件: 在tomcat下conf/server.xml中添加：)**
```xml
  <Context docBase="F:\develop\upload\temp" path="/pic" reloadable="false"/>
```

**4.上传代码**
```java
    @RequestMapping("/uploadImg")
    public String uploadImg(MultipartFile items_pic){
    	//参数的 items_pic和页面的form表单的items_pic的名称一样
    	if(items_pic !=null){
    		//存放图片的物理路径
    		String path = "F:\\img\\";
    		//获取图片的名字
    		String originalFilename = items_pic.getOriginalFilename();
    		//生成新的图片名字
    		String newFilename = UUID.randomUUID() + originalFilename.substring( originalFilename.lastIndexOf("."));
    		//生成图片
    		File file = new File(path+newFilename);
    		//将内存的数据写入磁盘
    		try {
    			items_pic.transferTo(file);
    			//将对应的图片信息保存进数据库
    			//数据库操作	
			} catch (IllegalStateException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			}
    	}
    	
    	return "success";
    }
```



