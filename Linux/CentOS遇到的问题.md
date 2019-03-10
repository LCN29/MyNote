# Linux - CentOS 遇到的问题
  
##### 001
文件名之间出现空格, 如sublime text.txt。进行处理时, 需要用单引号将其包起来, 作为一个整体进行处理 'sublime text.txt'
 

##### 002
建立符号链接时, 需要使用绝对路径, 不能使用相对路径

##### 003
使用  tar zxvf 文件.tar.gz 报了
```xml
  gzip: stdin: not in gzip format
  tar: Child returned status 1
  tar: Error is not recoverable: exiting now
```
这是因为这个文件不是用gzip格式压缩的，直接使用 `tar xvf 文件`就能解压了。
