#!/bin/bash

te()
{
  echo ${1}
}

ver=$(cat /etc/debian_version | grep -Eo '^[0-9]')  >& /dev/null  
echo $ver

if [ $ver -eq 9 ];then
  te 123

fi



installkerl()
{ 
  if [ ! -f "/usr/local/bin/kerl" ]; then
    sudo curl -o /usr/local/bin/kerl https://raw.githubusercontent.com/kerl/kerl/master/kerl && sudo chmod a+x /usr/local/bin/kerl
    if [ $? -eq 0 ];then
     echo -e "\033[32mStep  kerl install ok\033[0m"
    else
      echo -e "\033[31mKerl install  failly!!! \033[0m"
      exit 1
    fi
  else
    echo "already"
  fi
}
installkerl