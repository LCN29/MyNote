# CentOS7安装Tomcat

# 一，软件下载
>1. 到官网(https://tomcat.apache.org/) 下载想要的Tomcat版本，上传到服务器

# 二，解压安装包
>1. `tar zxf apache-tomcat-8.0.53.tar.gz`
>2. `mv apache-tomcat-8.0.53 tomcat-8.0.53`

# 三，修改Tomcat的端口(如果需要的话)
>1. `cd tomcat-8.0.53/conf`
>2. `vim server.xml`
```shell
# 原来的样子
<Connector port="8080" protocol="HTTP/1.1"
           connectionTimeout="20000"
           redirectPort="8443" />

# 将下面的port 修改成想要的
<Connector port="80" protocol="HTTP/1.1"
           connectionTimeout="20000"
           redirectPort="8443" />           
```

# 四，根据修改的端口，开启防火墙
>1. `firewall-cmd --zone=public --add-port=你的端口/tcp --permanent`
>2. `firewall-cmd --reload`

# 五，安装JDK

# 六，如果不想访问Tomcat的时候，出现默认的猫的话，可以将tomcat-8.0.53/webapps/ROOT里面的文件删除
>1. `cd tomcat-8.0.53/webapps/ROOT`
>2. `rm -rf *`

# 七，将你的项目放到ROOT目录里面

# 八，开启项目
>1. `cd tomcat-8.0.53/bin`
>2. `./startup.sh`

# 九，关闭项目
>1. `./shutdown.sh`

# 十，根据需要进行配置，路径映射(将本地的磁盘和url进行映射，如将本地的/opt/project/imgs映射为 url的/imgs)
>1. `cd tomcat-8.0.53/conf`
>2. `vim server.xml`
```shell
<Host name="localhost"  appBase="webapps" unpackWARs="true" autoDeploy="true">
     #在host标签里面添加这个
     <Context path="/imgs" docBase="/opt/project/imgs" debug="0" reloadable="true" />
</Host>
```
