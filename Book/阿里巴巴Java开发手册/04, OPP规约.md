# 04, OPP规约

>1. 类里面的静态方法，可以不通过new对象后，在通过对象.方法()使用，可以直接类名.方法，不需要担心编译的问题

>2. 所有的覆写方法，必须加@Override注解,可以判断覆写是否成功，同时接口等的修改，实现类就可以马上报错

>3. 相同参数类型，相同业务含义，才可以使用 Java 的可变参数,避免使用 Object。同时可变参数必须放置在参数列表的最后，还有就是尽量不要使用可变参数进行编程
>`myFun(String arg1, Integer num, Float... data)`

>4. 对外暴露的接口签名，原则上不允许修改方法签名，避免对接口调用方产生影响。接口过时必须加@Deprecated 注解，并清晰地说明采用的新接口或者新服务是什么。

>5. 不能使用过时的类或方法

>6. Object 的 equals 方法容易抛空指针异常，应使用常量或确定有值的对象来调用equals。
>`反例 object.equals("test")    正例 "test".equals(object)`

>7. 包装类(Integer,Float)对象之间值的比较，全部使用 equals 方法比较,不使用 == 。（Integer 的变量，在-128 至 127 之间的赋值时，Integer 对象是在IntegerCache.cache 产生会复用已有对象，这个区间内的 Integer 值可以直接使用==进行判断，但是这个区间之外的所有数据，都会在堆上产生，并不会复用已有对象，这是一个大坑，所以推荐使用 equals 方法进行判断）

>8. 基本数据类型与包装数据类型的使用标准
>>1. 所有的 POJO 类属性必须使用包装数据类型
>>2. RPC 方法的返回值和参数必须使用包装数据类型
>>3. 所有的局部变量【推荐】使用基本数据类型

>9. 定义 DO/DTO/VO 等 POJO 类时，不要设定任何属性默认值。

>10. 序列化类新增属性时，请不要修改 serialVersionUID 字段，避免反序列失败,如果完全不兼容升级，避免反序列化混乱，那么请修改 serialVersionUID 值

>11. 构造方法里面禁止加入任何业务逻辑，如果有初始化逻辑，请放在 init 方法中

>12. POJO类必须写toString方法,如果继承了另一个 POJO 类，注意在前面加一下super.toString。

>13. 使用索引访问用 String 的 split 方法得到的数组时，需做最后一个分隔符后有无内容的检查，否则会有抛 IndexOutOfBoundsException 的风险
## demo
```java
  String str = "a,b,c,,";
  String[] ary = str.split(",");
  //预期大于 3，结果是 3
  System.out.println(ary.length); 
```

>14. 当一个类有多个构造方法，或者多个同名方法，这些方法应该按顺序放置在一起，便于阅读。

>15. 类内方法定义顺序依次是：公有方法或保护方法 > 私有方法 > getter/setter方法。

>16. setter 方法中，参数名称与类成员变量名称一致，this.成员名=参数名。在getter/setter 方法中，尽量不要增加业务逻辑，增加排查问题的难度。

>17. 循环体内，字符串的联接方式，使用 StringBuilder 的 append 方法进行扩展。(原因:反编译出的字节码文件显示每次循环都会 new 出一个 StringBuilder 对象，然后进行append 操作，最后通过 toString 方法返回 String 对象，造成内存资源浪费。)

>18. final 可提高程序响应效率，声明成 final 的情况
>> 1. 不需要重新赋值的变量，包括类属性、局部变量
>> 2. 对象参数前加 final，表示不允许修改引用的指向。
>> 3. 类方法确定不允许被重写。

>19. 慎用 Object 的 clone 方法来拷贝对象,对象的 clone 方法默认是浅拷贝。

>20. 类成员与方法访问控制从严
>>1. 如果不允许外部直接通过 new 来创建对象，那么构造方法必须是 private
>>2. 工具类不允许有 public 或 default 构造方法。
>>3. 类非 static 成员变量并且与子类共享，必须是 protected。
>>4. 类非 static 成员变量并且仅在本类使用，必须是 private。
>>5. 类 static 成员变量如果仅在本类使用，必须是 private
>>6. 若是 static 成员变量，必须考虑是否为 final
>>7. 类成员方法只供类内部调用，必须是 private。
>>8. 类成员方法只对继承类公开，那么限制为 protected
