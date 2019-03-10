# ZooKeeper的安装

## 一,从官网(http://mirror.bit.edu.cn/apache/zookeeper/)下载zookeeper的安装包,并上传到服务器

## 二,配置
>1. `mv zookeeper-3.5.3-beta.tar.gz /opt`
>2. `tar xf zookeeper-3.5.3-beta.tar.gz`
>3. `cd zookeeper-3.5.3-beta`
>4. `mkdir data logs`
>5. `cd conf`
>6. `cp zoo_sample.cfg zoo.cfg`
>7. `vim zoo.cfg` 修改如下内容
```shell
dataDir=/opt/zookeeper-3.5.3-beta/data
dataLogDir=/opt/zookeeper-3.5.3-beta/logs

clientPort=2181
server.1=服务器IP:2888:3888
```
>8. `cd /opt/zookeeper-3.5.3-beta/data`
>9. `touch myid`(创建一个myid文件)
>10. `vim myid`,添加内容
```Shell
1
```

## 三,配置环境变量
> `vim /etc/profile` 添加如下内容
```shell
# zookeeper
export ZOOKEEPER_HOME=/opt/zookeeper-3.5.3-beta

PATH=.:$PATH:$ZOOKEEPER_HOME/bin
export PATH
```
> `source /etc/profile`

## 四,验证
>1. `zkServer.sh start` 开启
>2. `zkServer.sh status` 查看状态
>3. `zkServer.sh stop` 关闭

## 五,配置开启自启
>1. `chmod +x /etc/rc.d/rc.local`
>2. `su -root -c '/opt/zookeeper-3.5.3-beta/bin/zkServer.sh start'`

## 六,开启端口
>1. `firewall-cmd --permanent --zone=public --add-port=2181/tcp`
>2. `firewall-cmd --permanent --zone=public --add-port=2888/tcp`
>3. `firewall-cmd --permanent --zone=public --add-port=3888/tcp`
>4. `firewall-cmd --reload`
