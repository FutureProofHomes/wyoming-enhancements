#!/bin/bash
echo $(date) [done.sh] ...Starting done.sh script

#if running PA as a user - define the runtime path for the 'pactl' command to use.  Substitute the correct uid in the path
export PULSE_RUNTIME_PATH=/var/run/user/1000/pulse

#insert a sleep if you like to tune the sound to feel more natural
sleep 0.5

echo $(date) [done.sh] ...Killing 'silence' pulseaudio client

#this will search the list of running streams on the PA server for the 'silence' stream and kill it.  This will take the PA server out of ducking mode and your music will return to normal volume
sudo kill $(pactl list clients | awk '/application.name = "silence"/,/^$/' | awk -F' = ' '/application.process.id/ {print $2}' | sed 's/"//g')
