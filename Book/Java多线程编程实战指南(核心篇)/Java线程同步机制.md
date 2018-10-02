# Java线程同步机制


### 锁

#####  1.介绍
可以理解为一个许可证。一个线程在访问临界区(被锁包住的代码块)需要先申请这个许可证，才能进行运行，否则会阻塞在这里。

#####  2.作用
其作用包括保障原子性、保障可见性和保障有序性（相对的，临界区不会和临界区外的代码进行指令交换，但是临界区内的依旧还是可以进行指令交换的）

##### 3.锁的几个概念
>1. 可重入性： 一个线程在其持有一个锁的时候能否再次（或者多次）申请该锁。如果一个线程持有一个锁的时候还能够继续成功申请该锁，那么我们就称该锁是可重入的（Reentrant），否则我们就称该锁为非可重入的（Non-reentrant）。
```java
	void methodA() {
		// 申请锁
		acquireLock(lock);

		methodB();

		releaseLock(lock);
	}


	void methodB() {
		// 申请锁
		acquireLock(lock);

		// 释放锁
		releaseLock(lock);
	}
```

>2. 争用调度
Java平台中锁的调度策略也包括公平策略和非公平策略，相应的锁就被称为公平锁和非公平锁。内部锁属于非公平锁，而显式锁则既支持公平锁又支持非公平锁。

>3. 锁的粒度
一个锁实例所保护的共享数据的数量大小就被称为该锁的粒度（Granularity）。一个锁实例保护的共享数据的数量大，我们就称该锁的粒度粗，否则就称该锁的粒度细。锁粒度的粗细是相对的，

##### 4.锁的开销 （总的来说：消耗的为处理器的时间）
>1. 锁的申请和释放
>2. 上下文的切换

##### 5.锁的分类
>1. 内部锁 synchronized
>2. 显示锁 java.util.concurrent.lcoks.Lock接口的实例。

##### 6.内部锁：synchronized关键字
>1. 2种使用方式
```java
	
	// 修饰方法，默认的锁句柄为当前类
	void synchronized methodB() {
		// synchronized 包住的区域称为 临界区
	}

	void methodB() {

		synchronized(锁句柄) {

		}
	}

```

>2. 特点
>>1. 线程对内部锁的申请与释放的动作由Java虚拟机负责代为实施，
>>2. 仅支持非公平调度


##### 7.显示锁
>1. 默认的实现 java.util.concurrent.lcoks.ReentrantLock

>2. 使用
```java

	private final Lock lock= new ReentrantLock();

	public void methodA() {
		// 申请锁
		lock.lock();

		try{

			// 代码 临界区

		} catch (Exception e) {

		} finally {
			lock.unlock();
		}

	}
```
>3. 特点
>>1. 可重入
>>2. 既支持非公平调度，也支持公平调度
>>3. 申请和释放，都需要通过代码

##### 8.显示锁和内部锁的比较
>1. 内部锁是基于代码块的锁，因此其使用基本无灵活性可言：要么使用它，要么不使用它，除此之外别无他选。而显式锁是基于对象的锁，其使用可以充分发挥面向对象编程的灵活性。而内部锁从代码角度看仅仅是一个关键字，它无法充分发挥面向对象编程的灵活性。比如，内部锁的申请与释放只能是在一个方法内进行（因为代码块无法跨方法），而显式锁支持在一个方法内申请锁，却在另外一个方法里释放锁。
>2. 显示锁还提供了许多其他的方法，可以操作
>>1. `tryLock()` 尝试获取锁
>>2. `tryLock(long time, TimeUtil unit)` 在指定的时间内获取锁
>>3. `isLocked()` 相应锁是否被某个线程持有
>>4. `getQueueLength()`  检查相应锁的等待线程的数量

##### 9.读写锁
>1. 读写锁（Read/WriteLock）是一种改进型的排他锁，也被称为共享/排他（Shared/Exclusive）锁。
>2. 任何线程读取共享变量的时候，其他线程无法更新这些变量；一个线程更新共享变量的时候，其他任何线程都无法访问该变量。
>3. java.util.concurrent.locks.ReadWriteLock接口是对读写锁的抽象，其默认实现类是java.util.concurrent.locks.ReentrantReadWriteLock。
```java
	public class ReadWriteLockUsage { 

		private final ReadWriteLock rwLock = new ReentrantReadWriteLock();
		private final Lockread Lock = rwLock.readLock();
		private final LockwriteLock = rwLock.writeLock();
		// 使用和显示锁一样
		
	}
```
>4. 使用情景 
>>1. 只读操作比写（更新）操作要频繁得多；
>>2. 读线程持有锁的时间比较长。

>5. 读写锁是个可重入锁。

##### 10.内存屏障
>1. 锁的获取和释放分别会执行：刷新处理器缓存和冲刷处理器缓存(前一个保证了该锁的线程读取到相对新的值, 后者保证了该锁的线程对数据的更新，能被其他线程获取)
>2. 底层的实现借助了：内存屏障。它在指令序列（如指令1；指令2；指令3）中就像是一堵墙（因此被称为屏障）一样使其两侧（之前和之后）的指令无法“穿越”它（一旦穿越了就是重排序了）,同时实现刷新处理器缓存、冲刷处理器缓存，从而保证可见性。

