# CentOS7安装Redis

# 一,安装gcc环境
>1. `yum install gcc-c++`
>2.  中途会有一个选择提示,输入`y`确定就行了。

# 二,从Redis的官网(https://redis.io/)下载Redis的安装包，上传到服务器

# 三,解压安装包并安装
>1. `tar zxf redis-4.0.9.tar.gz`
>2. `cd redis-4.0.9`
>3. `make`
>4. `make install` (这样会把redis安装到/usr/local/bin里面，如果想要修改安装路径,需要指定安装路径一样了，, 因为解压出来的文件名和我想要的目录名一致了，所以我先把redis-4.0.9重命名了，`mv redis-4.0.9 redis`---> `cd redis` ---> `make` ---> `make PREFIX=/opt/redis-4.0.9 install`)
>5. `cd /opt/redis-4.0.9/bin`
>6. `redis-server` (如果出现了Redis的标志，说明redis安装成功了)
>7. `ctrl+C` (退出redis服务)

# 四,通过脚本运行Redis
>1. `cd /opt/redis/utils` (redis的安装包里面的utils里面有个redis_init_script文件，可以通过这个脚本进行配置redis)
>2. `cp redis_init_script /etc/init.d` (将redis_init_script脚本拷贝到 /etc/init.d)
>3. `cd /etc/init.d`
>4. `mv redis_init_script redis_6379`(为了好看，把脚本重命名为redis_打算开放的端口,你也可以直接将其命名为redis,但是有个端口号，方面以后开发环境的维护)
>5. `cd /var` (日志什么的，通常放到/var文件夹里面)
>6. `mkdir redis`
>7. `cd redis`
>8. `mkdir data log run`
>9. `cd /etc`
>10. `mkdir redis` (在/etc下面创建redis文件夹)
>11. `cd /opt/redis`
>12. `cp redis.conf /etc/redis` （将reids安装包里面的redis.conf配置文件拷贝到/etc/reids里面）
>13. `vim redis.conf` (编辑redis.conf文件，修改成自己想要的配置)
>>1. 修改端口
```shell
# Accept connections on the specified port, default is 6379 (IANA #815344).
# If port 0 is specified Redis will not listen on a TCP socket.
port 6379
# 此处没有修改使用默认值
```
>>2. 让redis后台运行
```shell
# By default Redis does not run as a daemon. Use 'yes' if you need it.
# Note that Redis will write a pid file in /var/run/redis.pid when daemonized.
daemonize yes
#将no改为yes
```
>>3. 修改dump目录
```shell
# The Append Only File will also be created inside this directory.
#
# Note that you must specify a directory here, not a file name.
dir /var/redis/data
# 将 ./改为/var/redis/data
```
>>4. 修改Redis的PID文件
```shell
# Creating a pid file is best effort: if Redis is not able to create it
# nothing bad happens, the server will start and run normally.
pidfile /var/redis/run/redis_6379.pid
# /var/run/redis_6379.pid 改为
```
>>5. 修改log存储目录
```shell
# Specify the log file name. Also the empty string can be used to force
# Redis to log on the standard output. Note that if you use standard
# output for logging but daemonize, logs will be sent to /dev/null
logfile /var/reids/log/redis_6379.log
# ""改为 /var/redis/log/redis_6379.log
```
>>6. 设置外网可以访问
```shell
# IF YOU ARE SURE YOU WANT YOUR INSTANCE TO LISTEN TO ALL THE INTERFACES
# JUST COMMENT THE FOLLOWING LINE.
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# bind 127.0.0.1
# 将bind 127.0.0.1 注释掉

# 此处省略若干行

# even if no authentication is configured, nor a specific set of interfaces
# are explicitly listed using the "bind" directive.
protected-mode no

#将 yes改为no
```
>>7. 给你的redis设置密码(可选操作)
```shell
# use a very strong password otherwise it will be very easy to break.
#
requirepass 你的密码
# 将#requirepass foobared的注释去掉，将后面的foobared改为你的密码
```
>14. `mv redis redis_6379` （重命名配置文件）
>15. `cd /etc/init.d`
>16. `vim redis_6379` (编辑脚本文件)
```shell

REDISPORT=6379 (你的配置文件里面的端口)
EXEC=/opt/redis-4.0.9/bin/redis-server(你的redis的安装目录/bin/redis-server，如果你一，开始安装时，make install 没有指定前缀PREFIX，保持默认)
CLIEXEC=/opt/redis-4.0.9/bin/redis-cli(你的redis的安装目录/bin/redis-cli，如果你一开始安装时，make install 没有指定前缀PREFIX，保持默认)

PIDFILE=PIDFILE=/var/redis/run/redis_${REDISPORT}.pid
CONF="/etc/redis/redis_${REDISPORT}.conf"

# 此时省略若干行

$CLIEXEC -a "你的redis密码" -p $REDISPORT shutdown(在中间添加 -a "你的密码",如果你没有设置密码的话，跳过)
```
>17. `./redis_6379 start` （当前在/etc/init.d目录里面）显示`Starting Redis server...`说明服务启动成功
>18. `./redis_6379 stop`  关闭服务

# 五,设置开机自启
> `vim /etc/init.d/redis_6379` 在文件头部第四行的位置(Simple的下面)，追加下面两句
```shell
# chkconfig: 2345 90 10
# description: Redis is a persistent key-value database
```
> `chkconfig redis_6379 on` 将Redis加入系统启动项
>3. 后面就可以通过`service redis_6379 start`和`service redis_6379 start`启动redis服务了

# 六,开启端口
>1. `firewall-cmd --permanent --zone=public --add-port=6379/tcp`
>2. `firewall-cmd --reload`
