#!/bin/bash
echo $(date) [stt-stop.sh] ...Starting stt-stop.sh script

#insert a sleep if you like to tune the sound to feel more natural
sleep 0.5

#purely for fun, this will play a sound after the user speech-to-text stage is done - computer is working :)
echo $(date) [stt-stop.sh] ...Playing sound after speech input
paplay --property=media.role=notification /home/pi/custom-sounds/stt-stop.wav
