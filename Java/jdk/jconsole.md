# jconsole (JAVA_HOME/bin/jconsole.exe)

# 查看当前程序的情况(排查死锁)
>1. 在项目的启动参数里面添加 `-Dcom.sun.management.jmxremote`
>2. 选择你的程序,进行连接(不安全连接)
>3. 顶部的tab栏选择线程
>4. 左下角，有个检测死锁，点击后，可以排查死锁情况, 结果：
```

	名称: threadA1
	状态: java.lang.Class@57371486上的BLOCKED, 拥有者: threadB2
	总阻止数: 2, 总等待数: 0

	堆栈跟踪: 
	com.can.lockUse.B.fnB2(B.java:21)
	com.can.lockUse.A.fnA1(A.java:15)
	   - 已锁定 java.lang.Class@2ac74f7f
	com.can.lockUse.LockCondition$1.run(LockCondition.java:23)
	java.lang.Thread.run(Unknown Source)



	名称: threadB2
	状态: java.lang.Class@2ac74f7f上的BLOCKED, 拥有者: threadA1
	总阻止数: 2, 总等待数: 0

	堆栈跟踪: 
	com.can.lockUse.A.fnA2(A.java:21)
	com.can.lockUse.B.fnB1(B.java:15)
	   - 已锁定 java.lang.Class@57371486
	com.can.lockUse.LockCondition$2.run(LockCondition.java:30)
	java.lang.Thread.run(Unknown Source)
```
threadA1 处于Blokced状态，他需要锁java.lang.Class@57371486， 但是被threadB1拥有者
threadB1 处于Blokced状态，他需要锁java.lang.Class@2ac74f7f， 但是被threadA1拥有者