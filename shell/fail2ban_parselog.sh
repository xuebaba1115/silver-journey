#!/bin/bash

logstime="/srv/apps/websocial/server/apache-tomcat-8.5.16/logs/localhost_access_log.$(date +%Y-%m-%d).txt"
echo $logstime
lnpath='/srv/apps/websocial/parse_log/localhost_access.txt'
echo $lnpath
if [  -f "$lnpath" ]; then
  echo cunzai
  rm $lnpath && ln -s $logstime $lnpath
else
  echo no
  ln -s $logstime $lnpath
fi
