# THIS REPO IS OUTDATED
Hello, world!
The FPH team is currently focused on our ESP32-based voice assistant, the [Satellite1 Dev Kit](https://futureproofhomes.net/products/satellite1-pcb-dev-kit). As a result, this repository may be outdated.

That said, it is entirely possible to connect just the [Satellite1 HAT](https://futureproofhomes.net/products/satellite1-top-microphone-board) to a Raspberry Pi running Wyoming. If anyone would like to take ownership of this project, the FPH team is happy to support and assist in building a Wyoming-compatible voice assistant on the Satellite1 hardware.

Thank you for your understanding!

# Wyoming Voice Assistant Enhancements

This repository is dedicated to sharing tutorials that enhance Home Assistant's [Wyoming Voice Satellite project](https://github.com/rhasspy/wyoming-satellite).

## Enhancement 1: Extended OpenAI Conversation Integration

Elevate Home Assistant's voice capabilities by integrating a Large Language Model (LLM) to the conversation agent.  The AI can run locally within your home, or you can pay for OpenAI's cloud-based ChatGPT API. This enhancement helps your voice assistant feel natural while gaining advanced control of your home.

**Voice Command Examples:**
- "Hey Jarvis, turn off the lights, lock the doors, and check if my kids are asleep."
- "Hey Jarvis, who is Bruce Wayne?"

**Prerequisite Hardware/Software:**
- [Wyoming Voice Satellite project](https://github.com/rhasspy/wyoming-satellite)

**Additional Software/Configurations Required:**
- [Extended OpenAI Conversation](https://github.com/jekalmin/extended_openai_conversation)
- [Recommended LLM Prompt](https://github.com/FutureProofHomes/wyoming-enhancements/blob/main/extended_openai_conversation/recommended_prompt.txt)
- [LocalAI](https://localai.io/) (Optional for local LLM)

**Documentation & Tutorials:**
- [Watch the video tutorial](https://www.youtube.com/watch?v=pAKqKTkx5X4)
- [Written Tutorial](https://github.com/rhasspy/wyoming-satellite)

## Enhancement 2: Multi-Zone Music Streaming for Wyoming Satellite

Enhance the capabilities of your Wyoming Voice Assistants to unlock multi-room music streaming, akin to Sonos. Enjoy seamless playback of your local music collection, Spotify, Tidal, and more through the speakers connected to your Wyoming Satellites. The system intelligently lowers the music volume when you or the voice assistant are speaking.

**Voice Command Examples:**
- "Hey Jarvis, play Michael Jackson in the loft."

**Prerequisite Hardware/Software:**
- [Wyoming Voice Satellite project](https://github.com/rhasspy/wyoming-satellite)

**Additional Software/Configurations Required:**
- [Extended OpenAI Conversation](https://github.com/jekalmin/extended_openai_conversation)
- [Snapcast Server](https://github.com/Art-Ev/addon-snapserver)
- [Snapcast Client](https://github.com/badaix/snapcast)
- [PulseAudio](https://www.freedesktop.org/wiki/Software/PulseAudio/)
- [BETA Music Assistant](https://github.com/music-assistant/hass-music-assistant)

**Documentation & Tutorials:**
- [Watch the video tutorial](https://youtu.be/kS0agn13hhU)
- [Written tutorial](https://github.com/FutureProofHomes/wyoming-enhancements/tree/master/snapcast/docs)


## Enhancement 3.1: Bluetooth Presence Detection by Installing Room Assistant on the Wyoming Satellite

Don't have ESP32 hardware but still want to enhance the capability of your Wyoming Voice Satellite so that it can track nearby bluetooth devices (like iPhones, Watches, Androids, etc..)?  Consider installing Room Assistant directly on the Wyoming Satellite Raspberry Pi.

**Voice Command Examples:**
- "Hey Jarvis, which room is my wife in?"

**Prerequisite Hardware/Software:**
- [Wyoming Voice Satellite project](https://github.com/rhasspy/wyoming-satellite)

**Additional Software/Configurations Required:**
- [Room Assistant](https://www.room-assistant.io/guide/quickstart-pi.html#installing-room-assistant)
- [MQTT Misquitto Broker](https://www.home-assistant.io/integrations/mqtt/)

**Pros & Cons**
- Pros: 
    - No ESP32 required.  Runs directly on the Wyoming Satellite Raspberry Pi
    - Works nicely with other ESPresense because Room Assistant also supports [MQTT_Room](https://www.room-assistant.io/integrations/home-assistant.html#settings)
- Cons: 
    - Cannot track Apple Watches via [Bluetooth Low Energy](https://www.room-assistant.io/integrations/bluetooth-low-energy.html#requirements) and will therefore have slower detection times and impact your watch's battery life.
    - Can impact the Raspberry Pi's wifi connection when handling heavy bluetooth throughput.
    - Depending in the device, Room Assistant may require you to install a companion app on your mobile device for ideal tracking.
    - Room Assistant codebase has not been well maintained for a few years now.

**Documentation & Tutorials:**
- [Video Tutorial](https://www.youtube.com/watch?v=R1kxuB4pi9k)
- [Written tutorial](https://github.com/FutureProofHomes/wyoming-enhancements/blob/master/Room%20Assistant/docs/1_install_room_assistant.md)


## Enhancement 3.2: Bluetooth Presence Detection by plugging an ESP32 w/ ESPresense into the Wyoming Satellite.

Have an ESP32 lying around? Install ESPresense on it then plug it in to the Wyoming Voice Satellite's spare USB port like a dongle.  Enjoy the convience of a single power cable and two products that almost/kinda feel like one.

**Voice Command Examples:**
- "Hey Jarvis, make the music follow me around the home."

**Prerequisite Hardware/Software:**
- [Wyoming Voice Satellite project](https://github.com/rhasspy/wyoming-satellite)
- [ESP32 Base Station](https://espresense.com/base-stations)

**Additional Software/Configurations Required:**
- [ESPresense](https://espresense.com/) 
- [MQTT Misquitto Broker](https://www.home-assistant.io/integrations/mqtt/)

**Pros & Cons**
- Pros: 
    - Fast detection times and very configurable
    - Bluetooth Low Energy works with Apple Devices 
    - Very active project and codebase
- Cons: 
    - Requires extra ESP32 hardware and doesn't run directly on the Wyoming Satellite :(

**Documentation & Tutorials:**
- [Video Tutorial](https://www.youtube.com/watch?v=R1kxuB4pi9k)
- [Written tutorial](https://github.com/FutureProofHomes/wyoming-enhancements/blob/master/ESPresense/docs/1_install_espresense.md)
