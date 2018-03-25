# XStream(xml和JavaBean互转)

### Maven依赖

```xml
<dependency>
    <groupId>com.thoughtworks.xstream</groupId>
    <artifactId>xstream</artifactId>
    <version>${xstream.version}</version>
</dependency>
```



#### JavaBean（构造函数和getter/setter省略）声明

```java
public class Note {
    private String title;
    private String description;
}


public class Student {

    private String studentName;
    private List<Note> noteList;
    
    // 静态工厂获取对象
    public static Student getStudent() {
        List<Note> list = new ArrayList<>(2);
        Note note1 = new Note("标题1", "描述1");
        Note note2 = new Note("标题2", "描述2");
        list.add(note1);
        list.add(note2);
        Student student = new Student("LCN", list);
        return student;
    } 
}
```

#### 1. 使用

```java

  // StaxDriver:使用SAX解析XML的解析器
  XStream xStream = new XStream(new StaxDriver());
  Student stu = Student.getStudent();
  // 调用toXML方法将对象转为xml字符串
  String xml = xStream.toXML(stu);

```


###### 结果
```xml
<com.eigpay.model.two.Student>
    <studentName>LCN</studentName>
    <noteList>
        <com.eigpay.model.two.Note>
            <title>标题1</title>
            <description>描述1</description>
        </com.eigpay.model.two.Note>
        <com.eigpay.model.two.Note>
            <title>标题2</title>
            <description>描述2</description>
        </com.eigpay.model.two.Note>
    </noteList>
</com.eigpay.model.two.Student>
```

###### 如果需要在头部加上编码等信息，需要自己手动添加
```java
   /**
     * 格式化xml格式的字符串同时输出编码为UTF-8
     * @param xml
     * @return
     */
    public static String formatXml(String xml) {
        try{
            Transformer serializer= SAXTransformerFactory.newInstance().newTransformer();
            serializer.setOutputProperty(OutputKeys.INDENT, "yes");
            serializer.setOutputProperty("{http://xml.apache.org/xslt}indent-amount", "2");
            Source xmlSource=new SAXSource(new InputSource(new ByteArrayInputStream(xml.getBytes())));
            StreamResult res =  new StreamResult(new ByteArrayOutputStream());
            serializer.transform(xmlSource, res);
            return new String(((ByteArrayOutputStream)res.getOutputStream()).toByteArray());
        }catch (Exception e){
            e.printStackTrace();
            return xml;
        }
    }
```

###### 结果
```xml
<?xml version="1.0" encoding="UTF-8"?>
<com.eigpay.model.two.Student>
    省略.....
</com.eigpay.model.two.Student>
```

#### 2.方法说明
> 1. 给全名(包名.类名)起一个别名代替
```java
  xStream.alias("student", Student.class);
  // 将xml中Student的全名替为student
```
###### 结果
```xml
<student>
  <studentName>LCN</studentName>
      <noteList>
          <com.eigpay.model.two.Note>
              <title>标题1</title>
              <description>描述1</description>
          </com.eigpay.model.two.Note>
          <com.eigpay.model.two.Note>
              <title>标题2</title>
              <description>描述2</description>
          </com.eigpay.model.two.Note>
      </noteList>...
</student>
```
> 2. 为类中的某个属性属性起个别名
```java
  xStream.aliasField("alias", Student.class, "studentName");
  // 为Student的name属性设置一个别名 alias
```
###### 结果
```xml
<com.eigpay.model.two.Student>
    <alias>LCN</alias>
    <noteList>
        <com.eigpay.model.two.Note>
            <title>标题1</title>
            <description>描述1</description>
        </com.eigpay.model.two.Note>
        <com.eigpay.model.two.Note>
            <title>标题2</title>
            <description>描述2</description>
        </com.eigpay.model.two.Note>
    </noteList>
</com.eigpay.model.two.Student>
```
> 3. 设置某个集合字段不需要显示在xml中，既隐藏某个字段
```java
   xStream.addImplicitCollection(Student.class, "noteList");
  // 为Student的noteList字段隐藏，直接显示列表项
```
###### 结果
```xml
<com.eigpay.model.two.Student>
    <studentName>LCN</studentName>
    <com.eigpay.model.two.Note>
        <title>标题1</title>
        <description>描述1</description>
    </com.eigpay.model.two.Note>
    <com.eigpay.model.two.Note>
        <title>标题2</title>
        <description>描述2</description>
    </com.eigpay.model.two.Note>
</com.eigpay.model.two.Student>
```

> 4.  省略某个属性，在xml中不显示
```java
   xStream.omitField(Student.class, "studentNamet");
  // 为Student的noteList字段隐藏，直接显示列表项
```
###### 结果
```xml
<com.eigpay.model.two.Student>
    <com.eigpay.model.two.Note>
        <title>标题1</title>
        <description>描述1</description>
    </com.eigpay.model.two.Note>
    <com.eigpay.model.two.Note>
        <title>标题2</title>
        <description>描述2</description>
    </com.eigpay.model.two.Note>
</com.eigpay.model.two.Student>
```

