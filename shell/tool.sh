
# git
git_tool() {

  case "$1" in
    'name')
      name='';
      if  [ ! -n "$2" ] ;then
          name='canxin.li';
      else
          name=$2;
      fi
      git config user.name $name;
      echo "Git 本地仓库用户名为 $name 设置成功"
    ;;

    'delete')
      if  [ -n "$2" ] ;then
        echo "开始删除仓库的分支 $2 ....";
        git checkout master;
        git checkout -d $2;
        git checkout master;
        git push origin --delete $2;
        git pull; 
        echo "删除仓库分支 $2 成功";
      else 
          echo "没有输入要删除的分支名, 不做任何处理";
      fi
    ;;
  esac;

}

# sharding db
sharding_db_tool() {

  case "$1" in
    'dev')
      cd D:/Sharding-Proxy-4.0.1/Sharding-Proxy-4.0.1-dev/bin/;
      ./start.bat ;
    ;;

    'test')
      cd D:/Sharding-Proxy-4.0.1/Sharding-Proxy-4.0.1-test/bin/;
      ./start.bat 3308;
    ;;
  esac;
}

# 浏览器
browser_tool() {
  case "$1" in
    'json')
      'C:/Program Files (x86)/Google/Chrome/Application/chrome.exe' 'C:\Users\Administrator\shell\html.html';
    ;;
  esac;
}


echo "当前输入的命令函数 $1";

case "$1" in
  # git 操作
  'git')
    git_tool $2 $3;
  ;;
  # sharding db 操作
  'db')
    sharding_db_tool $2;
  ;;
  # 浏览器操作
  'browser')
    browser_tool $2;
  ;;
  *)
	 echo "unknow command";
   echo "current suport command:  git   db   browser";
  ;;
esac  