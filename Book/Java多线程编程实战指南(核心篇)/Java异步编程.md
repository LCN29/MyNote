# Java异步编程

### 1. 同步计算与异步计算
(1)同步任务:以同步方式执行的任务。其任务的发起与任务的执行是在同一条时间线上进行的。换而言之，任务的发起与任务的执行是串行的。同步任务就好比我们以电话的形式将一个消息通知给朋友的情形：我们先拨打对方的号码（任务的发起），只有在电话接通（任务开始执行）之后我们才能够将消息告诉对方（任务执行的过程）

同步任务的发起线程在其发起该任务之后必须等待该任务执行结束才能够执行其他操作，这种等待往往意味着阻塞（Blocking），即任务的发起线程会被暂停，直到任务执行结束。例如，直接通过InpuStream.read()读取一个文件中的内容就是一个同步任务，在InpuStream.read()调用返回数据前该任务的发起线程会被暂停。 同步任务也并不一定总是会使其发起线程被阻塞，同步任务的发起线程也可能以轮询（任务的发起线程不断地检查其发起的任务是否执行结束，若任务已执行结束则执行下一步操作，否则继续检查任务，直到该任务完成。）的方式来等待任务的结束。阻塞意味着在同步任务执行结束前，该任务的发起线程并没有在运行（其生命周期状态不为RUNNABLE），而轮询意味着在同步任务执行结束前，该任务的发起线程仍然在运行，只不过此时该线程的主要动作是检查相应的任务是否执行结束。

(2)异步任务:以异步方式执行的任务。其任务的发起与任务的执行是在不同的时间线上进行的。换而言之，任务的发起与任务的执行是并发的。异步任务好比我们以短信的形式将一个消息通知给朋友的情形：我们只要给对方发送一条短信（任务的发起）便认为已经通知到对方了，而不必关心对方何时阅读这条短信，而实际上对方可能在第二天阅读这条短信（任务开始执行）。

异步任务的发起线程在其发起该任务之后不必等待该任务结束便可以继续执行其他操作，即异步任务的发起与实际执行可以是并发的。异步任务可以使其发起线程不必因等待其执行结束而被阻塞，即异步任务执行方式往往意味着非阻塞（Non-blocking）。然而，阻塞与非阻塞只是任务执行方式的一种属性，它与任务执行方式之间并没有必然的关系：同步任务执行方式多数情况下意味着阻塞，但是它也可能意味着非阻塞（轮询）；异步任务执行方式多数情况下意味着非阻塞，但是它也可能意味着阻塞。例如，如果我们在向线程池提交一个任务之后立刻调用Future.get()来试图获取该任务的处理结果（即ThreadPoolExecutor.submit(someTask).get()），那么尽管该任务是异步执行的，但是其发起线程仍然可能由于Future.get()调用时该任务尚未被线程池执行结束而被阻塞。异步任务的执行需要借助多个线程来实现。多个异步任务能够以并发的方式被执行。


### 2. Java Executor框架
(1) Runnable接口和Callable接口都是对任务处理逻辑的抽象，这种抽象使得我们无须关心任务的具体处理逻辑：不管是什么样的任务，其处理逻辑总是展现为一个具有统一签名的方法——Runnable.run()或者Callable.call()。

(2) java.util.concurrent.Executor接口则是对任务的执行进行的抽象(`void execute(Runnable command)`)。

(3) Executor接口使得任务的提交能够与任务执行的具体细节解耦（Decoupling）。和对任务处理逻辑的抽象类似，对任务执行的抽象也能给我们带来信息隐藏（Information）和关注点分离（SeparationOfConcern）的好处。

(4) 解耦任务的提交与任务的具体执行细节所带来的好处的一个例子是，它在一定程度上能够屏蔽任务同步执行与异步执行的差异。在编程中我们只需要把任务提交给Executror就行了，而Executror内部是同步执行还是异步执行，对于调用方来说并没有什么多大的区别。这就为更改任务的具体执行方式提供了灵活性和便利：更改任务的具体执行细节可能不会影响到任务的提交方，而这意味着更小的代码改动量和测试量。

