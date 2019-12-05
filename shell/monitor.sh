#!/bin/bash

################ Start Monitor CMD ################
# (/bin/bash ~/monitor.sh &);
###################################################

# Kill prev monitor exists
ps aux | grep "monitor.sh" |grep -v grep| grep -v $$| cut -c 10-15 | xargs -r kill -9;

cd ~;

while :;do

        resp=`curl --connect-timeout 1 -m 1  http://localhost:9200/`
        if [ "$resp" = "" ]; then

                echo "Hive ADX is Error, Restarting, Done time: "`date "+%Y-%m-%d %H:%M:%S" `
                echo "Hive ADX is Error, Restarting, Done time: "`date "+%Y-%m-%d %H:%M:%S" ` >> ~/monitor.log
                /bin/bash ~/restart.sh ;
                sleep 120
        else
                echo "Hive ADX is OK, Current time: "`date "+%Y-%m-%d %H:%M:%S" `
                echo "Hive ADX is OK, Current time: "`date "+%Y-%m-%d %H:%M:%S" ` >> ~/monitor.log
                sleep 10
        fi

done

