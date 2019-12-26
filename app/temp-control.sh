#!/bin/bash

PIN=$1
TEMP_ON=$2
TEMP_OFF=$3
SLEEP=$4

gpio mode $PIN out

function temperature {
    __t=$1
    t=$(vcgencmd measure_temp | cut -d '=' -f 2 | cut -d "'" -f 1)
    eval $__t="'$t'"
}

while true; do
  vcgencmd measure_temp; 
  temperature temp
  if (( $(echo "$temp >= $TEMP_ON" | bc -l) )) ; then 
    gpio write $PIN 1; 
  elif (( $(echo "$temp <= $TEMP_OFF" | bc -l) )) ; then
    gpio write $PIN 0; 
  fi; 
  sleep $SLEEP; 
done
