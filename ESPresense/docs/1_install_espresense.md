
**NOTE: This tutorial requires separate ESP32 hardware that we can plug directly into the Wyoming Satellite for each zone in our home.  I personally love the M5 Stack ATOM Lite ESP32 for this project. **

1. Plug your ESP32 in to your computer via USB

2. Open Google Chrome and flash your ESP32 from [espresense.com/firmware](https://espresense.com/firmware).  Be sure to select the correct flavor of ESP32 device you're using.  Congrats!  You now have your first ESPresnce base station.

3. Follow the steps in your browser to add your 2.4ghz wifi SSID name and password to your base station.  Check your router to find the IP address of your ESPresense base station.  

4. Open a new browser tab and paste in the ESPresense IP address to access the device's webserver.  Give the device a name and add your MQTT endpoints.  Save & restart the ESP32.

5. After reboot, go back into your ESPresense webserver, scroll the bottom and select "Click here to edit other settings".  You can also add `/ui` to the end of the URL.  

6. In the left-hand navigation click on "Devices" then click the blue "Enroll" button. Follow the [Apple Watch enrollment steps on the ESPresense Website](https://espresense.com/beacons/apple#apple-watch-using-bluetooth-terminal-app) to enroll your Apple watch (temporarily requires iOS and Watch app to be installed).

7. Edit HomeAssistant's `configuration.yaml` to add your Apple Watch as a sensor you want to track in Home Assistant.

```yaml
sensor:
  - platform: mqtt_room
    name: "ble_brads_watch"
    device_id: "ble_brads_watch"
    state_topic: "espresense/devices/ble_brads_watch"
    timeout: 5
    away_timeout: 120
```

8. Reboot Home Assistant.

9. Open the left-hand navigation within Home Assistnat and select "Developer Tools".  Go to the States tab and search for `ble_brads_watch` and notice the state value will be the nearby ESPresense device and the distance from that device.  Install multiple ESPresense devices in important locations within your home and get a sense of which room your family member's watches are in.

The calibration and relative locations of multiple ESPresense Base Stations are important.  Be sure and read about all of ESPresense's [calibration settings here](https://espresense.com/configuration/settings#calibration).