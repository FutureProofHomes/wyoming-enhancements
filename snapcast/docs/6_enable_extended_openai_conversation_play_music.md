## Enable the LLM to `Play_Music` via Music Assistant.

1. Copy my `play_music` script to your Home Assistant scripts.
```
alias: Play Music
sequence:
 - variables:
     music_query: "{{ music_query | default('Queen') }}"
     mass_media_player: "{{ mass_media_player | default('media_player.loftsatellite') }}"
 - service: mass.search
   data:
     limit: 1
     media_type:
       - playlist
     name: "{{music_query}}"
   response_variable: query_response
 - service: media_player.clear_playlist
   target:
     entity_id: "{{mass_media_player}}"
   data: {}
 - service: mass.play_media
   data:
      media_id: "{{query_response.playlists[0].uri}}"
      entity_id: "{{mass_media_player}}"
      enqueue: replace
mode: single
```

2. (OPTIONAL, USE AT YOUR OWN RISK) Below is a slighly modified `play_music` script that tries to automatically play music back on the voice assistant you last spoke on.  This allows you to say "Play Nirvana" instead of "Play Nirvana in the loft".  There are many other ways to implement a solution, this is just an experiment.
```
alias: Play Music
sequence:
  - variables:
      music_query: "{{ music_query | default('Queen') }}"
      mass_media_player: "{{ mass_media_player | default('media_player.loftsatellite') }}"
      derived_mass_media_player: >
        {% set assist_entities =
        integration_entities('wyoming')|select('contains','_assist_in_progress')|list
        %}

        {% for entity in assist_entities %}
          {% if states(entity) == 'on' %}
            {{ entity.replace('_', '').replace('binarysensor', 'media_player').replace('assistinprogress', '') }}
          {% endif %}
        {% endfor %}
  - service: mass.search
    data:
      limit: 1
      media_type:
        - playlist
      name: "{{music_query}}"
    response_variable: query_response
  - service: media_player.clear_playlist
    target:
      entity_id: "{{mass_media_player or derived_mass_media_player}}"
    data: {}
  - service: mass.play_media
    data:
      media_id: "{{query_response.playlists[0].uri}}"
      entity_id: "{{mass_media_player or derived_mass_media_player}}"
      enqueue: replace
mode: single
```

3. Add my spec to your Extended OpenAI Conversation functions so that the LLM can execute your `play_music` script:
```
- spec:
    name: play_music
    description: Use this function to play music on a certain media_player
    parameters:
      type: object
      properties:
        music_query:
          type: string
          description: The artist, album, or type of music to play
        mass_media_player:
          type: string
          description: The Music Assistant compatible media player's full entity id.  Not a sonos entity.  The correct value starts with "media_player" and usually has the word "satellite" in it.
      required:
      - music_query
  function:
    type: script
    sequence:
    - service: script.play_music
      data:
        music_query: '{{music_query}}'
        mass_media_player: '{{mass_media_player}}'
```

4.  All done!  Now ask your voice assistant to "Play [artist_name, genre_of_music, or_album] in my [room_name]"

NOTE: I recognize there are many more music related scripts to be desired. I invite others to make PRs or share their HA scripts/Extended OpenAI Conversation specs.  Let's also be sure and share our working scripts with the original developers for their documentation.
