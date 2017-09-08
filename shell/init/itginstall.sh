#!/bin/bash
read -p "Choose install grafana (Y or N,defult is N):" hname

if [ ${hname:='n'} == "y" ] || [ ${hname:='n'} == "Y" ];then
    echo "You choose y,install grafana influxdb telegraf...."  
    sudo dpkg -i ./itg/telegraf_1.3.5-1_amd64.deb
    sudo dpkg -i ./itg/influxdb_1.3.2_amd64.deb
    sudo apt-get install -y adduser libfontconfig
    sudo dpkg -i ./itg/grafana_4.4.3_amd64.deb  
    sudo service start influxdb
    sudo service start grafana-server
else
    echo "You choose n,install  influxdb telegraf...."  
    sudo dpkg -i ./itg/telegraf_1.3.5-1_amd64.deb
    sudo dpkg -i ./itg/influxdb_1.3.2_amd64.deb
fi

