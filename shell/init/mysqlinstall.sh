#!/bin/bash

sudo aptitude install mysql-server -y >& /dev/null
sudo /etc/init.d/mysql stop
if [ ! -d "/srv/data/" ]; then
    sudo mkdir /srv/data    
    sudo mv  /var/lib/mysql /srv/data/
    sudo ln -s /srv/data/mysql /var/lib
    sudo /etc/init.d/mysql start
elif [ ! -d "/srv/data/mysql" ]; then
    sudo mv  /var/lib/mysql /srv/data/
    sudo ln -s /srv/data/mysql /var/lib
    sudo /etc/init.d/mysql start
else    
    sudo /etc/init.d/mysql start
    exit 1
fi