(5)实用工具类Executors
>1. Executors.defaultThreadFactory(): 返回默认线程工厂
>2. Executors.callable(): 能够将Runnable实例转换为Callable实例

>3. 能够返回ExecutorService实例的快捷方法
>>1. Executors.newCachedThreadPool()/Executors.newCachedThreadPool(ThreadFactory threadFactory): 核心线程：0，最大线程池：Integer.MAX_VALUE, 线程存活时间60s, 缓存队列：SynchronousQueue(内部不维护用于存储队列元素的时间存储空间,既一个任务来了，就应该会被交给工作者线程)

特点：核心线程池大小为0，第一个任务会导致该线程池中的第一个工作者线程被创建并启动，后续继续给该线程池提交任务的时候，由于当前线程池大小已经超过核心线程池大小(0)，任务会被缓存到工作队列,而工作队列的容量为0，如果没有消费者线程去获取任务(take())，那么生产者线程会被暂停。但是基本都是提交任务会导致该任务无法被缓存成功，ThreadPoolExecutor的最大线程数未达到Integer.MAX_VALUE
，然后为这个任务创建并启动新的工作者线程，在极端的情况下，给该线程池每提交一个任务都会导致一个新的工作者线程被创建并启动，而这最终会导致系统中的线程过多，从而导致过多的上下文切换而使得整个系统被拖慢。

使用：Executors.newCachedThreadPool()所返回的线程池适合于用来执行大量耗时较短且提交频率较高的任务。

>>2. Executors.newFixedThreadPool(int nThreads)/ Executros.newFixedThreadPool(int nThreads, ThreadFactory threadFactory): 核心线程：nThreads, 最大线程：nThreads, 线程存活时间0毫秒(线程不会被自动清理的线程池)，缓存队列：LinkedBlockingQueue(队列有序，且容量无限)

特点：一个以无界队列为工作队列，核心线程池大小与最大线程池大小均为nThreads且线程池中的空闲工作者线程不会被自动清理的线程池，这是一种线程池大小一旦达到其核心线程池大小就既不会增加也不会减少工作者线程的固定大小的线程池。

使用：Executors.newFixedThreadPool(int nThreads)所返回的线程池在其不需要时，必须主动将其关闭。

>>3. Executors.newSingleThreadExecutor()/ Executors.newSingleThreadExecutor(ThreadFactory threadFactory): 核心线程：1，最大线程：1,线程存活时间0毫秒(线程不会被自动清理的线程池),缓存队列：LinkedBlockingQueue(队列有序，且容量无限)

特点：该线程池并非ThreadPoolExecutor实例，而是一个封装了ThreadPoolExecutor实例且对外仅暴露ExecutorService接口所定义的方法的一个ExecutorService实例。该线程池便于我们实现单（多）生产者—单消费者模式。该线程池确保了在任意一个时刻只有一个任务会被执行。这就形成了类似锁将原本并发的操作改为串行的操作的效果。因此，该线程池适合于用来执行访问了非线程安全对象而我们又不希望因此而引入锁的任务。该线程池也适合于用来执行I/O操作，因为I/O操作往往受限于相应的I/O设备，使用多个线程执行同一种I/O操作（比如多个线程各自读取一个文件）可能并不会提高I/O效率，所以如果使用一个线程执行I/O足以满足要求，那么仅使用一个线程即可，这样可以保障程序的简单性以避免一些不必要的问题（比如死锁）。

使用：Executors.newFixedThreadPool()所返回的线程池无法被转换为ThreadPoolExecutor，使用于单（多）生产者—单消费者模式。

