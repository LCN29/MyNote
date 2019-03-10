# Item05 使用依赖注入取代硬连接资源（hardwiring resources）

许多类依赖于一个或多个底层资源。例如，拼写检查器依赖于字典，将此类类实现为静态实用工具类并不少见。

#### 方式一 : 静态工具类
```java
public class SpellChecker {

   private static final Lexicon dictionary = ...;
   
    // Noninstantiable 不可实例化
   private SpellChecker() {}
   
   public static boolean isValid(String word){
        return dictionary.isValid(word);
    }
    
}

// 调用
One.isValid("2343")

```

#### 方式二 : 单例模式
```java
public class Two {

    public static final Two INSTANCE = new Two();
    private final Lexicon dictionary = new Lexicon();

    private Two(){}
    
    public  boolean isValid(String word){
        return dictionary.isValid(word);
    }
    
}

//使用
Two.INSTANCE.isValid("4444")
```

静态工具类和单例对于那些行为被底层资源参数化的类来说是不合适的。（根据具体情况，具体输入）
如上面的词典已经被定死了，比如只能检测英文，但是如果现在有日文，德文等，就需要修改类

所以某个类需要支持多个实例，每个实例有不同的行为，所以建议以依赖注入来创建对象

可以通过依赖注入：通过构造函数注入实例，框架的注解等

```java
public class Three {
  
   private final Lexicon dictionary;
   
   /** 创建新实例时将资源传递到构造方法中。这是依赖项注入（dependency injection）的一种形式 */
    public Three(Lexicon dictionary) {
        // 如果dictionary为null 抛出异常
        this.dictionary = Objects.requireNonNull(dictionary);
    }
    
    public  boolean isValid(String word){
        return dictionary.isValid(word);
    }

}

//调用
Three three = new Three(new Lexicon());
three.isValid("124323")
```

`总之，不要使用单例或静态的实用类来实现一个类，该类依赖于一个或多个底层资源，这些资源的行为会影响类的行为，并且不让类直接创建这些资源。这种称为依赖注入的实践将极大地增强类的灵活性、可重用性和可测试性`
