#  TCP


### 包头结构
![Alt ‘Tcp包头结构’](https://github.com/LCN29/Picture-Repository/blob/master/MyNote/Network/tcp00.png?raw=true)
1. 原始端口,   16位, 范围当然是0-65535
2. 目的端口,  16位,  范围也是0-68835
3. 数据序号,  32位, TCP为发送的每个字节都编一个号码，这里存储当前数据包数据第一个字节的序号
4. 确认序号,  32位,  为了安全，TCP告诉接受者希望他下次接到数据包的第一个字节的序号
5. 偏移           4位,   表明数据距包头有多少个32位
6. 保留           6位,   未使用,应置零  
7. U(URG)       1位, URG= 1时，表明紧急指针字段有效。它告诉系统此报文段中有紧急数据，应尽快传送(相当于高优先级的数据)
8. A(ACK)        1位, 当ACK= 1,确认号字段才有效，当ACK＝0时，确认号无效。
9. P(PSH)         1位, 当PSH= 1, 接收端不将该数据进行队列处理，而是尽可能快将数据转由应用处理
10. R(RST)        1位, 当RST= 1, 表明TCP连接中出现严重差错（如由于主机崩溃或其他原因），必须释放连接，然后再重新 建立运输连接
11. S(SYN)        1位, 当SYN= 1, 这是一个连接请求或连接接受报文
12. F(FIN)         1位, 当FIN= 1, 表明此报文段的发送端的数据已发送完毕，并要求释放运输连接
13. 窗口字段   16位,  窗口字段用来控制对方发送的数据量，单位为字节
14. 包校验和   16位, 包括首部和数据这两部分。在计算检验和时，要在TCP报文段的前面加上12字节的伪首部
15. 紧急指针   16位, 紧急指针指出在本报文段中的紧急数据的最后一个字节的序号
16. 可选选项   24位, 可选选项
17. 填充            8位, 使选项凑足32位
18. 用户数据   




###  TCP三次握手

![Alt '图片'](https://github.com/LCN29/Picture-Repository/blob/master/MyNote/Network/tcp01.png?raw=true)

* 第一次握手
![Alt 图片](https://github.com/LCN29/Picture-Repository/blob/master/MyNote/Network/tcp02.png?raw=true)
客户端会发一个syn=1(连接请求)和数据序号(SeqNumber)=X(随机产生的数), 服务端收到Syn=1, 知道有客户端需要建立连接


* 第二次握手
![Alt 图片](https://github.com/LCN29/Picture-Repository/blob/master/MyNote/Network/tcp03.png?raw=true)
服务端发回确认包(ACK)应答, ack=1, syn = 1, 同时数据序号=Y(随机产生的数), 接收顺序号=客户端发起连接的序列化号X + 1


* 第三次握手
![Alt 图片](https://github.com/LCN29/Picture-Repository/blob/master/MyNote/Network/tcp04.png?raw=true)
客户端再次发送确认包(ACK) 应答, ack=1, syn=0,确认序号=服务端发送过来的数据序号Y + 1,同时在发送的数据里面添加X+1


### TCP四次挥手

![Alt '图片'](https://github.com/LCN29/Picture-Repository/blob/master/MyNote/Network/tcp05.jpg?raw=true)

* 第一次挥手
当client所要发送的数据发送完毕之后（这里是接收到了来自于server方的，对于clien发送的最后一个数据包的收到确认ACK包之后），向server请求关闭连接，因此client向server发送一个FIN数据包，表明client数据发送完了，申请断开, 并且自身进入等待结束连接状态FIN_WAIT-1


* 第二次挥手
当server收到了来自client的FIN请求包之后，向client回复一个确认报文ACK，同时进入关闭等待状态（CLOSE -WAIT），这时TCP连接的server便会向上层应用发送通知，表明client数据发送完毕，是否需要发送数据给client，这时TCP连接已经处于半关闭状态了，因为client已经没有数据要发送了。同时client收到了来自server的确认报文之后，便会进入FIN-WAIT-2状态。 


* 第三次挥手
TCP连接的server收到上层应用的指令表明没有数据要发送之后，会向client发送一个FIN请求数据包，其中确认位ACK=1，表明响应client的关闭连接请求，同时FIN=1表明server也准备好断开TCP连接了


* 第四次挥手
client收到了来自server的FIN数据包之后，知道server已经准备好断开连接了，于是向server发送一个确认数据包ACK，告诉server，可以关闭资源断开连接了。同时自身进入TIME-WAIT阶段，这个阶段将持续2MSL（MSL：报文在网络链路中的最长生命时长），在等待2MSL之后，client将会关闭资源。


 * 最后
 server收到了来自于client的最后一个确认断开连接数据包之后便会直接进入TCP关闭状态，进行资源的回收


