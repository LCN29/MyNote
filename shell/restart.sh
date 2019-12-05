#!/bin/bash
ID=`ps -ef | grep "nadx-exchange" | grep -v "$0" | grep -v "grep" | awk '{print $2}'`
echo $ID
echo "---------------"
for id in $ID
do
kill -9 $id
echo "killed $id"
done
echo "---------------"
nohup  java  -Xms2048m -Xmx10240m -jar /opt/nadx/nadx-exchange/libs/nadx-exchange.jar -conf /opt/nadx/nadx-exchange/conf/nadx-exchange.json > /dev/null  2>&1 &
