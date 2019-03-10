# JDK的安装

## 一,下载JDK
从官网上(http://www.oracle.com/technetwork/java/javase/downloads/index.html)下载JDK,并上传到服务器

## 二，安装
>1. `mv jdk-8u162-linux-x64.tar.gz /opt`
>2. `tar zxf jdk-8u162-linux-x64.tar.gz`

## 三,设置环境变量
>1. `vim /etc/profile` 在尾部添加以下内容
```Shell
# jdk
export JAVA_HOME=/opt/jdk1.8.0_162(根据你的jdk具体填写)
export JRE_HOME=$JAVA_HOME/jre
export CLASSPATH=:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar:$JRE_HOME/lib/dt.jar

PATH=.:$PATH:$JAVA_HOME/bin:$JRE_HOME/bin
export PATH
```

## 四,让配置生效
`source /etc/profile`

## 五,验证jdk的安装情况
依次输入`java -version`和`javac -version` 都能显示版本，既安装成功