(6) CompletionService:异步任务的批量执行 
CompletionService接口为异步任务的批量提交以及获取这些任务的处理结果提供了便利。
```java
	
	/**
	 * 可以用于异步提交任务
	 */
	Future<V> submit(Callable<V> task);

	/*
	 * 它是一个阻塞方法，其返回值是一个已经执行结束的异步任务对应的Future实例，该实例就是提交相应任务时submit(Callable<V>)调用的返回值。如果take()被调用时没有已执行结束的异步任务，那么take()的执行线程就会被暂
	 * 停，直到有异步任务执行结束。因此，我们批量提交了多少个异步任务，则多少次连续调用CompletionService.take()便可以获取这些任务的处理结果。
	 */
	Future<V> take() throws InterruptedException

	/**
     * 非阻塞方法用于获取异步任务的处理结果, 如果为队列为空的话，就返回null
     */
	Future<V> poll()

	/**
	 * 非阻塞方法用于获取异步任务的处理结果
	 */
	Future<V> poll(long timeout, TimeUnit unit) throws InterruptedException
```
Java标准库提供的CompletionService接口的实现类是ExecutorCompletionService, 其中的2个构造函数
```java

	/**
	 * 通过构造函数可以知道: executor用于异步任务的执行， completionQueue 用于存储异步完成任务的Future.
	 */
	ExecutorCompletionService(Executor executor, BlockingQueue<Future<V>> completionQueue);


	ExecutorCompletionService(Executor executor, newLinkedBlockingQueue<Future<V>>());

```

### 3. 异步计算助手：FutureTask
(1)采用Runnable实例来表示异步任务，其优点是任务既可以交给一个专门的工作者线程执行(以相应的Runnable实例为参数创建并启动一个工作者线程),也可以交给一个线程池或者Executor的其他实现类来执行; 缺点：无法直接获取任务的执行结果。

(2)采用Callable实例表示的异步任务，其优点是我们可以通过ThreadPoolExecutor.submit(Callable<T>)的返回值获取任务的处理结果；其缺点是Callable实例表示的异步任务只能交给线程池执行，而无法直接交给一个专门的工作者线程或者Executor实现类执行。

(3)java.util.concurrent.FutureTask类则融合了Runnable接口和Callable接口的优点：FutureTask是Runnable接口的一个实现类，因此FutureTask表示的异步任务可以交给专门的工作者线程执行，也可以交给Executor实例（比如线程池）执行；FutureTask还能够直接返回其代表的异步任务的处理结果。一个工作者线程（可以是线程池中的一个工作者线程）负责调用FutureTask.run()执行相应的任务，另外一个线程则调用FutureTask.get()来获取任务的执行结果。

(4) FutureTask还支持以回调（Callback）的方式处理任务的执行结果。当FutureTask实例所代表的任务执行结束后，FutureTask.done()会被执行[5]。FutureTask.done()是个protected方法，FutureTask子类可以覆盖该方法并在其中实现对任务执行结果的处理。FutureTask.done()中的代码可以通过FutureTask.get()调用来获取任务的执行结果，此时由于任务已经执行结束，因此FutureTask.get()调用并不会使得当前线程暂停。但是，由于任务的执行结束既包括正常终止，也包括异常终止以及任务被取消而导致的终止，因此FutureTask.done()方法中的代码可能需要在调用FutureTask.get()前调用FutureTask.isCancelled()来判断任务是否被取消，以免FutureTask.get()调用抛出CancellationException异常（运行时异常）。

(5) FutureTask基本上是被设计用来表示一次性执行的任务，其内部会维护一个表示任务运行状态（包括未开始运行、已经运行结束等）的状态变量，FutureTask.run()在执行任务处理逻辑前会先判断相应任务的运行状态，如果该任务已经被执行过，那么FutureTask.run()会直接返回（并不会抛出异常）。因此，FutureTask实例所代表的任务是无法被重复执行的。FutureTask.runAndReset()能够打破这种限制，使得一个FutureTask实例所代表的任务能够多次被执行。FutureTask.runAndReset()是一个protected方法，它能够执行FutureTask实例所代表的任务但是不记录任务的处理结果。因此，如果同一个对象所表示的任务需要被多次执行，并且我们需要对该任务每次的执行结果进行处理，那么FutureTask仍然是不适用的，

