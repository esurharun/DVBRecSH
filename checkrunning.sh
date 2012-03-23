#!/bin/bash

DISKID=""
RUN=""

checker()
{
  if [ -z "`ps auwx | grep buffer | grep -E $DISKID`" ] ; then
   echo "`date` $DISKID stopped. Restarted" >> /root/output
   $RUN

  fi
}

DISKID="(diski1_1)"
RUN="/opt/recserver/channel0.sh start"
checker
DISKID="(diski2_1)"
RUN="/opt/recserver/channel1.sh start"
checker
DISKID="(diski3_1)"
RUN="/opt/recserver/channel2.sh start"
checker
DISKID="(diski4_1)"
RUN="/opt/recserver/channel3.sh start"
checker
