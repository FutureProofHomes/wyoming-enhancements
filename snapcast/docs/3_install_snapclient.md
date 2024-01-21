## Install the SnapClient On Your Wyoming Voice Satellite

1. Connect to your Pi over SSH using the username/password you configured during flashing:
```sh
ssh <your_username>@<pi_IP_address>`
```

2. Make sure you are in your home directory
```sh
cd ~
```

3. Clone this wyoming-enhancements repository to your Pi so you can use the scripts.
```sh
git clone https://github.com/FutureProofHomes/wyoming-enhancements.git
```

4. Follow [the Snapclient developer's install steps](https://github.com/badaix/snapcast/blob/develop/doc/install.md#debian) to download the SnapClient into our new enhancements directory:
```sh
cd wyoming-enhancements/snapcast/
wget https://github.com/badaix/snapcast/releases/download/v0.27.0/snapclient_0.27.0-1_armhf.deb
```
```sh
sudo apt install ./snapclient_0.27.0-1_armhf.deb
```

5. Get the IP address of your SnapServer (typically the same IP as your Home Assistant instance) and let's modify the SnapClient's options so it always boots with correct settings.
```sh
sudo nano /etc/default/snapclient
```
```sh
# Start the client, used only by the init.d script
START_SNAPCLIENT=true

# Additional command line options that will be passed to snapclient
# note that user/group should be configured in the init.d script or the systemd unit file
# For a list of available options, invoke "snapclient --help"
SNAPCLIENT_OPTS="-h 192.168.xx.xx --player pulse:property=media.role=music --sampleformat 44100:16:*"
```

6. Let's modify our Snapcast service to it starts AFTER PulseAudio has already started:
```sh
sudo systemctl edit --force --full snapclient.service
```
    
Find the `After=....` line and add `pulseaudio.service`.  Your final modified service should look similar to the below:
```sh
[Unit]
Description=Snapcast client
Documentation=man:snapclient(1)
Wants=avahi-daemon.service
After=network-online.target time-sync.target sound.target avahi-daemon.service pulseaudio.service

[Service]
EnvironmentFile=-/etc/default/snapclient
ExecStart=/usr/bin/snapclient --logsink=system $SNAPCLIENT_OPTS
User=snapclient
Group=snapclient
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

7. Reboot your Pi:
```sh
sudo reboot -h now`
```

8. SSH back in to your Pi.  (See step 1)

9. Check to make sure both PulseAudio and your Snapclient are running as expected.  You should see green lights next to both services:
```sh
sudo systemctl status pulseaudio.service snapclient.service
```

10. Done! Move to next tutorial file.
