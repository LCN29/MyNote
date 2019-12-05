#!/bin/sh
echo $1
if [ -z "$1" ]; then
    echo "没有输入需要kill的进程"
    echo "程序结束"
    exit	
fi

NAME=$1
echo "开始kill进程---> $NAME"
ID=`ps -ef | grep "$NAME" | grep -v "grep" | awk '{print $2}'`
echo -e "查询到的进程有------>\n$ID"
echo "开始kill进程-----> $NAME"
for id in $ID
do
    kill -9 $id
    echo "成功killed进程---> $id"
done
echo "kill进程结束"
