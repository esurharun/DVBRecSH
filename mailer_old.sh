#!/bin/sh
IP=`/sbin/ifconfig | grep inet | grep -v inet6 | grep -v 127.0 | awk '{ print $2 }'`


echo "No-Content" | mail -s "[$IP] $1" mtm.sorunlar@gmail.com 


