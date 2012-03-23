/opt/recserver/channel0.sh stop
/opt/recserver/channel1.sh stop
/opt/recserver/channel2.sh stop
/opt/recserver/channel3.sh stop
ps auwx | grep dvbstream  | awk '{ print $2 }' | xargs kill -KILL
rmmod mantis
modprobe mantis
/opt/recserver/channel0.sh start
/opt/recserver/channel1.sh start
/opt/recserver/channel2.sh start
/opt/recserver/channel3.sh start
