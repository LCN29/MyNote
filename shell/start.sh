#!/bin/bash

#echo "开始启动"
#nohup java -jar $1 >/opt/project/log/web.log 2>&1 &
#echo "项目启动成功"

# 使用  ./start.sh 项目  环境

echo "项目启动中...."
nohup java -cp .:$1 org.springframework.boot.loader.JarLauncher --spring.profiles.active=$2 >/opt/project/log/web.log 2>&1 &
echo "启动命令行已执行"
