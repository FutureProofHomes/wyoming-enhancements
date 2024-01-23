#!/bin/bash
echo $(date) [stt-stop.sh] ...Starting stt-stop.sh script

#insert a sleep if you like to tune the sound to feel more natural
sleep 0.5

echo $(date) [stt-stop.sh] ...Playing finish beep
paplay --property=media.role=notification /home/pi/custom-sounds/stt-stop.wav 
