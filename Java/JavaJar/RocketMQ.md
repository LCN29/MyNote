# RocketMQ

## Maven依赖
```xml
<dependency>
    <groupId>com.alibaba.rocketmq</groupId>
    <artifactId>rocketmq-client</artifactId>
    <version>3.6.2.Final</version>
</dependency>
```

## 新的依赖
```xml
<dependency>
    <groupId>org.apache.rocketmq</groupId>
    <artifactId>rocketmq-client</artifactId>
    <version>4.2.0</version>
</dependency>
```

## 使用

### 1，需要先开启服务,需要先开启服务

### 2，消费者

```java
	/**
	 * 一个应用创建一个Consumer，由应用来维护此对象，可以设置为全局对象或者单例
	 * 注意：ConsumerGroupName需要由应用来保证唯一
	 */
	DefaultMQPushConsumer consumer = new DefaultMQPushConsumer("ConsumerGroupName");

	/**
	 *监听这个地址，服务端有消息时，会发送到这里来
	 */
	consumer.setNamesrvAddr("127.0.0.1:9876");

	consumer.setInstanceName("Consumber");

	/**
     * 订阅"TopicTest1" topic下的TagA或TagC tag
     */
	consumer.subscribe("TopicTest1","TagA || TagC");

	/**
     * 订阅指定topic下所有消息
     * 注意：一个consumer对象可以订阅多个topic
     */
	consumer.subscribe("TopicTest2","*");

	/** 向注册监听队列，但有消息来时，进行处理 */
	consumer.registerMessageListener(new MessageListenerConcurrently() {

		@Override
        public ConsumeConcurrentlyStatus consumeMessage(List<MessageExt> msgs, ConsumeConcurrentlyContext context) {

        	 System.out.println("当前线程的名字:"+Thread.currentThread().getName() +"收到消息的长度" + msgs.size());
        	 MessageExt msg = msgs.get(0);

        	 if(msg.getTopic().equals("TopicTest1")) {

        	 	if(msg.getTags() != null && msg.getTags().equals("TagA")) {
                    //执行TagA的消费
                    System.out.println(new String(msg.getBody()));
                }

                if(msg.getTags() != null && msg.getTags().equals("TagC")) {
                    //执行TagC的消费
                    System.out.println(new String(msg.getBody()));
                }
        	 }else if (msg.getTopic().equals("TopicTest2")) {
                System.out.println("收到了TopicTest2的消息");
                System.out.println(new String(msg.getBody()));
             }

             return ConsumeConcurrentlyStatus.CONSUME_SUCCESS;
        }

	});

	/**
     * Consumer对象在使用之前必须要调用start初始化，初始化一次即可
     */
	consumer.start();
	System.out.println("Consumer 开启成功");

```

### 3, 生产者

```java

	/**
     * 一个应用创建一个Producer，由应用来维护此对象，可以设置为全局对象或者单例<br>
     * 注意：ProducerGroupName需要由应用来保证唯一<br>
     * ProducerGroup这个概念发送普通的消息时，作用不大，但是发送分布式事务消息时，比较关键，
     * 因为服务器会回查这个Group下的任意一个Producer
     */
	DefaultMQProducer producer = new DefaultMQProducer("ProducerGroupName");
	producer.setNamesrvAddr("127.0.0.1:9876");
    producer.setInstanceName("Producer");

	/**
	 * Producer对象在使用之前必须要调用start初始化，初始化一次即可
	 * 注意：切记不可以在每次发送消息时，都调用start方法
	 */
	producer.start();

	Message msg = new Message();
	try { 
		msg.setTopic("TopicTest1");
	    msg.setTags("TagA");
	    msg.setKeys("OrderID061");
	    msg.setBody("我是tagA的消息".getBytes());
		SendResult sendResult = producer.send(msg);
		System.out.println(sendResult);

		TimeUnit.MILLISECONDS.sleep(1000);

		msg.setTopic("TopicTest2");
	    msg.setTags("TagA");
	    msg.setKeys("OrderID065");
	    msg.setBody("我是TopicTest2的消息".getBytes());
	    SendResult sendResult = producer.send(msg);
	    System.out.println(sendResult);

	} catch(Exception e) {
		e.printStackTrace();
	}

	/**
     * 应用退出时，要调用shutdown来清理资源，关闭网络连接，从MetaQ服务器上注销自己
     * 注意：建议应用在JBOSS、Tomcat等容器的退出钩子里调用shutdown方法
     */
	Runtime.getRuntime().addShutdownHook( new Thread() {
	    @Override
	    public void run() {
	        producer.shutdown();
	    }
	});

	System.exit(0);
	
```

### RocketMQ实际的部署情况
