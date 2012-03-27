#!/bin/bash

FAIL_STR="Not able to lock to the signal on the given frequency"
FILE=""
CHANNEL=""
RUN=""

checker()
{

  echo Checking $FILE ... 
  if [ -f  $FILE ] ; then 
	RES=`cat $FILE | grep "$FAIL_STR"`
 	 if [ -n "$RES" ] ; then
  		 echo "`date` $CHANNEL is not started. Trying to restart." >> /opt/recserver/checker.log
  		 $RUN
	 else
		echo "OK"
	 fi
  else
	echo $FILE not exists..
  fi
}

for CH in 0 1 2
do
	FILE="/var/run/channel${CH}.log"
	CHANNEL="Channel ${CH}"
	RUN="/opt/recserver/channel${CH}.sh start"
	checker
done
