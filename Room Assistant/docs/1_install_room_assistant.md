
**NOTE: Room Assistant does have official instructions on their website, but you will have issues with those instructions on the Wyoming Satellite's Raspberry Pi Zero 2w hardware, hence this write up.**

1. SSH into your Wyoming Satellite and Install NodeJS on the Raspberry Pi (wait 60 sec for the deprecation warning to pass)
```sh
curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash -
sudo apt-get install -y nodejs
```

2. Update and upgrade all your packages
```sh
sudo apt update && sudo apt upgrade
```

3. Overclock your Raspberry Pi CPU to 1100.  This will help build binaries quicker.  Believe me.  Set the `arm_freq=1100` then exit and save the file.
```sh
sudo nano /boot/config.txt
```

4. Temporarily disable the Pi's swap.
```sh
sudo dphys-swapfile swapoff
```

5. Increase the swap size.  This will help the install actually complete on your Raspberry Pi.  If you don't do this it will take hours.  Set the `CONF_SWAPSIZE=1024` then exit and safe the file.
```sh
sudo nano /etc/dphys-swapfile
```

6. Turn the Pi's swap back on.
```sh
sudo dphys-swapfile swapon
```

7. Reboot the Pi for the updated SWAP and CPU clock speed to take effect.
```sh
sudo reboot
```

8. Install all of Room Assistant's dependencies.
```sh
sudo apt-get update && sudo apt-get install build-essential libavahi-compat-libdnssd-dev libsystemd-dev bluetooth libbluetooth-dev libudev-dev libcairo2-dev libpango1.0-dev libjpeg-dev libgif-dev librsvg2-dev
```

9. Install the most stable beta of Room Assistant and use the correct flags so you can see the progress.  Don't use the similar command Room Assistant recommends as it has been locking up Raspberry Pi Zero 2 W hardware requiring reboots.
```sh
sudo npm i --global --unsafe-perm --verbose --foreground-scripts room-assistant@3.0.0-beta.4
```

10. Grant some additional permissions by executing the commands below.
```sh
sudo setcap cap_net_raw+eip $(eval readlink -f `which node`)
sudo setcap cap_net_raw+eip $(eval readlink -f `which hcitool`)
sudo setcap cap_net_admin+eip $(eval readlink -f `which hciconfig`)
```

11. Create your Room Assistant config directory in your user directory.
```sh
mkdir -p ~/room-assistant/config
```

12. Create a new config file with `sudo nano ~/room-assistant/config/local.yml` and put your room-assistant configuration in it. The example below configures the [Home Assistant Core](https://www.room-assistant.io/integrations/home-assistant.html) and [Bluetooth Classic](https://www.room-assistant.io/integrations/bluetooth-classic.html) integrations. If you want to use something else check out the [integrations](https://www.room-assistant.io/integrations) section.

**(NOTE: On your Apple Watch go to Settings->General->About and find the Bluetooth MAC address.)**

```sh
global:
  integrations:
    - homeAssistant
    - bluetoothClassic
homeAssistant:
  mqttUrl: 'mqtt://homeassistant.local:1883'
  mqttOptions:
    username: youruser
    password: yourpass
bluetoothClassic:
  addresses:
    - <bluetooth-mac-of-device-to-track>
```

13. Go to your room-assistant by executing `cd ~/room-assistant`.  Then run room-assistant by executing `room-assistant`.  You should see your Wyoming Satellite connect to your MQTT broker successfully.

![image](https://github.com/FutureProofHomes/wyoming-enhancements/assets/155350996/ade746c2-9929-4881-b2ee-0130f47dfdd1)

I highly recommend installing MQTT Explorer on your computer and confirming Room Assistant is reporting your Bluetooth Device's MAC address successfully.

![image](https://github.com/FutureProofHomes/wyoming-enhancements/assets/155350996/d95a9892-bc11-4f84-9358-4f3232c557f6)


14. Create a new `room-assistant.service` file.
```sh
sudo nano /etc/systemd/system/room-assistant.service 
```

15. Paste in the below service details and modify it to include your user?
```sh
[Unit]
Description=room-assistant service

[Service]
Type=notify
ExecStart=/usr/bin/room-assistant
WorkingDirectory=/home/<your_user_here>/room-assistant
TimeoutStartSec=120
TimeoutStopSec=30
Restart=always
RestartSec=10
WatchdogSec=60
User=<your_user_here>

[Install]
WantedBy=multi-user.target
```

16. Enable your new Room Assistant Service File
```sh
sudo systemctl enable room-assistant.service
```

17. Start the Service
```sh
sudo systemctl start room-assistant.service
```

**(NOTE: You can set the Pi's Swap size back to 100 now if you'd like.)**
