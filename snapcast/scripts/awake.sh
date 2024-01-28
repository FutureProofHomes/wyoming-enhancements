#!/bin/bash
echo $(date) [awake.sh] ...Starting awake.sh script

### Insert any commands that you would like to call for performing external actions.
### This example will call a webhook on the HomeAssistant server which sends a remote control command to toggle mute on a sound bar.

#echo $(date) [awake.sh] ...Sending mute to living room tv 
#curl -X POST -H "Content-Type: application/json" -d '{"remote":"remote.living_room_hub","device":"JBL Sound Bar","command":"Mute"}' https://<HA server address>:8123/api/webhook/<WEBHOOK>  > /dev/null 2>&1 


### To lower the volume of anything currently playing through the PA server, we will invoke audio 'ducking' for the duration of the voice transaction
### To invoke audio 'ducking', we issue a silent media stream configured with the media.role property that can invoke the duck.  In this case, 'notification' role was configured.
### We set the client-name to something known as we will search for this afterwards and kill the client.  This end the ducking invoked by this stream.
echo $(date) [awake.sh] ...Starting silence
pacat --client-name=silence --volume=0 --property=media.role=notification < /dev/zero > /dev/null 2>&1 &
