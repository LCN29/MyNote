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
	     // 代表这条消息的业务关键词，服务器会根据 keys 创建哈希索引,后面可以通过这个key查询这条信息
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
![Alt '图片'](https://github.com/LCN29/Picture-Repository/blob/master/MyNote/Java/JavaJar/RocketMq/RocketMq-deploy.png?raw=true)

> 1. Name Server是一个几乎无状态节点，可集群部署，节点之间无任何信息同步
> 2. Broker部署相对复杂，Broker分为Master与Slave，一个Master可以对应多个Slave，但是一个Slave只能对应一个Master，Master与Slave的对应关系通过指定相同的BrokerName，不同的BrokerId来定义，BrokerId为0表示Master，非0表示Slave。Master也可以部署多个。每个Broker与NameServer集群中的所有节点建立长连接，定时注册Topic信息到所有Name Server。
> 3. Producer与Name Server集群中的其中一个节点（随机选择）建立长连接，定期从NameServer取Topic路由信息，并向提供Topic服务的Master建立长连接，且定时向Master发送心跳。Producer完全无状态，可集群部署。
> 4. Consumer与Name Server集群中的其中一个节点（随机选择）建立长连接，定期从Name Server取Topic路由信息，并向提供Topic服务的Master、Slave建立长连接，且定时向Master、Slave发送心跳。Consumer既可以从Master订阅消息，也可以从Slave订阅消息，订阅规则由Broker配置决定


### 消息类型

#### 普通消息
普通消息也叫做无序消息，简单来说就是没有顺序的消息，producer只管发送消息，consumer只管接收消息，至于消息和消息之间的顺序并没有保证，可能先发送的消息先消费，也可能先发送的消息后消费。因为不需要保证消息的顺序，所以消息可以大规模并发地发送和消费，吞吐量很高，适合大部分场景

#### 有序消息
有序消息就是按照一定的先后顺序的消息类型。消息首先由producer到broker，再从broker到consumer，这个过程如果保证了他们的顺序，那么消息也就能有序了。

> 1. 全局有序消息
>> topic 只是消息的逻辑分类，内部实现其实是由queue组成。当producer把消息发送到某个topic时，默认是会消息发送到具体的queue上。举个例子，producer 发送 order id 为 1、2、3、4 的四条消息到 topicA 上，假设 topicA 的 queue 数为 3 个（queue0、queue1、queue2），那么消息的分布可能就是这种情况，id 为 1 的在 queue0，id 为 2 的在 queue1，id 为 3 的在 queue2，id 为 4 的在 queue0。同样的consumer消费时也是按queue去消费，这时候就可能出现先消费1、4，再消费2、3，和我们的预期不符。这时只需要把订单topic的queue数改为1，如此一来，只要producer按照 1、2、3、4 的顺序去发送消息，那么 consumer 自然也就按照 1、2、3、4 的顺序去消费，这就是全局有序消息。由于一个 topic 只有一个 queue ，即使我们有多个 producer 实例和 consumer 实例也很难提高消息吞吐量，效率低下

> 2. 局部有序消息
>> 给这些需要按顺序处理的消息加上一个唯一的id，如订单的订单创建、订单付款、订单完成等消息，这些消息都有相同的order id，我们完全可以将相同id的消息发送到同一个topic 的同一个queue上。然后把不同的order id的消息发送到不同的topic的queue上。

#### 延时消息
简单来说就是当 producer 将消息发送到 broker 后，会延时一定时间后才投递给consumer进行消费RcoketMQ的延时等级为：1s，5s，10s，30s，1m，2m，3m，4m，5m，6m，7m，8m，9m，10m，20m，30m，1h，2h。level=0，表示不延时。level=1，表示 1 级延时，对应延时 1s。level=2 表示 2 级延时，对应5s，以此类推
