#!/bin/bash
echo $(date) [done.sh] ...Starting done.sh script
export PULSE_RUNTIME_PATH=/var/run/user/1000/pulse
sleep 0.5

echo $(date) [done.sh] ...Killing 'silence' pulseaudio client
sudo kill $(pactl list clients | awk '/application.name = "silence"/,/^$/' | awk -F' = ' '/application.process.id/ {print $2}' | sed 's/"//g')
