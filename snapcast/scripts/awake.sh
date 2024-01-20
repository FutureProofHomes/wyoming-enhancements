#!/bin/bash
echo $(date) [awake.sh] ...Starting awake.sh script
echo $(date) [awake.sh] ...Starting silence
pacat --client-name=silence --volume=0 --property=media.role=notification < /dev/zero & 
