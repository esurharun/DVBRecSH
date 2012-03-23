#!/bin/bash
find  $1 -printf "%T@ %p\n" | sort -n | grep .mpg | grep -v "tmp.mpg" | head -n 1 | awk '{ print( $2 ) }' | xargs rm 
