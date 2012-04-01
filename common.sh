#!/bin/bash

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games
SETCHANNELCMD=""

HOME=/opt/recserver/
YEAR=`date "+%Y"`
MONTH=`date "+%m"`
DAY=`date "+%d"`
HOUR=`date "+%H"`
MIN=`date "+%M"`
SEC=`date "+%S"`

DATE="${YEAR}${MONTH}${DAY}_${HOUR}${MIN}${SEC}"
TIME="${HOUR}${MIN}${SEC}"

FILENAMEBASE=/var/run/channel${CHANNEL}
LOGFILE=${FILENAMEBASE}.log
START_FILE=${FILENAMEBASE}.start
PID_FILE=${FILENAMEBASE}.pid
CMD_FILE=${FILENAMEBASE}.sh
TEMP_FILE=/tmp/ch${CHANNEL}-tmp.mpg

FFMPEG_MPG_ENCODE="ffmpeg -i pipe: -target pal-vcd -async 44100 -y ${TEMP_FILE} > ${LOGFILE} 2>&1"

FFMPEG_FLV_ENCODE="echo > /dev/null"
if $FLV_ENCODING_ENABLED; then

   DATE_FLV="${YEAR}_${MONTH}_${DAY}-${HOUR}_${MIN}_${SEC}"
   TIME_FLV="${HOUR}_${MIN}_${SEC}"
   START_FILE_FLV=${FILENAMEBASE}.flv.start	
   TEMP_FILE_FLV=/tmp/ch${CHANNEL}-tmp.flv
   LOGFILE_FLV=${FILENAMEBASE}.flv.log
   FFMPEG_FLV_ENCODE="ffmpeg -i pipe: -y -acodec libfaac -ar 22500 -ab 96k -coder ac -sc_threshold 40 -vcodec libx264 -b 270k -minrate 270k -maxrate 270k -bufsize 2700k -cmp +chroma -partitions +parti4x4+partp8x8+partb8x8 -i_qfactor 0.71 -keyint_min 25 -b_strategy 1 -g 250 -s 352x288 ${TEMP_FILE_FLV} > ${LOGFILE_FLV} 2>&1 " 

fi

PS_HEADER="/usr/bin/dvbstream -c ${CHANNEL}"
R_CMD="/usr/bin/dvbstream -c ${CHANNEL} -ps -f ${FREQUENCY} -p ${POL} -s ${SYMBOLRATE} -D ${DISEQC} -I 2 -o ${AUDIOPID} ${VIDEOPID} 2>> ${LOGFILE} | tee >(${FFMPEG_MPG_ENCODE}) >(${FFMPEG_FLV_ENCODE}) > /dev/null"
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

	if $FLV_ENCODING_ENABLED; then
		if test -e ${START_FILE_FLV} ; then
			START_TIME=`cat ${START_FILE_FLV}`
			REC_FILE="${FLV_RECPATH}/${FLV_CHANNELNAME}-${START_TIME}-${TIME_FLV}.flv"
			if test -e ${TEMP_FILE_FLV} ; then
				mv ${TEMP_FILE_FLV} ${TEMP_FILE_FLV}.copy.${TIME} > /dev/null
				mv ${TEMP_FILE_FLV}.copy.${TIME} ${REC_FILE} > /dev/null &
			else
				echo "Temporary FLV file is not found"
			fi
		fi

		if test -e ${START_FILE_FLV} ; then	
		        `rm ${START_FILE_FLV} > /dev/null`
		fi	
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

	 if $FLV_ENCODING_ENABLED; then
		echo ${DATE_FLV} > ${START_FILE_FLV}
	 fi

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

