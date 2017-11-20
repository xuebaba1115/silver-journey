#!/bin/bash
if [ $(id -u) == "0" ];then
  echo -e "\033[1;40;31mError: You must be otheruser to run this script, please use otheruser to install this script.\033[0m"
  exit 1
fi
installbasic()
{
sudo apt-get install  aptitude curl -y >& /dev/null 
sudo aptitude install   openjdk-${1}-jdk g++ make libssl-dev libncurses5 libncurses5-dev unixodbc  unixodbc-dev libxml2-utils  xsltproc fop g++ -y
if [ $? -eq 0 ];then
     echo -e "\033[32mStep  basic  install ok\033[0m"
else
   echo -e "\033[31mApt install basic failly!!! \033[0m"
   exit 1
fi
}
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
  fi
}
installerlang()
{
  if [ $1 -eq 191 ];then
    sudo aptitude install libssl1.0-dev -y >& /dev/null 
    if [ $? -eq 0 ];then
       echo -e "\033[32mlibssl1.0 install ok\033[0m"
    else
      echo -e "\033[31mlibssl1.0 install  failly!!! \033[0m"
      exit 1
    fi
    kerl update releases  
      if [ $? -eq 0 ];then
        mkdir -p ~/.kerl/archives && cp -r ./erlang/*  ~/.kerl/archives && mkdir -p ~/ErlangVM/R191.hipe/
        if [ $? -eq 0 ];then
          KERL_CONFIGURE_OPTIONS=--enable-hipe kerl build 19.1 r191_hipe
          if [ $? -eq 0 ];then
            kerl install  r191_hipe ~/ErlangVM/R191.hipe
            if [ $? -eq 0 ];then
              if [ ! -f "/usr/local/bin/erl" ]; then
                sudo ln -s ~/ErlangVM/R191.hipe/bin/erl /usr/local/bin/
              else
                sudo rm -rf /usr/local/bin/erl
                sudo ln -s ~/ErlangVM/R191.hipe/bin/erl /usr/local/bin/
              fi              
              echo -e "\033[32mErlang R19.1 ok\033[0m"
              . ~/ErlangVM/R191.hipe/activate 
            else 
              echo -e "\033[31mErlang R191.0 failly!!! \033[0m"
              exit 1
            fi
          else 
            rm -rf ~/.kerl/builds/*
            echo -e "\033[31mErlang R19.1 failly,please reastart !!! \033[0m"
            exit 1
          fi
        fi
      fi
  elif [ $1 -eq 200 ];then  
    sudo aptitude install libssl-dev -y >& /dev/null 
    if [ $? -eq 0 ];then
       echo -e "\033[32mlibssl-dev install ok\033[0m"
    else
      echo -e "\033[31mlibssl-dev install  failly!!! \033[0m"
      exit 1
    fi
    kerl update releases  
      if [ $? -eq 0 ];then
        mkdir -p ~/.kerl/archives && cp -r ./erlang/*  ~/.kerl/archives  && mkdir -p ~/ErlangVM/R200.hipe/
        if [ $? -eq 0 ];then
          KERL_CONFIGURE_OPTIONS=--enable-hipe kerl build 20.0 r200_hipe
          if [ $? -eq 0 ];then
            kerl install  r200_hipe ~/ErlangVM/R200.hipe
            if [ $? -eq 0 ];then
              if [ ! -f "/usr/local/bin/erl" ]; then
                sudo ln -s ~/ErlangVM/R200.hipe/bin/erl /usr/local/bin/
              else
                sudo rm -rf /usr/local/bin/erl
                sudo ln -s ~/ErlangVM/R200.hipe/bin/erl /usr/local/bin/
              fi 
              . ~/ErlangVM/R200.hipe/activate 
              echo -e "\033[32mErlang R20.0 ok\033[0m"
            else 
              echo -e "\033[31mErlang R20.0 failly!!! \033[0m"
              exit 1
            fi
          else 
            rm -rf ~/.kerl/builds/*
            echo -e "\033[31mErlang R20.0 failly,please reastart !!! \033[0m"
            exit 1
          fi
        fi
      fi
  else
    echo -e "\033[31mPlease choose version!!! \033[0m"
    exit 1
  fi
}

main()
{
  read -p "Choose install ErlangR19.1 OR Erlang20.0.(input 191 or 200):" banben
  ver=$(cat /etc/debian_version | grep -Eo '^[0-9]')  >& /dev/null  
  if [ $ver -eq 9 ];then
    installbasic 8
  elif [ $ver -eq 8 ];then
    installbasic 7
  else
    echo -e "\033[31monly debian8 and debian9!!! \033[0m"
    exit 1
  fi
  installkerl
  installerlang $banben
}

main;