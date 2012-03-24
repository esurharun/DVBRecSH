#!/bin/bash

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games
SETCHANNELCMD=""

DATE=`date "+%Y%m%d_%H%M%S"`
TIME=`date "+%H%M%S"`
FILENAMEBASE=/var/run/channel${CHANNEL}
LOGFILE=${FILENAMEBASE}.log
START_FILE=${FILENAMEBASE}.start
PID_FILE=${FILENAMEBASE}.pid
CMD_FILE=${FILENAMEBASE}.sh
TEMP_FILE=/tmp/ch${CHANNEL}-tmp.mpg
#dvbstream -c 0 -ps -f 11096000 -p H -s 30000 -D 1 -I 2 -o 513 512 | ffmpeg -i pipe: -t 00:05:00 -target pal-vcd -y o.mpg

#COMMAND="buffer -m 8192k -p 75 -i /dev/video${CHANNEL} -o ${TEMP_FILE}"
PS_HEADER="/usr/bin/dvbstream -c ${CHANNEL}"
R_CMD="/usr/bin/dvbstream -c ${CHANNEL} -ps -f ${FREQUENCY} -p ${POL} -s ${SYMBOLRATE} -D ${DISEQC} -I 2 -o ${AUDIOPID} ${VIDEOPID} 2>> ${LOGFILE} | ffmpeg -i pipe: -target pal-vcd -async 44100 -y ${TEMP_FILE} > ${LOGFILE} 2>&1"
echo "${R_CMD}" > ${CMD_FILE}
chmod +x ${CMD_FILE}
COMMAND="${CMD_FILE}"

kill_processes()
{
	 	ps auwx | grep "${PS_HEADER}" | grep -v grep | awk '{ print $2 }' | awk '{ system( "kill  " $1 ) }'
} 

is_processes_alive() 
{
	AC=`ps auwx | grep "${PS_HEADER}" | grep -v grep | awk '{ print $2 }' | head -n 1`
	if [ ! -z ${AC} ] ; then
		echo "true"
	else
		echo "false" 
	fi
}

stop()
{
	echo "Stopping channel " ${CHANNEL} " ..."
	if [ `is_processes_alive` = "true" ]; then
		kill_processes
	fi
	if test -e ${START_FILE} ; then
        	START_TIME=`cat ${START_FILE}`
		REC_FILE="${RECPATH}/CH${CHANNEL}-${START_TIME}-${TIME}.mpg"	
		if test -e ${TEMP_FILE} ; then
			mv ${TEMP_FILE} ${TEMP_FILE}.copy.${TIME} > /dev/null
			mv ${TEMP_FILE}.copy.${TIME} ${REC_FILE} >/dev/null &
		else
			echo "Temporary file is not found.."
		fi 
	
		if test -e ${START_FILE} ; then
			`rm ${START_FILE} >/dev/null`
		else
			echo "Startup file is not found.."
 		fi
	fi
	
	if [ `is_processes_alive` = "false" ]; then
		echo "Channel " ${CHANNEL} " stopped.."
	fi
}

start()
{
	sleep 3
 	 echo "Starting channel " ${CHANNEL} " ..." 
	 ${COMMAND}  & 
         echo ${DATE} > ${START_FILE}
	 echo "Channel " ${CHANNEL} " started."
}

if [ ! -z "${1}" ]; then
	if [ ${1} = "start" ]; then
	 if [ `is_processes_alive` = "true" ]; then
		echo "Channel ${CHANNEL} is already recording"
	 fi
	 stop
	 start
	fi

	if [ ${1} = "stop" ]; then
	 if [ `is_processes_alive` = "false" ]; then
		echo "Channel ${CHANNEL} is not recording"
		exit 0
	 fi
	 stop 
        fi
fi

