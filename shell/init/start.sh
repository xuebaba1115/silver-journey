#!/bin/bash
#check user
if [ $(id -u) != "0" ];then
  echo -e "\033[1;40;31mError: You must be root to run this script, please use root to install this script.\033[0m"
  exit 1
fi
read -p "setting  hostname:" hname
read -p "setting project name:" pro
ops="$pro-ops"
admin="$pro-admin"
userlist=($ops $admin)
mm='ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDHSUsX//rmvw6Wrd7yfo08NFWXTffWcc2+F50+RlYRefP6SVsSK2558Nh3u+b0RMlB07dP7l7p8vbIU+I4FawkJfteoxDAwoyfud2TcB6f1TiRnhi1bnwTscLeHS/sLu0/ValHgSCndHHrDZPaKI+dLOUztDexDM4Vnf9FkAtQ1xuQx2naEySDIriJE33yRnwhiPXds+mscNyB04uKlLZzbORosyjWc8OIy6P6ToWn5MIQFM5FWbLS1O0zXcUlPP5TTW9p5Nr6gijI2QZ2UKNlhS3S2Xqpl12Ey8yt7J6dAHDL8p5QdiuRVQELDJ5GcBvl+MxwG0XQ4na9aL+5jpu1 xuelc@debian
ssh-dss AAAAB3NzaC1kc3MAAACBANv5JJC3Nap60mxMI6DtBzZSE/zy6HC9ZXYjlcTM/xjQIwQDK92agl38NDAojHsyZaoz0XZY5/qInaKRGSf0zKYhNw1u4Ar4SlftUTQA1JSoDOUP0O6/GfxOrMDctWnsz1IL28RHOTSJL7gC4xsO368Nyjsd8OoJN4mfXS485//pAAAAFQCrIZhzkMVifSo/+QZOlOcTWpy0lQAAAIEAyh0Zg0polLYyRVztnUbk5gsym+hJeX91sviox/hmOC4f3me/hS00oNiRbwJA9gs4s2iOn7Gap9pl2vLlaG8Z3T4hN3N/jKBFOpoyfwMwNcW0es40SOdlP0QJXPNq4VSv9ofMm80rqkSfuEI0y3gKA3Q02evOBuUUfPGTuogupwMAAACAcXKOfCGbYrczS2rOLLVM4BIR9RdIwY6iEODUOrzKhOSZWPkzB4Mg4X63g8fJ5E6w5lpJuu2s9hmg3lq+gpFm9Py6S1bV7S0BblIqFB0lfUgmYyPLjDivIeYnVVcA7b5OgUaSo9F+rkZDcn2SwXEGj0etdcytkOpKgk8As9DpSkI= slepher@pheric-laptop
ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAseKa1XKffogqB19F403NAOHotIcrtqz78FzLDpWFhMczSwyNRCGZMDEXWuqeY+4ctC/zKr/rL5EM+pwvvdvQFSb6viGoFHJgeVYUZsYDFYp9B00bgyykLUkqBHvMJN3Eu86OWoYD4flQTIIIlfOOgFYJbTsIXxb6dUSnhpfstCL2zBDGOvlTieIJ0GW89RwCHEtp6eTtR5PxRQ4VPJJ+vbr1pPj139i/OpgiuciokeNoHbm2vdvDh/vWsRGkDdq0V51x26RgV+8qkRIPL7mgdFbVvr+kKP7/QE8x6w9l24bRl+9ddul/rIamNl/Q3+TA/Vui81va4PjAPefbHAwQqQ== jack@KDT'

setuseradd()
{
  for i in  ${userlist[@]}
  do
    useradd -m $i -s /bin/bash 
    if [ $? -eq 0 ];then
       grep -o "$i ALL=NOPASSWD: ALL" /etc/sudoers
       if [ $? -ne 0 ];then   
         echo "$i ALL=NOPASSWD: ALL" >> /etc/sudoers        
         echo -e "\033[32mStep  add user $i  ok\033[0m"
       else
         echo -e "\033[31mUser $i is created failly!!! \033[0m"
         exit 1
       fi
    fi
  done
}

installapp()
{
apt-get install sudo vim aptitude ntp ntpdate git ssh bash-completion net-tools -y
if [ $? -eq 0 ];then
     echo -e "\033[32mStep  apt install basic ok\033[0m"
else
   echo -e "\033[31mapt install basic failly!!! \033[0m"
   exit 1
fi
}

setauth()
{
  for i in ${userlist[@]}
  do
    mkdir  /home/${i}/.ssh && touch /home/${i}/.ssh/authorized_keys
    echo $mm > /home/${i}/.ssh/authorized_keys
    chown -R ${i}:${i} /home/${i}/.ssh/
    if [ $? -eq 0 ];then
       echo -e "\033[32mStep $i add ssh auth ok\033[0m"
    else
       echo -e "\033[31m $i add ssh auth  failly!!! \033[0m"
       exit 1
    fi
  done
}

setulimit()
{
grep '*                soft    core            1024000' /etc/security/limits.conf  >& /dev/null && grep '*                hard    core            1024000' /etc/security/limits.conf >& /dev/null 
if [ $? -ne 0 ];then
  echo '
*                soft    core            1024000
*                hard    core            1024000
*                soft    nofile          1024000
*                hard    nofile          1024000
' >> /etc/security/limits.conf
  if [ $? -eq 0 ];then
    echo -e "\033[32mStep  limit set ok\033[0m"
  else
    echo -e "\033[31mlimit set failly!!! \033[0m"
    exit 1
  fi
fi
grep 'net.core.rmem_max = 2097152' /etc/sysctl.conf >& /dev/null  && grep 'net.core.wmem_max = 2097152' /etc/sysctl.conf >& /dev/null 
if [ $? -ne 0 ];then
echo '
net.core.rmem_max = 2097152
net.core.wmem_max = 2097152
  ' >>/etc/sysctl.conf
  if [ $? -eq 0 ];then
    echo -e "\033[32mStep  net.core set ok\033[0m"
  else
    echo -e "\033[31mnet.core set failly!!! \033[0m"
    exit 1
  fi
fi
}
envi_check()
{
  for i in ${userlist[@]}
  do
    id $i >& /dev/null  
    if [ $? -eq 0 ];then   
       echo -e "\033[31mUser $i already exists!!! \033[0m"
       exit 1
    fi  
  done
}
sethostname()
{
 hostname $hname && echo "$hname" > /etc/hostname
     if [ $? -eq 0 ];then   
       echo -e "\033[32mSet hostname $hname is OK!!! \033[0m"      
    else
      echo -e "\033[31mhostname set failly!!! \033[0m"
      exit 1
    fi
}
main()
{
envi_check
sethostname
installapp
setuseradd
setauth
setulimit
}

main
