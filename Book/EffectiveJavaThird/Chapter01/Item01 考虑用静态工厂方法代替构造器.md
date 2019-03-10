# Item01 考虑用静态工厂方法代替构造器
  
  ```java
      
      public static Boolean valueOf(boolean b) {
          return b ? Boolean.TRUE : Boolean.FALSE;
      }
      
      //使用构造器
      Boolean b1 = new Boolean(true);
      //使用静态工厂方法
      Boolean b2 = Boolean.valueOf(true); 
      
  ```
  ### 好处
  
  ##### 1. 不像构造方法，它们是有名字的
  正常的情况下，我们都是通过构造函数来创建对象，但是一旦构造函数多了，我们应该用哪个来创建出自己需要的对象呢？但是如果我们使用的是静态工厂,因为其本身有一个具体意义的名称，生成的对象对于客户端来说，更加容易阅读。
  参数类型和个数都相同时，这个类就只能有一个构造函数了，如果此时，需要提供出2个构造函数，只能交互参数的顺序了(具体的使用情景未知)，但是这样的Api对于用户来说是一种槽糕的写法，因为他们无法确定调用那个。而静态方法可以通过给定不同的名字，而创建出意义不同的对象。
  eg: 为了获得一个素数，通过BigInteger的BigInteger(int，int，Random)这个方法获取到的实例和通过BigInteger.probablePrime的静态工厂方法获取到的实例哪个更加好呢？
  
  ##### 2. 与构造方法不同，它们不需要每次调用时都创建一个新对象
  允许不可变的类使用预先构建的实例,或者在构造时缓存实例,并反复分配它们以避免创建不必要的重复对象(单例模式)。
  静态工厂方法的从不断的调用中返回相同实例的能力，使得类在任何时候对实例有严格的控制。这样做的类被称为实例控制（instance-controlled）。实例控制允许一个类来保证它是一个单例项或不可实例化的，同时它允许一个不可变的值类保证不存在两个相同的实例。
  
  ##### 3. 与构造方法不同，它们可以返回其返回类型的任何子类型的对象
  如有一个接口Person,2个实现类Student和Teacher。一个获取实例的类GetPerson。
  ```java
  public class GetPerson {
  
      public static Person getStudent(){
          return new Student();
      }
  
      public static Person getTeacher(){
          return new Teacher();
      }
  }
  
  // 使用
  Person person = GetPerson.getStudent();
  person.getType();
  Person person1 = GetPerson.getTeacher();
  person1.getType();
  
  ```
  这种灵活性的一个应用是API可以返回对象而不需要公开它的类。 以这种方式隐藏实现类会使 API非常紧凑,这种技术适用于基于接口的框架，其中接口为静态工厂方法提供自然返回类型。
  
  ##### 4. 返回对象的类可以根据输入参数的不同而不同
  如 EnumSet类会根据底层枚举类型的大小返回两个子类中的一个的实例，如果大多数枚举类型的元素少于64个(包含64)，将返回一个RegularEnumSet实例，返回一个long类型。反之，返回一个JumboEnumSet实例，返回一个long类型的数组。这两个实现类的存在对于客户是不可见的
  
  ##### 5. 在编写包含该方法的类时，返回的对象的类不需要存在
  这种灵活的静态工厂方法构成了服务提供者框架的基础。
  服务提供者框架，三要素:
  >1. 服务接口        表示实现
  >2. 提供者注册API   提供者用来注册实现
  >3. 服务访问API     客户端使用该API获取服务的实例(服务访问API是灵活的静态工厂,服务访问API允许客户指定选择实现的标准。在缺少这样的标准的情况下，API返回一个默认实现的实例，或者允许客户通过所有可用的实现进行遍历)
  >4. 服务提供者接口(可选) 描述了一个生成服务接口实例的工厂对象,在没有服务提供者接口的情况下，必须对实现进行反射实例化
  
  现在以网易云音乐为例
  >1. 服务接口：应用市场对音乐客户端的规定
  >2. 服务提供者接口：应用市场对商家的规定
  >3. 提供者注册API：网易云音乐（商家）向应用市场注册
  >4. 服务访问API：用户下载客户端
  
  ```java
      //服务接口
      interface MusicApp {
          void play();
      }
      
      //服务提供者接口
      interface MusicProvider {
          MusicApp getMusicApp();
      }
      
      class AppStore {
          private AppStore() {}
          
          private static final Map<String, MusicProvider> providers = new ConcurrentHashMap<String, MusicProvider>();
          
          //服务注册API
          public static void registerProvider(String name, MusicProvider p) {
              providers.put(name, p);
          }
      
          //服务访问API
          public static MusicApp installApp(String name) {
              MusicProvider p = providers.get(name);
              if (p==null) {
              throw new IllegalArgumentException("No provider registerd with      name:" + name);
          }
              return p.getMusicApp();
          }
      
      }
  
  ```
  
  
  ### 坏处
  ##### 1. 没有公共或受保护构造方法的类不能被子类化
  
  
  ##### 2. 程序员很难找到它们
  它们不像构造方法那样在API文档中突出，因此很难找出如何实例化一个提供静态工厂方法而不是构造方法的类