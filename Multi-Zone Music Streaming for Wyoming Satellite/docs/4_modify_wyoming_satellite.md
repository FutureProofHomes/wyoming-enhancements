## Create a Modified `Wyoming-Satellite.service` That Usse PulseAudio

1. Connect to your Pi over SSH using the username/password you configured during flashing:
```sh
ssh <your_username>@<pi_IP_address>
```

2. Make a copy of your exisitng `wyoming-satellite.service` and rename that copy to `enhanced-wyoming-satellite.service`:
```sh
sudo cp /etc/systemd/system/wyoming-satellite.service /etc/systemd/system/enhanced-wyoming-satellite.service
```

3. Modify our new `enhanced-wyoming-satellite.service` to leverage pulseAudio and our volume ducking capabilities.
```sh
sudo systemctl edit --force --full enhanced-wyoming-satellite.service
```

Add `Requires=pulseaudio.service` in the `[Unit]` section
```sh
Requires=pulseaudio.service
```

Update `--mic-command` to use PulseAudio's `parecord` command:
```sh
--mic-command 'parecord --property=media.role=phone --rate=16000 --channels=1 --format=s16le --raw' \
```

Update `--send-command` to use PulseAudio's `paplay` command:
```sh
--snd-command 'paplay --property=media.role=announce --rate=44100 --channels=1 --format=s16le --raw' \
```

Update `--send-command-rate` to to match our `441000` sample rate we've been using`:
```sh
--snd-command-rate 44100 \
```

Add `--detection-command` so that we duck our volume when necessary:
```sh
--detection-command '/home/<your_username>/wyoming-enhancements/snapcast/scripts/awake.sh' \
```

Add `--tts-stop-command` so that we turn the volume back up after the interaction is complete:
```sh
--tts-stop-command '/home/<your_username>/wyoming-enhancements/snapcast/scripts/done.sh' \
```

5. Your resulting `enhanced-wyoming-satellite.service` should resemble the below.  Be sure to change `loftsatellite` to your username.
```sh
[Unit]
Description=Enhanced Wyoming Satellite
Wants=network-online.target
After=network-online.target
Requires=wyoming-openwakeword.service
Requires=2mic_leds.service
Requires=pulseaudio.service

[Service]
Type=simple
ExecStart=/home/loftsatellite/wyoming-satellite/script/run \
    --name 'Loft Satellite' \
    --uri 'tcp://0.0.0.0:10700' \
    --mic-command 'parecord --property=media.role=phone --rate=16000 --channels=1 --format=s16le --raw' \
    --snd-command 'paplay --property=media.role=announce --rate=44100 --channels=1 --format=s16le --raw' \
    --snd-command-rate 44100 \
    --snd-volume-multiplier 0.1 \
    --mic-auto-gain 7 \
    --mic-noise-suppression 3 \
    --wake-uri 'tcp://127.0.0.1:10400' \
    --wake-word-name 'hey_jarvis' \
    --event-uri 'tcp://127.0.0.1:10500' \
    --detection-command '/home/loftsatellite/wyoming-enhancements/snapcast/scripts/awake.sh' \
    --tts-stop-command '/home/loftsatellite/wyoming-enhancements/snapcast/scripts/done.sh' \
    --awake-wav sounds/awake.wav \
    --done-wav sounds/done.wav
WorkingDirectory=/home/loftsatellite/wyoming-satellite
Restart=always
RestartSec=1

[Install]
WantedBy=default.target
```
6. Start our newly created `enhanced-wyoming-satellite.service` service:
```sh
sudo systemctl enable --now enhanced-wyoming-satellite.service
```

7. Make sure all 5 services are running on your pi with green lights:
```sh
sudo systemctl status enhanced-wyoming-satellite.service wyoming-openwakeword.service 2mic_leds.service  pulseaudio.service snapclient.service
```

8. Done! Move to next tutorial file.