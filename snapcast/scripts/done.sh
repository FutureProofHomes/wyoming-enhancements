#!/bin/bash
echo $(date) [done.sh] ...Starting done.sh script

### When PA is in user mode: define the runtime path for the 'pactl' command to use.  Substitute the correct uid in the path.
#export PULSE_RUNTIME_PATH=/var/run/user/1000/pulse

### Insert a sleep if you like to tune the sound to feel more natural
#sleep 0.5

echo $(date) [done.sh] ...Playing finish beep
paplay --property=media.role=notification /home/pi/custom-sounds/done.wav 
sleep 1

### Here we will end the audio ducking we invoked at teh awake.sh stage
### this will search the list of clients on the PA server for the 'silence' stream we initiated and kill it.  This will take the PA server out of ducking mode and your music will return to normal volume
echo $(date) [done.sh] ...Killing 'silence' pulseaudio client
sudo kill $(pactl list clients | awk '/application.name = "silence"/,/^$/' | awk -F' = ' '/application.process.id/ {print $2}' | sed 's/"//g')

### Insert any commands that you would like to call for performing external actions.
### This example will call a webhook on the HomeAssistant server which sends a remote control command to toggle mute on a sound bar.

#echo $(date) [done.sh] ...Sending mute to living room tv 
#curl -X POST -H "Content-Type: application/json" -d '{"remote":"remote.living_room_hub","device":"JBL Sound Bar","command":"Mute"}' https://<HA server address>:8123/api/webhook/<WEBHOOK>  > /dev/null 2>&1 
#insert any other commands you like to happen.  This example calls a webhook on the home assistant server to toggle a mute on a sound bar:
