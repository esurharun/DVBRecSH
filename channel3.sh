#!/bin/bash

# PROVIDE: channel0 
# REQUIRE: DAEMON
# KEYWORD: nojail 

CHANNEL=3
RECPATH=/disk2/Euronews/
FREQUENCY=11096000
POL="H"
SYMBOLRATE=30000
AUDIOPID=1112
VIDEOPID=1113
DISEQC=1

CURR_DIR=`dirname $0`

source $CURR_DIR/common.sh

