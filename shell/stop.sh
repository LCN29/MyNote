#!/bin/bash

echo "项目开始终止"

process=$1
pid=$(ps -ef | grep $process | grep 'java' | grep -v grep | awk '{print $2}')
echo $pid
kill -9 $pid
echo "项目终止结束"