> 5.  将bean中的某个属性设置为标签的属性，而不是xml中的标签
```java
   xStream.useAttributeFor(Student.class, "studentName");
  // 为Student的studentName的属性设置为标签的属性
```
###### 结果
```xml
<com.eigpay.model.two.Student  studentName="LCN">
    <com.eigpay.model.two.Note>
        <title>标题1</title>
        <description>描述1</description>
    </com.eigpay.model.two.Note>
    <com.eigpay.model.two.Note>
        <title>标题2</title>
        <description>描述2</description>
    </com.eigpay.model.two.Note>
</com.eigpay.model.two.Student>
```

> 6.  将全名(包名.类名)中的包名，有一个别名替代
```java
  xstream.aliasPackage("com.eigpay.model.two", "com.eigpay.");
  // 为xml中的com.eigpay.model.two用com.eigpay替代
```
###### 结果
```xml
<com.eigpay.Student  studentName="LCN">
  <studentName>LCN</studentName>
    <com.eigpay.Note>
        <title>标题1</title>
        <description>描述1</description>
    </com.eigpay.Note>
    <com.eigpay.Note>
        <title>标题2</title>
        <description>描述2</description>
    </com.eigpay.Note>
</com.eigpay.Student>
```

#### 3.注解
> 1. @XStreamAlias("别名")注解在类名上：作用相当于 1，注解在属性上，作用相当于 2

> 2. @XStreamImplicit 注解在集合属性上，相当于 3.

> 3. @XStreamOmitField 注解在变量上， 相当于 4.

> 4. @XStreamAsAttribute 注解在变量上，相当于5 

###### 使用时，需要多一行代码
```java
        XStream xstream = new XStream(new StaxDriver());
        Student stu = Student.getStudent();
        // 多这句
        xstream.processAnnotations(Student.class);
        String xml = xstream.toXML(stu);
        System.out.println(FormXml.formatXml(xml));
```

#### 4.从文件里面读入和输出到文件
```java

// 输入流
ObjectInputStream objectInputStream = xstream.createObjectInputStream(new FileInputStream("文件名.后缀名"));

// 输出流
ObjectOutputStream objectOutputStream = xstream.createObjectOutputStream(new FileOutputStream("文件名.后缀名"));
```

###### 输出
```java
  XStream xstream = new XStream(new StaxDriver());		
  xstream.autodetectAnnotations(true);
  Student student1 = new Student("Mahesh","Parashar");	
  Student student2 = new Student("Suresh","Kalra");	
  
   try {
         ObjectOutputStream objectOutputStream = xstream.createObjectOutputStream(new FileOutputStream("test.txt"));
         objectOutputStream.writeObject(student1);
         objectOutputStream.writeObject(student2);
         objectOutputStream.writeObject("Hello World");
         objectOutputStream.close();
         
   }catch (IOException e) {
       e.printStackTrace();
    } catch (ClassNotFoundException e) {
       e.printStackTrace();
    } 
```
###### 结果
```xml
<object-stream>
   <student>
      <firstName>Mahesh</firstName>
      <lastName>Parashar</lastName>
   </student>
   <student>
      <firstName>Suresh</firstName>
      <lastName>Kalra</lastName>
   </student>
    <string>Hello World</string>
</object-stream> 
```


###### 输入
```java
  XStream xstream = new XStream(new StaxDriver());		
  xstream.autodetectAnnotations(true);
  Student student1 = new Student("Mahesh","Parashar");	
  Student student2 = new Student("Suresh","Kalra");	
  
   try {
         ObjectInputStream objectInputStream = xstream.createObjectInputStream(new FileInputStream("test.txt"));
         Student student3 = (Student)objectInputStream.readObject();
         Student student4 = (Student)objectInputStream.readObject();
         String text = (String)objectInputStream.readObject();
         
   }catch (IOException e) {
       e.printStackTrace();
    } catch (ClassNotFoundException e) {
       e.printStackTrace();
    } 
```

#### 5. XStream 支持自定义对象序列化到xml和xml反序列化到对象。
实现Converter接口
````java

public interface Converter {

  // 检查支持的对象类型的序列化
  public boolean canConvert(Class object) ;
  
  // 序列化对象到XML
  public void marshal(Object value, HierarchicalStreamWriter writer,
      MarshallingContext context);
  
  // 从XML对象反序列化
  public Object unmarshal(HierarchicalStreamReader reader,
      UnmarshallingContext context);    
}
​```

#### 6. 对象转为json
​```java
  XStream xstream = new XStream(new JsonHierarchicalStreamDriver() {
		    public HierarchicalStreamWriter createWriter(Writer writer) {
		        return new JsonWriter(writer, JsonWriter.DROP_ROOT_MODE);
		    }  
	});
  
  Student student = new Student("Mahesh","Parashar");
  xstream.setMode(XStream.NO_REFERENCES);
  System.out.println(xstream.toXML(student));      
    
  
  /////////////  getter/setter 和构造函数省略
  @XStreamAlias("student")
class Student {
	
	private String firstName;
	private String lastName;
  
}
​```

###### 结果
​```json
{
  "firstName": "Mahesh",
  "lastName": "Parashar"
}
​```

#### 7, 注意： 当bean中的某个属性没有赋值时，是没法显示的。

#### 8. 注意：当继承时，相当于给这个类添加属性，添加的属性和本身的属性是同级的，添加的属性显示在前面
````