#!/bin/bash
cd /home/verticle

jar_file="verticle-1.0-SNAPSHOT-fat.jar"
log_file="engine.log"

# find the pid

echo "启动 verticle ..."
echo "检查已存在的进程 ..."

jps |grep ${jar_file} |grep -v "grep" |awk '{print $1}'
verticle_pid=`jps |grep ${jar_file} |grep -v "grep" |awk '{print $1}'`
echo -e "verticle pid :${verticle_pid}"

# 存在则杀掉进程
if [ -z "${verticle_pid}" ] ; then
    echo "目标 verticle 进程不存在，直接启动"
else
    echo "目标 verticle 进程PID=${verticle_pid}"
    kill -9 ${verticle_pid}
    echo "PID ${verticle_pid} 已被执行kill"
    echo "休眠3s ..."
    sleep 3s
fi

echo "执行启动 nohup java -jar ${jar_file} > ${log_file} 2>&1 &"

#nohup  java -Xdebug -Xrunjdwp:transport=dt_socket,address=0.0.0.0:8086,server=y,suspend=n -jar ${jar_file} > ${log_file} 2>&1 &

nohup java -jar ${jar_file} > ${log_file} 2>&1 &

echo "启动成功 日志文件在 ${log_file}"
