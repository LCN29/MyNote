# final
  
### 1.修饰变量
被final修饰的变量只能进行一次赋值操作，并且在生存期内不可以改变它的值。

```java
    //1
    private final int num = 1;
    
    //2
    private final int value;
    value = 2;
    
    //3
    final Object obj = new Object();
    obj.value = 111;
```
> 1. 被final修饰的变量在声明时一起赋值，则后面将无法对其进行修改了。
> 2. final修饰的变量可以不在声明时赋值，即可以先声明，后赋值。
> 3. 当final修饰的是一个对象时，只能保证这个对象的引用不被修改，而无法保证引用对象的值不被修改。既无法执行的操作 `obj = new Object()`重新为其赋值另一个对象, 但是对象里面的值可以随意修改`obj.value = 111; obj.name = "ffff" `。
  
### 2.修饰方法参数
在方法的参数前面添加final关键字，它表示在整个方法中，是无法进行修改的
```java
    public void test(final int i; final Object obj) {
        // i = 666; 修改了值，错误
        // obj = new Object(); 修改了值，错误
        obj.value = "55";  //修改对象里面的值可以
    }
```
用final 修饰的方法参数的限制和变量一样

### 3.修饰方法（类中的这个方法不能为重写）和4.修饰类很少使用(这个类无法被继承)，pass