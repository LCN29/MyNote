# Docker 安装

>1. 更新yum源 `yum update`

>2. 获取安装脚本 `curl -fsSL https://get.docker.com -o get-docker.sh`

>3. 执行安装脚本 `sh get-docker.sh`

>4. 启动docker `systemctl start docker`



# 配置 Docker 可以远程访问
>1. `vim /lib/systemd/system/docker.service`

>2. 修改以ExecStart开头的行为:
`ExecStart=/usr/bin/dockerd -H tcp://0.0.0.0:你打算开放的端口 -H unix://var/run/docker.sock`

>3. 通知docker服务做出的修改
`systemctl daemon-reload`

>4. 重启docker服务
`service docker restart`

>5. 判断是否成功
`curl http://localhost:你的端口/info`
如果打印了需要docker信息就是成功了