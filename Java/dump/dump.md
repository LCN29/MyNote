

# 设置当程序出现内存溢出时,生成dump文件
启动命令行添加参数：  
-XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/root（生成文件的路径）


# 立即生成dump文件
jmap -dump:format=b,file=文件名.hprof 进程Id


# 将生成的hprof文件导入到mat(https://www.eclipse.org/mat/downloads.php)



