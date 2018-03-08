# Item02 当构造方法参数过多时使用builder模式
  
  
  在实际中，当参数比较多时，创建对象的方式
  
  ##### 一，可伸缩（telescoping constructor）构造方法模式
    提供一个参数中必填的构造函数，提供一个包含所有参数的构造函数，然后从必填构造函数开始不断增加非必填参数的构造函数的个数
  
  ```java
  public class Student {
  
      /**必填属性 */
      private String name;
      private String number;
  
      /** 非必填属性 */
      private String phone;
      private String address;
      
      public Student(String name, String number) {
          this(name,number,"没有");
      }
  
      public Student(String name, String number, String phone) {
          this(name,number,phone,"未填");
      }
  
      public Student(String name, String number, String phone, String address) {
          this.name = name;
          this.number = number;
          this.phone = phone;
          this.address = address;
      }
  }
  ```
  `缺点：当参数更多时，会失控，难以读懂`
  
  ##### 二，JavaBeans模式
    只提供一个无参的构造函数，所有属性提供setter方法，通过setter给属性赋值
    
  ```java
      public class Teacher {
  
      /**必填属性 */
      private String name;
      private String number;
  
      /** 非必填属性 */
      private String phone;
      private String address;
  
      public Teacher(){}
  
      public String getName() {
          return name;
      }
  
      public void setName(String name) {
          this.name = name;
      }
  
      public String getNumber() {
          return number;
      }
  
      public void setNumber(String number) {
          this.number = number;
      }
  
      public String getPhone() {
          return phone;
      }
  
      public void setPhone(String phone) {
          this.phone = phone;
      }
  
      public String getAddress() {
          return address;
      }
  
      public void setAddress(String address) {
          this.address = address;
      }
  }
  ```
  `缺点: 通过JavaBean创建出来的实例,构造函数只负责创建出一个实例,然后通过setter赋值，可能会造成各个实例间有着不一致。如上面的Teacher类，teacherA给phone赋值了,但是地址没有，teacherB却没有，但是给地址赋值了,最终在使用时，只能摸索着使用，应该他们存在着实例，`
  
  ##### 三，Builder模式
  ```java
      public class Principal {
  
      /**必填属性 */
      private String name;
      private String number;
  
      /** 非必填属性 */
      private String phone;
      private String address;
  
      public static class Builder {
          private final String name;
          private final String number;
  
          /** 非必填属性 */
          private String phone = "无";
          private String address = "未填";
  
          /**必填参数，通过构造函数填充 */
          public Builder(String name, String number) {
              this.name = name;
              this.number = number;
          }
  
          /**非必填函数通过setter方法填充 */
          public Builder setPhone(String phone) {
              this.phone = phone;
              return this;
          }
  
          public Builder setAddress(String address) {
              this.address = address;
              return this;
          }
  
          /** 通过builder方法获取实例 */
          public Principal build() {
              return new Principal(this);
          }
      }
  
      private Principal(Builder builder){
          name = builder.name;
          number = builder.number;
          phone = builder.phone;
          address = builder.address;
      }
  
      public String getName() {
          return name;
      }
  
      public void setName(String name) {
          this.name = name;
      }
  
      public String getNumber() {
          return number;
      }
  
      public void setNumber(String number) {
          this.number = number;
      }
  
      public String getPhone() {
          return phone;
      }
  
      public void setPhone(String phone) {
          this.phone = phone;
      }
  
      public String getAddress() {
          return address;
      }
  
      public void setAddress(String address) {
          this.address = address;
      }
  }
  
  //创建对象
  Principal principal = new Principal.Builder("校长","123").setPhone("7707").build();
  ```
  
  #### Builder同时十分适合类的层次结构，使用平行层次的builder，每个嵌套在相应的类中。抽象类有抽象的builder; 具体的类有具体的builder。如用一个抽象类来表示各种披萨的根层次结构。
  
  ```java
  public abstract class Pizza {
  
      /** 披萨上面放的东西的选择 */
      public enum Topping {HAM, MUSHROOM, ONION, PEPPER, SAUSAGE}
  
      /** 指定的披萨放的东西 */
      final Set<Topping> toppings;
      
      /** 自限定类型 */
      abstract static class Builder<T extends Builder<T>> {
          EnumSet<Topping> toppings = EnumSet.noneOf(Topping.class);
  
          public T addTopping(Topping topping) {
              toppings.add(Objects.requireNonNull(topping));
              return self();
          }
  
          abstract Pizza build();
  
          /**子类必须重写这个方法，并返回this */
          protected abstract T self();
      }
  
      Pizza(Builder<?> builder) {
          toppings = builder.toppings.clone();
      }
  }
  ```
  
  #### 纽约风格的披萨（可以指定尺寸大小）
  ```java
  public class NyPizza extends Pizza {
      /** 可以指定这个披萨的大小 */
      public enum Size { SMALL, MEDIUM, LARGE }
      private final Size size;
  
      public static class Builder extends Pizza.Builder<Builder> {
  
          private final Size size;
  
          public Builder(Size size) {
              this.size = Objects.requireNonNull(size);
          }
  
          @Override
          public NyPizza build() {
              return new NyPizza(this);
          }
  
          @Override
          protected Builder self() {
              return this;
          }
      }
  
      private NyPizza(Builder builder) {
          super(builder);
          size = builder.size;
      }
  }
  ```
  
  #### 半圆形烤乳酪馅饼(指定是否加酱汁)
  
  ```java
  public class Calzone extends Pizza {
      /** 是否加酱汁 */
      private final boolean sauceInside;
  
      public static class Builder extends Pizza.Builder<Builder> {
          /** 默认不加酱汁 */
          private boolean sauceInside = false;
  
          public Builder sauceInside() {
              sauceInside = true;
              return this;
          }
  
          @Override
          public Calzone build() {
              return new Calzone(this);
          }
  
          @Override
          protected Builder self() {
              return this;
          }
      }
  
      private Calzone(Builder builder) {
          super(builder);
          sauceInside = builder.sauceInside;
      }
  }
  ```
  ### 优点
  > 1. builder可以有多个可变参数
  > 2. builder可以将某个多次调用的参数聚合到单个属性上，如前面的addTopping方法。
  > 3. 单个builder可以重复使用来构建多个对象
  > 4. builder的参数可以在构建方法的调用之间进行调整，以改变创建的对象
  > 5. builder可以在创建对象时自动填充一些属性，例如每次创建对象时增加的序列号
  
  ### 缺点
  > 1. 为了创建对象，首先必须创建它的builder。虽然创建这个builder的成本在实践中不太可能被注意到，但在性能关键的情况下可能会出现问题
  > 2. builder模式比伸缩构造方法模式更冗长，因此只有在有足够的参数时才值得使用它,比如四个或更多。
  > 
  
  ### 设计类时，如果这个类未来会不断增加参数的话，请一开始就设计为builder模式，否则，后面从构造方法或者静态工厂模式切换过来，会很麻烦。