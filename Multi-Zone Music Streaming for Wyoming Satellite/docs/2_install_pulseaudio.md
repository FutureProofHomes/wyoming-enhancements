## Install PulseAudio On Your Wyoming Voice Satellite

1. Connect to your Pi over SSH using the username/password you configured during flashing:
```sh
ssh <your_username>@<pi_IP_address>
```

2. Disable/Stop the entire Wyoming stack temporarily:
```sh
sudo systemctl disable --now wyoming-satellite.service
```
```sh
sudo systemctl stop wyoming-openwakeword.service 2mic_leds.service
```

3. Install PulseAudio drivers and necessary utilities:
 ```sh
sudo apt-get update
sudo apt-get install \
    pulseaudio \
    pulseaudio-utils
```

4. Reboot your Pi:
 ```sh
sudo reboot -h now
```

5. SSH back in to your Pi.  (See step 1.)

6. Ensure PulseAudio is runnining in "system-wide mode".  Per the [official instructions](https://www.freedesktop.org/wiki/Software/PulseAudio/Documentation/User/SystemWide/) we first need to stop some existing services to be safe:
 ```sh
sudo systemctl --global disable pulseaudio.service pulseaudio.socket
```

7. It is also advisable to set `autospawn = no` in `/etc/pulse/client.conf`:
```sh
sudo nano /etc/pulse/client.conf
```


8. Create our new `PulseAudio.service`:
```sh
sudo systemctl edit --force --full pulseaudio.service
```
```sh
[Unit]
Description=PulseAudio system server

[Service]
Type=notify
ExecStart=pulseaudio --daemonize=no --system --realtime --log-target=journal

[Install]
WantedBy=multi-user.target
```

9. Start our new `PulseAudio.service`.  This will require you to type in your password a couple times.
 ```sh
 systemctl --system enable pulseaudio.service
 ```
 ```sh
 systemctl --system start pulseaudio.service
 ```

10. Ensure all users needing access to PulseAudio are in the `pulse-access` group:
```sh
sudo sed -i '/^pulse-access:/ s/$/root,pi,snapclient,<your_username_here>/' /etc/group
```

11. Reboot your Pi: (see step 4)

12. (OPTIONAL) If plugging speakers into the headphone jack, set the correct PulseAudio Sync Port:

Run `pactl list sinks` and scroll to the bottom and notice your Active Port is probably "analog-output-speaker".  Run the command below to output audio through the 3.5mm headphone jack.
```sh
pactl set-sink-port 1 "analog-output-headphones"
```

13. Test and make sure you can hear the wav file:
```sh
paplay /usr/share/sounds/alsa/Front_Center.wav
```

14. Modify PulseAudio to duck the music volume when you or the voice assistant are speaking:
```sh
sudo nano /etc/pulse/system.pa
```

Add the module below to the bottom of the file and save.
```sh
### Enable Volume Ducking
load-module module-role-ducking trigger_roles=announce,phone,notification,event ducking_roles=any_role volume=33%
```

15. Reboot your Pi: (see step 4)

16. Done! Move to next tutorial file.
