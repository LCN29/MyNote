# Item06 避免创建不必要的对象

在每次需要时重用一个对象而不是创建一个新的相同功能对象通常是恰当的。重用可以更快更流行
```java
String str = "我是开始:";
for (int i = 0; i < 10000; i++) {
    String temp  = new String ("-");
    str += temp;
}
System.out.println(str);
```
耗时: 123毫秒

```java
String str = "我是开始:";
String temp = null;
for (int i = 0; i < 10000; i++) {
    temp  = "-";
    str += temp;
}
System.out.println(str);
```
耗时：99毫秒

第一种：每次执行时都会创建一个新的String实例，而这些对象的创建都不是必需的。
第二种：使用单个String实例，避免了重复创建对象


`一些昂贵的对象，创建完建议将其缓存起来以便重复使用`
```java
public static boolean isRomanNumeral(String s) {
    return s.matches("^(?=.)M*(C[MD]|D?C{0,3})"
            + "(X[CL]|L?X{0,3})(I[XV]|V?I{0,3})$");
}
```
这个实现的问题在于它依赖于String.matches方法虽然String.matches是检查字符串是否与正则表达式匹配的最简单方法，问题是它在内部为正则表达式创建一个Pattern实例，并且只使用它一次，之后它就有资格进行垃圾收集。创建Pattern实例是昂贵的，因为它需要将正则表达式编译成有限状态机（finite state machine）

优化
```java
public class RomanNumerals {
  private static final Pattern ROMAN = Pattern.compile(
            "^(?=.)M*(C[MD]|D?C{0,3})"
            + "(X[CL]|L?X{0,3})(I[XV]|V?I{0,3})$");

  static boolean isRomanNumeral(String s) {
    return ROMAN.matcher(s).matches();
  }

}
```

另一种创建不必要的对象的方法是自动装箱。它允许程序员混用基本类型和包装的基本类型，根据需要自动装箱和拆箱，但不会消除基本类型和装箱基本类型之间的区别,其间有微妙的性能差。例如：它计算所有正整数的总和。 要做到这一点，程序必须使用long类型，因为int类型不足以保存所有正整数的总和
```java
private static long sum() {
  Long sum = 0L;
  for (long i = 0; i <= Integer.MAX_VALUE; i++){
      sum += i;
  }
  return sum;
}
```
`耗时: 8376`

```java
private static long sum2() {
  long sum = 0L;
  for (long i = 0; i <= Integer.MAX_VALUE; i++){
    sum += i;
  }
  return sum;
}
```
`耗时：1532`

变量sum被声明成了Long而不是long，这意味着程序构造了大约2^31不必要的Long实例（大约每次往Long类型的sum变量中增加一个long类型构造的实例）`优先使用基本类型而不是装箱的基本类型，也要注意无意识的自动装箱`
