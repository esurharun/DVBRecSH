LOG_FILE=/var/run/restartall.log

/opt/recserver/channel0.sh stop 2>&1  > ${LOG_FILE}
/opt/recserver/channel1.sh stop 2>&1  >> ${LOG_FILE}
/opt/recserver/channel2.sh stop 2>&1  >> ${LOG_FILE}
ps auwx | grep dvbstream  | awk '{ print $2 }' | xargs kill -KILL 
#modprobe -r mantis 2>&1  >> ${LOG_FILE}
#modprobe mantis 2>&1  >> ${LOG_FILE}
/opt/recserver/channel0.sh start 2>&1  >> ${LOG_FILE}
/opt/recserver/channel1.sh start 2>&1  >> ${LOG_FILE}
/opt/recserver/channel2.sh start 2>&1  >> ${LOG_FILE}
/opt/recserver/checkrunning.sh
