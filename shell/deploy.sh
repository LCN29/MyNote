#!/bin/bash -e
#pull
if [[ ${1} == "-p" ]]; then
    git pull
fi
#package
mvn clean package -Dmaven.test.skip=true -P dev
# definition var
jar_file="verticle-1.0-SNAPSHOT-fat.jar"
remote_ip=47.106.39.79
identity_file="~/.ssh/id_rsa"
cd verticle/target
# copy to remote
scp -i ${identity_file} ${jar_file} root@${remote_ip}:/home/verticle
# exec restart.sh
ssh -i ${identity_file} root@${remote_ip} "cd /home/verticle; /bin/bash restart.sh"

now=`date +"%Y-%m-%d %H:%M:%S"`
echo ${now}