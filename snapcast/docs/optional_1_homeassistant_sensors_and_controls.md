# [OPTIONAL] Integrate Satellite PulseAudio into HomeAssistnat

## Background
Currently, there are no known integrations for controlling remote PulseAudio servers.

The following setup will create `shell_command` services allowing for control from HomeAssistant. 

These services can be used to integrate controls on dashboards, used in automations, etc.


Basic Volume and Mute controls:
- Set volume to a specified %
- Increase/Decrease volume by specific %
- Mute/Unmute/Toggle Mute

---

## Services (shell_command)
The services are built on `shell_command` which utilizes ssh commands from the HomeAssistant instance to the satellites.  
The community has provided excellent guides on setting up passwordless ssh connections from your HomeAssistant instance which is a prerequisite to this setup.

Add the following `shell_command` definitions to your configuration:
```
shell_command:
  pa_volume_set: "ssh -i /config/.ssh/id_rsa -o UserKnownHostsFile=/config/.ssh/known_hosts {{ ssh_user_at_host }} pamixer --set-volume {{ volume_percent }}"
  pa_volume_increase: "ssh -i /config/.ssh/id_rsa -o UserKnownHostsFile=/config/.ssh/known_hosts {{ ssh_user_at_host }} pamixer --increase {{ volume_percent }}"
  pa_volume_decrease: "ssh -i /config/.ssh/id_rsa -o UserKnownHostsFile=/config/.ssh/known_hosts {{ ssh_user_at_host }} pamixer --decrease {{ volume_percent }}"
  pa_volume_mute: "ssh -i /config/.ssh/id_rsa -o UserKnownHostsFile=/config/.ssh/known_hosts {{ ssh_user_at_host }} pamixer --mute"
  pa_volume_unmute: "ssh -i /config/.ssh/id_rsa -o UserKnownHostsFile=/config/.ssh/known_hosts {{ ssh_user_at_host }} pamixer --unmute"
  pa_volume_toggle_mute: "ssh -i /config/.ssh/id_rsa -o UserKnownHostsFile=/config/.ssh/known_hosts {{ ssh_user_at_host }} pamixer --toggle-mute"
```

You can now call the services as you would any other.
The variable `{{ ssh_user_at_host }}` should be set in the payload to address the specific satellite, and `{{ volume_percent }}` for the requested percentage.

Examples:

Increase volume by 10%:
```
- service: shell_command.pa_volume_increase
            metadata: {}
            data:
              ssh_user_at_host: <user>@<satellite>
              volume_percent: "10"
```

Set the volume to a specified percentage - take the value from an `input_number` helper which can be a slider on your dashboard:
```
- service: shell_command.pa_volume_set
            metadata: {}
            data:
              ssh_user_at_host: <user>@<satellite>
              volume_percent: "{{ states('input_number.volume_slider')|int }}"
```


---

## Switches and Sensors

We can create entities in HomeAssistant to represent our PulseAudio server state on the satellite.  You can create a corresponding `switch` and `sensor` entity for each.
For this function, we use the `command_line` integration.

In your configuration, add:
```
command_line:
  - switch:
      name: Satellite PA Mute
      unique_id: satellite_pa_mute
      command_on: "ssh -i /config/.ssh/id_rsa -o UserKnownHostsFile=/config/.ssh/known_hosts <user>@<satellite> pamixer -m"
      command_off: "ssh -i /config/.ssh/id_rsa -o UserKnownHostsFile=/config/.ssh/known_hosts <user>@<satellite> pamixer -u"
      command_state: "ssh -i /config/.ssh/id_rsa -o UserKnownHostsFile=/config/.ssh/known_hosts <user>@<satellite> pamixer --get-mute"
      scan_interval: 15
      value_template: '{{ value == "true" }}'
      icon: >
        {% if is_state('switch.satellite_pa_mute', 'on') %}
          mdi:speaker-off
        {% else %}
          mdi:speaker
        {% endif %}
  - sensor:
      name: Satellite PA Volume
      unique_id: satellite_pa_volume
      command: "ssh -i /config/.ssh/id_rsa -o UserKnownHostsFile=/config/.ssh/known_hosts <user>@<satellite> pamixer --get-volume"
      unit_of_measurement: "%"
      scan_interval: 15
      icon: >
        {% set volume = states('sensor.satellite_pa_volume')|int %}
        {% if volume == 0 %}
          mdi:volume-mute
        {% elif volume < 33 %}
          mdi:volume-low
        {% elif volume < 66 %}
          mdi:volume-medium
        {% else %}
          mdi:volume-high
        {% endif %}
```

---

## Dashboard Controls

You can add elements to your dashboards to control the PulseAudio volume on the satellites.
For instance, you can add a volume slider and a mute toggle button.

The volume slider can be implemented with the assistance of an `input_number` helper and a small automation to sync the state.

This sample automation is basic but functional.  It is bi-directional - meaning that the changing the slider will change the volume on the satellite.
Inversely, the slider will update on the HomeAssistant side if the volume is changed from the satellite.


```
alias: "[controller] Set PA volume from Input Slider"
description: Syncs volume (input_number) entity and PulseAudio server volume
trigger:
  - platform: state
    entity_id:
      - input_number.satellite1_volume
      - input_number.satellite2_volume
    id: set_from_slider
    alias: When volume changes from the input_helper
  - platform: state
    entity_id:
      - sensor.satellite1_pa_volume
      - sensor.satellite2_pa_volume
    id: set_from_speaker
    alias: When volume changes from the satellite side
condition: []
action:
  - choose:
      - conditions:
          - condition: trigger
            id:
              - set_from_slider
        sequence:
          - service: shell_command.pa_volume_set
            metadata: {}
            data:
              ssh_user_at_host: <user>@<satellite>
              volume_percent: "{{ states('input_number.satellite1_volume')|int }}"
          - service: shell_command.pa_volume_set
            metadata: {}
            data:
              ssh_user_at_host: <user>@<satellite>
              volume_percent: "{{ states('input_number.satellite1_volume')|int }}"
        alias: Sync Speaker Volume to Sliders
      - conditions:
          - condition: trigger
            id:
              - set_from_speaker
        sequence:
          - service: input_number.set_value
            target:
              entity_id: input_number.satellite1_volume
            data:
              value: "{{ states('sensor.satellite1_pa_volume')|int }}"
          - service: input_number.set_value
            target:
              entity_id: input_number.satellite2_volume
            data:
              value: "{{ states('sensor.satellite2_pa_volume')|int }}"
        alias: Sync Sliders from Speakers
mode: single

```
