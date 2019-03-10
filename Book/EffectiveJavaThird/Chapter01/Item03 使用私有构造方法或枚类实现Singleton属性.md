# Item03 使用私有构造方法或枚类实现Singleton属性

单例对象通常表示无状态对象，如函数或一个本质上唯一的系统组件。让一个类成为单例会使测试它的客户变得困难，因为除非实现一个作为它类型的接口，否则不可能用一个模拟实现替代单例
  
  ### 实现单例的方式3种
  
  ##### 一
  ```java
  public class One {
  
      public static final One INSTANCE = new One();
  
      private One(){
      }
  
      public void test() {
          System.out.println("单例实现方式一");
      }
      
  }
  
  //调用
  One one = One.INSTANCE;
  one.test();
  ```
  `注意：特权客户端可以使用AccessibleObject.setAccessible方法，以反射方式调用私有构造方法。如果需要防御此攻击，请修改构造函数，使其在请求创建第二个实例时抛出异常`
  
  ##### 二
  ```java
  public class Two {
  
      private static final Two INSTANCE = new Two();
  
      private Two(){
      }
  
      public static Two getInstance(){
          return INSTANCE;
      }
  
      public void test() {
          System.out.println("单例实现方式二");
      }
  }
  
  //调用
  Two two = Two.getInstance();
  two.test();
  ```
  `好处: API明确表示这个是一个单例，而且他更简单。同时使用了静态工厂的方式:（1）工厂方法返回唯一的实例，但是可以修改，比如，返回调用它的每个线程的单独实例等，而不用修改其他的Api，（2）如果你的应用程序需要它，可以编写一个泛型单例工厂，（3）方法引用可以用supplier，例如Elvis :: instance等同于Supplier<Elvis>`
  
  `创建一个使用这两种方法的单例类,仅仅implements Serializable添加到声明中是不够的,为了维护单例的保证，声明所有的实例属性为transient，并提供一个readResolve方法。否则，每当序列化实例被反序列化时，就会创建一个新的实例`
  
  ```java
      private Object readResolve() {
       // 返回实例
      return INSTANCE;
  }
  
  ```
  
  ##### 三
  ```java
  //声明单一元素的枚举类
  public enum  Three {
      INSTATNCE;
  
      public void test() {
          System.out.println("单例实现方式三");
      }
  }
  
  //调用
  Three.INSTATNCE.test();
  ```
  `声明单一元素的枚举类这种方式类似于公共属性方法，但更简洁，提供了免费的序列化机制，并提供了针对多个实例化的坚固保证，即使是在复杂的序列化或反射攻击的情况下。这种方法可能感觉有点不自然，但是单一元素枚举类通常是实现单例的最佳方式。注意，如果单例必须继承Enum以外的父类(尽管可以声明一个Enum来实现接口)，那么就不能使用这种方法`