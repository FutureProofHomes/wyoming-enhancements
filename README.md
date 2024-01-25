# Wyoming Voice Assistant Enhancements

This repository is dedicated to sharing tutorials that enhance Home Assistant's [Wyoming Voice Satellite project](https://github.com/rhasspy/wyoming-satellite).

## Enhancement 1: Extended OpenAI Conversation Integration

Elevate Home Assistant's voice capabilities by integrating a Large Language Model (LLM) to the conversation agent.  The AI can run locally within your home, or you can pay for OpenAI's cloud-based ChatGPT API. This enhancement helps your voice assistant feel natural while gaining advanced control of your home.

**Voice Command Examples:**
- "Hey Jarvis, turn off the lights, lock the doors, and check if my kids are asleep."
- "Hey Jarvis, who is Bruce Wayne?"

**Prerequisite Hardware/Software:**
- [Wyoming Voice Satellite project](https://github.com/rhasspy/wyoming-satellite)

**Additional Software Required:**
- [Extended OpenAI Conversation](https://github.com/jekalmin/extended_openai_conversation)
- [LocalAI](https://localai.io/) (Optional for local LLM)

**Documentation & Tutorials:**
- [Watch the video tutorial](https://www.youtube.com/watch?v=pAKqKTkx5X4)
- [Recommended LLM Prompt](https://github.com/FutureProofHomes/wyoming-enhancements/blob/main/extended_openai_conversation/recommended_prompt.txt)

## Enhancement 2: Multi-Zone Music Streaming for Wyoming Satellite

Enhance the capabilities of your Wyoming Voice Assistants to unlock multi-room music streaming, akin to Sonos. Enjoy seamless playback of your local music collection, Spotify, Tidal, and more through the speakers connected to your Wyoming Satellites. The system intelligently lowers the music volume when you or the voice assistant are speaking.

**Voice Command Examples:**
- "Hey Jarvis, play Michael Jackson in the loft."

**Prerequisite Hardware/Software:**
- [Wyoming Voice Satellite project](https://github.com/rhasspy/wyoming-satellite)

**Additional Software Required:**
- [Extended OpenAI Conversation](https://github.com/jekalmin/extended_openai_conversation)
- [Snapcast Server](https://github.com/Art-Ev/addon-snapserver)
- [Snapcast Client](https://github.com/badaix/snapcast)
- [PulseAudio](https://www.freedesktop.org/wiki/Software/PulseAudio/)
- [BETA Music Assistant](https://github.com/music-assistant/hass-music-assistant)

**Documentation & Tutorials:**
- Follow the steps outlined [here](https://github.com/FutureProofHomes/wyoming-enhancements/tree/master/snapcast/docs).
- [Watch the video tutorial](https://youtu.be/kS0agn13hhU)