### 4. 可重复执行的异步任务：AsyncTask
AsyncTask抽象类同时实现了Runnable接口和Callable接口。AsyncTask子类通过覆盖call方法来实现其任务处理逻辑，而AsyncTask.run()则充当任务处理逻辑的执行入口。AsyncTask实例可以提交给Executor实例执行。当任务执行成功结束后，相应AsyncTask实例的onResult方法会被调用以处理任务的执行结果；当任务执行过程中抛出异常时，相应AsyncTask实例的onError方法会被调用以处理这个异常。AsyncTask的子类可以覆盖onResult方法、onError方法来对任务执行结果、任务执行过程中抛出的异常进行处理。由于AsyncTask在回调onResult、onError方法的时候不是直接调用而是通过向Executor实例executor提交一个任务进行的，因此AsyncTask的任务执行（即AsyncTask.run()调用）可以是在一个工作者线程中进行的，而对任务执行结果的处理则可以在另外一个线程中进行，这就从整体上实现了任务的执行与对任务执行结果的处理的并发：设asyncTask为一个任意AsyncTask实例，当一个线程在执行asyncTask.onResult方法处理asyncTask一次执行的执行结果时，另外一个工作者线程可能正在执行asyncTask.run()，即进行asyncTask的下一次执行。

### 5. 计划任务
在有些情况下，我们可能需要事先提交一个任务，这个任务并不是立即被执行的，而是要在指定的时间或者周期性地被执行，这种任务就被称为计划任务（ScheduledTask）。
ExecutorService接口的子类ScheduledExecutorService接口定义了一组方法用于执行计划任务。ScheduledExecutorService接口的默认实现类是java.util.concurrent.ScheduledThreadPoolExecutor类，它是ThreadPoolExecutor的一个子类。
```java
	public interface ScheduledExecutorService extends ExecutorService {

		/**
		 *  延迟执行提交的任务。
		 *	
		 * @param  command/callable 任务   
		 * @param delay     延迟多少时间
		 * @param unit      时间单位
  		 *
		 *  @return  返回结果,可以通过返回结果获取执行任务的结果，执行中抛出的异常  同时可以通过返回结果取消任务
		 */
		public ScheduledFuture<?> schedule(Runnable command, long delay, TimeUnit unit);
		public <V> ScheduledFuture<V> schedule(Callable<V> callable, long delay, TimeUnit unit);


		/**
		 * 周期性地执行提交的任务。
		 * 	
		 * @param command  任务
		 * @param initialDelay 多长时间后第一次执行
		 * @param period  每隔多少时间执行一次 (如果任务的执行时间为x, x > period, 那么任务的执行的周期将会不准确，有是为period, 又是大于 period)
		 * @param unit    时间单位
		 *
		 * @return  返回结果，可以通过返回结果，取消任务 但是它无法获取计划任务的一次或者多次的执行结果
		 */
		public ScheduledFuture<?> scheduleAtFixedRate(Runnable command, long initialDelay, long period, TimeUnit unit);

		/**
		 * 以一定的时间间隔
		 * 	
		 * @param command  任务
		 * @param initialDelay 多长时间后第一次执行
		 * @param delay   任务执行完成后，隔多长时间，在执行一次
		 * @param unit    时间单位
		 *
		 * @return  返回结果，可以通过返回结果，取消任务 但是它无法获取计划任务的一次或者多次的执行结果
		 */
		public ScheduledFuture<?> scheduleWithFixedDelay(Runnable command, long initialDelay, long delay, TimeUnit unit);
	}
```
(1)在周期执行中,直接使用Runnable实例，那么我们是无法获取执行结果的，这是可以通过AsyncTask实例代替Runnable实例，然后在AsyncTask的onResult()方法对输出结果进行处理。

(2)提交给ScheduledExecutorService执行的计划任务在其执行过程中如果抛出未捕获的异常（UncaughtException），那么该任务后续就不会再被执行。即使我们在创建ScheduledExecutorService实例的时候指定一个线程工厂，并使线程工厂为其创建的线程关联一个UncaughtExceptionHandler，当计划任务抛出未捕获异常的时候该UncaughtExceptionHandler也不会被ScheduledExecutorService实例调用。