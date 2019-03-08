# Java内存模型

　　缓存一致性协议确保了一个处理器对某个内存地址进行的写操作的结果最终能够被其他处理器所读取。所谓“最终”就是带有不确定性,换而言之,即一个处理器对共享变量所做的更新具体在什么时候能够被其他处理器读取这一点,缓存一致性协议本身是不保证的。写缓冲器、无效化队列都可能导致一个处理器在某一时刻读取到共享变量的旧值。因此,从底层的角度来看,计算机系统必须解决这样一个问题——一个处理器对共享变量所做的更新在什么时候或者说什么情况下才能够被其他处理器所读取,即可见性问题。可见性问题又衍生出一个新的问题——一个处理器先后更新多个共享变量的情况下,其他处理器是以何种顺序读取到这些更新的,即有序性问题。


　　用于回答上述问题的模型就被称为内存一致性模型(MemoryConsistencyModel)也被称为内存模型（Memory Model)。不同的处理器架构有着不同的内存模型,因此这些处理器对有序性的保障程度各异,这表现为它们所支持的内存重排序不同。例如,x86处理器不支持StoreStore重排序)x86仅支持StoreLoad重排序),这就意味着写线程所执行的多个写操作在读线程看来其感知顺序与程序顺序一致。而ARM处理器则支持4种全部可能的重排序,因此一个处理器对另外一个处理器所执行的两个写操作的感知顺序可能与该处理器的程序顺序不一致。

　　Java作为一个跨平台(跨操作系统和硬件)的语言,为了屏蔽不同处理器的内存模型差异,以便Java应用开发人员不必根据不同的处理器编写不同的代码,它必须定义自己的内存模型,这个模型就被称为Java内存模型。Java内存模型(Java Memory Model, JMM)是Java语言规范(The Java Language Specification, JLS)的一部分,其定义了final、volatile和synchronized关键字的行为并确保正确同步(Correctly Synchronized)的Java程序能够正确地运行在不同架构的处理器之上。


#### happen(s)- before
换个角度来理解有序性这个概念——用可见性描述有序性:
| Processor1     		| Processor2 				  |
|  :-             		| :-         				  |
|  X = 1; // S1  		|            				  |
|  Y = 2; // S2  		|            				  |
|  Z = 3; // S3         |            				  |
|  Y = 1; // S2         |            				  |
|  ready = true; // S4  |            				  |
|  						|   r1 = ready; // L1         |
|  						|   r2 = X + Y; // L2         |
|   					|   r3 = Z; // L3             |

X、Y、Z和ready为共享变量，r1、r2和r3为局部变量。
假设Processor2读取到变量ready值时S1、S2、S3和S4的操作结果均已提交完毕，并且L2、L3不会与L1进行重排序, 那么此时S1、S2、S3和S4的操作结果对L1及其之后（程序顺序）的L2和L3来说都是可见的。因此，从L1、L2和L3的角度来看此时S1、S2、S3和S4就像是被Processor0上的线程依照程序顺序执行一样，即S1、S2、S3和S4对于L1、L2和L3来说是有序的。尽管实际上Processor1在执行S1、S2、S3和S4时可能进行指令重排序、内存重排序，但是只要在L1被执行的时候S1、S2、S3和S4的操作结果均已提交完毕，即这些操作的结果同时对L1可见，那么S1、S2、S3和S4在L1、L2和L3看来就是有序的。

　　happens-before就是采用上述这种从可见性角度出发去描述有序性的。Java内存模型定义了一些动作(Action)。这些动作包括变量的读/写、锁的申请(lock)与释放(unlock)以及线程的启动(Thread.start()调用)和加入(Thread.join()调用)等。 假设动作A和动作B之间存在happens-before关系(happens-before relationship), 称之为A happens-before B,那么Java内存模型保证A的操作结果对B可见,即A的操作结果会在B被执行前提交(比如写入高速缓存或者主内存)。happens-before关系具有传递性(Transitivity),即如果A happens-before B,并且B happens-before C,那么有A happens-before C (后续使用"→"这个符号来表示happens-before关系, 比如A→B表示动作Ahappens-before动作B)。

　　happens-before关系的传递性使得可见性保障具有累积的效果。 假设A、B、C和D四个动作之间存在这样的happens-before关系：A→B、B→C、C→D。 根据传递性, 我们还可以推导出这样的happens-before关系：A→D和B→D(当然, 还有A→C)。 对于D而言, 不仅仅C的结果对其可见, A的结果以及B的结果也都对D可见, 这就形成了可见性保障能够"累积"的效果, 

　　如果一组动作({A1,A2,A3})中的每个动作与另外一组动作({B1,B2,B3})中的任意一个动作都具有happens-before关系, 那么我们可以称前一组动作与后一组动作之间存在happen-before关系, 记为{A1,A2,A3}→{B1,B2,B3}。 
