#!/bin/bash

# PROVIDE: channel0 
# REQUIRE: DAEMON
# KEYWORD: nojail 

CHANNEL=2
RECPATH=/stdisk/TRT_Turk/
FREQUENCY=11096000
POL="H"
SYMBOLRATE=30000
AUDIOPID=713
VIDEOPID=712
DISEQC=1

CURR_DIR=`dirname $0`

source $CURR_DIR/common.sh
