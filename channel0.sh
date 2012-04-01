#!/bin/bash

# PROVIDE: channel0 
# REQUIRE: DAEMON
# KEYWORD: nojail 

CHANNEL=0
RECPATH=/stdisk/TRT_1/
FREQUENCY=11096000
POL="H"
SYMBOLRATE=30000
AUDIOPID=513
VIDEOPID=512
DISEQC=1

CURR_DIR=`dirname $0`

FLV_ENCODING_ENABLED=true
FLV_CHANNELNAME="TRT1"
FLV_RECPATH="/stdisk/FLV/${FLV_CHANNELNAME}/"
`mkdir -p ${FLV_RECPATH}`


source $CURR_DIR/common.sh

