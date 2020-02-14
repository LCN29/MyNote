# CentOS7安装MySql

## 一，从[官网](https://dev.mysql.com/downloads)下载想要的版本,并上传到服务器

## 二，创建mysql存放资源，日志的目录
>1. `cd /var`
>2. `mkdir mysql`
>3. `cd mysql`
>4. `mkdir data log lock`
(我把mysql的数据库文件和日志文件都存放到了/var/mysql下，程序的的安装选择了/opt)

## 三, 将文件转移到/opt，并重名为mysql-5.7.22
>1. `mv mysql-5.7.22-linux-glibc2.12-x86_64.tar.gz /opt`
>2. `tar zxvf mysql-5.7.22-linux-glibc2.12-x86_64.tar.gz`
>3. `mv mysql-5.7.22-linux-glibc2.12-x86_64 mysql-5.7.22`

## 四，新建mysql用户、组及目录
>1. `groupadd mysql`
>2. `useradd -r -g mysql mysql`

## 五, 改变目录属有者
>1. `cd /opt/mysql-5.7.22`
>2. `chown -R mysql .`
>3. `chgrp -R mysql .`

## 六, 删除系统自带的MariaDB数据库
>1. `rpm -qa | grep mariadb`  (有日志打印，说明安装了)
>2. `yum -y remove mari*`
>3. `rm -rf /var/lib/mysql/*`

## 七，安装libaio
>1. `yum install -y libaio`

## 八, 进行安装
>1. `bin/mysqld --initialize --user=mysql --basedir=/opt/mysql-5.7.22 --datadir=/var/mysql/data`
>2. 这时，在最后一行，有一个临时的登录密码，保存他，后面需要用他来登录

## 九，配置启动脚本
>1. `cd /opt/mysql-5.7.22/support-files`
>2. `cp mysql.server /etc/init.d/mysql`
>3. `cd /etc/init.d`
>4. `vim /etc/init.d/mysql`
>>1. `basedir=/opt/mysql-5.7.22`
>>2. `datadir=/var/mysql/data`
>>3. `lockdir='/var/mysql/lock/subsys'`
>>4. `把里面的/usr/local/mysql/data 全部替换为/var/mysql/data`
>>5. `把里面的/usr/local/mysql全部替换为/opt/mysql-5.7.22`

## 十，启动mysql
>1. `service mysql start`
>2. `cd /opt/mysql-5.7.22`
>3. `bin/mysql -hlocalhost -uroot -p`
>4. `输入刚刚的临时密码`
>5. `ALTER USER 'root'@'localhost' IDENTIFIED BY '你的密码';`
>6. `grant all privileges on *.* to 'root'@'%' identified by '你的密码';`
>7. `flush privileges;`

eg:
在 Mysql 8.0 以上给root 赋予 远程连接的权限的方式改变了
>1. `CREATE USER 'root'@'%' IDENTIFIED BY '你的密码';`
>2. `GRANT ALL ON *.* TO 'root'@'%';`
>3. `ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY '你的密码';`
>4. `FLUSH PRIVILEGES;`


## 十一，开启端口
>1. `firewall-cmd --zone=public --add-port=3306/tcp --permanent`
>2. `firewall-cmd --reload`