##### 11. volatile关键字
>1. volatile关键字用于修饰共享可变变量，被修饰的变量不会被编译器分配到寄存器进行存储，对volatile变量的读写操作都是内存访问（访问高速缓存相当于主内存）操作。
>2. volatile关键字保证可见性和有序性，但是不保证原子性，如a = a + 1（read - modify - write） 在多线程情况下，还是会出错。
>3. volatile 不会导致上下文的切换
>4. 如果被volatile修饰的变量为一个引用变量，volatile关键字只是保证读线程能够读取到一个指向对象的相对新的内存地址（引用），但是引用地址的对象里面的属性值进行了修改，volatile是无法进行保证可见性和有序性
>5. 某种情况下，可以替代锁, 把这一组可变状态变量封装成一个对象,那么对这些状态变量的更新操作就可以通过创建一个新的对象并将该对象引用赋值给相应的引用型变量来实现,在这个过程中,volatile保障了原子性和可见性,从而避免了锁的使用。


##### 12. 实践：单例
>1. 简单版
```java
	public class Singleton {

		private static Singleton INSTANCE = null ;

		private Singleton() {
		}

		public static Singleton getInstance() {

			if (INSTANCE == null) {
				INSTANCE = new Singleton();
			}

			return INSTANCE;
		}
	}
```
分析： if() 是一个 check - then - act, 有几率出现 2个线程同时读取到 INSTANCE == null


>2. 加锁版
```java
	public static Singleton getInstance() {
		synchronized (Singleton.class) {
			if (null == INSRANCE) {
				INSTANCE = new Singleton();
			}

			return INSRANCE;
		}
	}
```
分析： 线程安全了, 但是每次获取实例时, 都需要申请锁，影响到性能

>3. 加锁优化版
```java

	public static Singleton getInstance() {

		if (null == INSRANCE) {   // 1
			synchronized(Singleton.class) {
				if (null == INSRANCE) {	//2
					INSTANCE = new Singleton();		// 3
				}
			}
		}

		return INSTANCE;
	}
```
分析： 操作3可以拆分成以下的操作
```java

	objRef = allocate(Singleton.class);
	invokeConstructor(objRef);
	INSTANCE = objRef;


	// 但是在有序性的下，可能变成这样
	objRef = allocate(Singleton.class);
	INSTANCE = objRef;
	invokeConstructor(objRef);
```
这是如果有一个线程到了上面的`INSTANCE = objRef` 此时INSTANCE是一个只是初始化的对象，没有真正的赋值，又有一个线程到了，刚刚读取到了`INSTANCE != null`, 返回了一个未真正实例过的对象了

>4. 静态内部类
```java
	public class StaticSingleton{

		private StaticSingleton(){
		}

		public static StaticSingleton getInstance() {
			return InstanceHolder.INSTANCE;
		}

		private static class InstanceHolder{
			final static StaticSingleton INSTANCE = new StaticSingleton();
		}

		private void someService(){
		}
	}
```
分析：利用静态变量的2个特性 (1)类的静态变量只会创建一次，因此StaticSingleton（单例类）只会被创建一次。 (2)静态变量被初次访问会触发Java虚拟机对该类进行初始化,即该类的静态变量的值会变为其初始值而不是默认值。静态方法getInstance()被调用的时候Java虚拟机会初始化这个方法所访问的内部静态类InstanceHolder,这使得InstanceHolder的静态变量INSTANCE被初始化。

>5. 基于枚举类型的单例模式
```java
	public enum Singleton {
		INSTANCE;

		Singleton(){
		}

		public void someService() {
		}
	}
```
分析：其字段INSTANCE值相当于该类的唯一实例。这个实例是在Singleton.INSTANCE初次被引用的时候才被初始化的。

##### 13. 对象的发布和逸出
>1. 发布: 使对象能够在当前作用域之外的代码中使用
>2. 逸出: 当某个不该被发布的对象被发布时，这种情况称为逸出

>3. 发布的模式
>>1. 直接一个public
```java
	public Integer num;
```

>>2. get方法
```java
	private Integer num;

	public Integer getNum() {
		return num;
	}
```

>>3. 共有方法，但是使用到了这个变量
```java
	private Integer num;

	public int showNum() {
		int sum = num + 1;
		return sum;
	}
```

>>4. 创建内部类，使得当前对象（this）能够被这个内部类使用。
```java
	public void startTask(final Object task) {
		Thread t = new Thread(new Runable() {
			@Override
			public void run() {
				// 这里面可以方法 this
			}
		});

		t.shart();
	}
```


##### 14.对象的安全初始化
>1. Java中类的初始化实际上采取了延迟加载的技术，即一个类被Java虚拟机加载之后，该类的所有静态变量的值都仍然是其默认值（引用型变量的默认值为null,boolean变量的默认值为false），
直到有个线程初次访问了该类的任意一个静态变量才使这个类被初始化——类的静态初始化块（“static{}”）被执行，类的所有静态变量被赋予初始值
>2. static关键字在多线程环境下有其特殊的涵义，它能够保证一个线程即使在未使用其他同步机制的情况下也总是可以读取到一个类的静态变量的初始值（而不是默认值）。但是后续的操作，是没法保证其安全性的。
>3. 对于引用型静态变量，static关键字还能够保障一个线程读取到该变量的初始值时，这个值所指向（引用）的对象已经初始化完毕。