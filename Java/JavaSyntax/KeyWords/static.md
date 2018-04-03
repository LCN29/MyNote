# static
   
### 修饰属性

   正常情况下，类的属性是维护在实例里面的。每个类的实例都会一个自己的内存地址，属性都维护在自身。但是方法是维护在一块不变区域(由jvm划分的),可以共用。所以类的方法是共用的。
   如果给类的属性添加上static,效果就像是方法一样，将其放到了不变区域内，所有的实例都可以共用

    
### 修饰方法
可以通过不用创建实例，通过类名.方法名()的方式，调用方法
    
### 静态块
在java中一个类的初始过程: static修饰的成员变量-->普通的成员-->构造函数
如果现在这个类有静态方法呢？先调用其静态方法，再创建这个类的实例：static修饰的成员变量-->静态方法调用-->普通变量-->构造函数
    
静态块：就是将这个类中的静态变量统一起来，进行初始赋值静态初始化块只在类加载时执行，且只会执行一次，同时静态初始化块只能给静态变量赋值，不能初始化普通的成员变量
```java
  class Person {

      int num1;
      int num2;
      static int num3;

      public Person(){
          this.num1 = 666;
      }
      
      {   //普通初始块
          num2 = 777;
      }
      
      static { //静态初始块
          num3 = 888;
      }

  // 当第一次创建这个类时 静态初始块->普通初始块->构造函数
  // 第二次创建这个类时 普通初始块->构造函数 
  }
```
  

### 静态导包
将类的静态方法直接导入到当前类中，从而直接使用“方法名”即可调用类方法，更加方便。不同于非static导入，采用static导入包后，在不与当前类的方法名冲突的情况下，无需使用“类名.方法名”的方法去调用类方法了，直接可以采用"方法名"去调用类方法，就好像是该类自己的方法一样使用即可。

```java
    class Test() {
        public static void say() {
            System.out.println("你好");
        }
    }
    
    import static com.eigpay.Test.*;  //导入Test类的所有静态方法
    
    class Main() {
        public void doSomethings() {
            say();  //此处直接使用 方法为静态方法
        }
    }  
```
  
### 静态内部类
具体的用途貌似是用于测试某个类的逻辑
和普通的内部类的区别：
```java
    // 普通的内部类
    OutClass oc = new OutClass2();   
    OutClass.InnerClass2 ic = oc.new InnerClass2(); //依赖与外部类的实例

    // 静态内部类
    OutClass oc = new OutClass1();   
    InnerStaticClass ic = new InnerStaticClass(); //不依赖与外部类的实例 
```