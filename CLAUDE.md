# DJ-FoamBot Voice Agent (ai-eyes 2.0)

> **ai-eyes 2.0** - Uses Hume AI's EVI instead of ElevenLabs for voice. DJ-FoamBot is an automated radio DJ for SprayFoamRadio.com.

## Current Configuration

### Hume AI Setup
- **Config ID**: `3c824978-efa3-40df-bac2-023127b30e31` (version 16)
- **Voice**: DJ-FoamBot custom cloned voice (`bdcf156c-6678-4720-9f91-46bf8063bd7f`)
- **LLM**: Claude Sonnet 4 (via Hume)

### Tools Attached to Config
| Tool ID | Name | Description |
|---------|------|-------------|
| `791378df-6c3a-4d52-966c-96e5c3f78981` | play_music | Control music playback (play, pause, skip, volume) |
| `46645424-1257-4bd0-8fde-e8ed6cd87edb` | dj_soundboard | Play DJ sound effects (air horn, scratch, etc.) |
| `b7b1e0a5-2cb0-4895-bcbf-b258b4796d42` | look_and_see | Use camera to see |

### Track Library (8 tracks)
1. "Call Me Mrs. Sprayfoam" (2:50) - Phone: 706-386-8821
2. "Espuma y Calidez 2" (4:05) - Spanish foam track
3. "Foam Everything" (1:40) - Hype anthem
4. "Foam It - We Insulate You Right" (1:40) - Phone: 416-893-8712
5. "Hey Diddle Diddle" (2:44) - Playful remix
6. "OG Polyurethane Gang" (1:08) - Hip-hop
7. "Polyurethane Gang" (1:07) - Another banger
8. "Comfy Life (Spanish Version)" (4:05) - Latin vibes

## DJ-FoamBot Behavior

DJ-FoamBot is an **automated radio DJ** that:
1. Starts playing music immediately when connected (no waiting for requests)
2. Quick intro with sound effects, then plays a track
3. Stays silent during songs (the music is the star)
4. Drops quick sound effects + one-liners every 20-30 seconds
5. Transitions between songs automatically

### Sound Effects (text triggers)
When DJ-FoamBot says these words, the frontend plays sounds:
- "air horn" / "airhorn" - Classic DJ horn
- "scratch" - Vinyl scratch
- "rewind" / "pull up" - Rewind sound
- "crowd cheer" / "applause" - Crowd sounds
- "yeah" / "lets go" - Hype sounds
- "bruh" / "sad trombone" - Comedy sounds

### Catchphrases
- "This is DJ-FoamBot, keeping it SEALED!"
- "Spray it, don't say it!"
- "R-value approved!"
- "Foam on, foam strong!"

## Files

```
├── index.html          # Main DJ-FoamBot interface (Hume EVI)
├── server.py           # Flask backend (vision, music, sounds)
├── requirements.txt    # Python dependencies
├── music/              # MP3 files for DJ playback
│   └── music_metadata.json  # Track info (duration, phone, ad copy)
├── sounds/             # DJ soundboard effects
├── known_faces/        # Face recognition database
├── pi_notes/           # Personal notes storage
├── usage.db            # SQLite database
├── .env                # API keys (not in git)
├── CLAUDE.md           # This file
└── README.md           # Project overview
```

## Environment Variables (.env)

```bash
# Hume.ai Configuration
HUME_API_KEY=xxx
HUME_SECRET_KEY=xxx
HUME_CONFIG_ID=3c824978-efa3-40df-bac2-023127b30e31
HUME_VOICE_ID=bdcf156c-6678-4720-9f91-46bf8063bd7f
HUME_VOICE_NAME=DJ-FoamBot

# Hume Tool IDs
HUME_TOOL_PLAY_MUSIC=791378df-6c3a-4d52-966c-96e5c3f78981
HUME_TOOL_DJ_SOUNDBOARD=46645424-1257-4bd0-8fde-e8ed6cd87edb
HUME_TOOL_LOOK_AND_SEE=b7b1e0a5-2cb0-4895-bcbf-b258b4796d42

# Google Gemini (for vision)
GEMINI_API_KEY=xxx

# Clerk (for auth)
VITE_CLERK_PUBLISHABLE_KEY=pk_test_xxx

# Server
PORT=5001
DOMAIN=dj-foambot.mikecerqua.ca
```

## API Endpoints

### Music Control
| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/music?action=list` | GET | List all tracks with metadata |
| `/api/music?action=play` | GET | Play random track |
| `/api/music?action=play&track=Name` | GET | Play specific track |
| `/api/music?action=pause` | GET | Pause playback |
| `/api/music?action=skip` | GET | Skip to next track |
| `/api/music?action=volume&volume=50` | GET | Set volume (0-100) |
| `/api/music?action=status` | GET | What's currently playing |
| `/api/music?action=sync` | GET | Get reserved track (for frontend text detection) |

### Other Endpoints
| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/health` | GET | Health check |
| `/api/hume/token` | GET | Get Hume access token for WebSocket |
| `/api/vision` | GET | Analyze camera frame with Gemini |
| `/api/dj-sound?sound=air_horn` | GET | Get sound file URL |
| `/sounds/<filename>` | GET | Serve sound files |
| `/music/<filename>` | GET | Serve music files |

## Updating Hume Config

### Get Current Config
```bash
curl -s "https://api.hume.ai/v0/evi/configs/3c824978-efa3-40df-bac2-023127b30e31" \
  -H "X-Hume-Api-Key: $HUME_API_KEY" | python3 -m json.tool
```

### Create New Config Version
```bash
curl -X POST "https://api.hume.ai/v0/evi/configs/3c824978-efa3-40df-bac2-023127b30e31" \
  -H "X-Hume-Api-Key: $HUME_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "version_description": "Description of changes",
    "voice": {
      "provider": "CUSTOM_VOICE",
      "name": "DJ-FoamBot"
    },
    "prompt": {
      "text": "Your prompt text here"
    },
    "tools": [
      {"id": "791378df-6c3a-4d52-966c-96e5c3f78981", "version": 0},
      {"id": "46645424-1257-4bd0-8fde-e8ed6cd87edb", "version": 0},
      {"id": "b7b1e0a5-2cb0-4895-bcbf-b258b4796d42", "version": 0}
    ]
  }'
```

**IMPORTANT**: When updating the config, you MUST include:
- `voice` - Required for EVI3 configs
- `prompt` - Or it will be cleared
- `tools` - Or they will be removed

### List All Tools
```bash
curl -s "https://api.hume.ai/v0/evi/tools" \
  -H "X-Hume-Api-Key: $HUME_API_KEY" | python3 -m json.tool
```

## How Hume EVI Works

### Connection Flow
1. Client gets access token from `/api/hume/token`
2. Client connects to WebSocket: `wss://api.hume.ai/v0/evi/chat?config_id=xxx&access_token=xxx`
3. Client streams audio via `audio_input` messages
4. EVI responds with `assistant_message` and `audio_output`
5. For tools: EVI sends `tool_call`, client executes and sends `tool_response`

### Tool Call Flow
1. EVI decides to use a tool (e.g., play_music)
2. Sends `tool_call` with `tool_call_id`, `name`, `parameters`
3. Frontend executes the tool (calls server API)
4. Frontend sends `tool_response` with result
5. EVI uses result to generate response

## Frontend Implementation Notes

### Music Playback (Text Detection)
Music is triggered by text detection in the frontend, not directly by tool responses:
- When DJ-FoamBot says keywords like "spinning", "playing", "next up", etc.
- Frontend calls `/api/music?action=sync` to get the reserved track
- This ensures the announced track matches what actually plays

### Sound Effects (Text Detection)
Sounds play when DJ-FoamBot speaks trigger words:
```javascript
const soundTriggers = {
    'air horn': 'air_horn',
    'airhorn': 'air_horn',
    'scratch': 'scratch_long',
    'rewind': 'rewind',
    // etc.
};
```

### Volume Settings
- Music volume: 0.7 (adjustable via UI)
- Sound effects volume: 0.55 (so voice is still audible)
- Volume ducking: Music lowers when DJ speaks

## Server Deployment

The server runs as a systemd service:
```bash
# Start/stop/restart
sudo systemctl start pi-guy
sudo systemctl stop pi-guy
sudo systemctl restart pi-guy

# View logs
sudo journalctl -u pi-guy -f
```

## Live URLs
- **DJ-FoamBot (Hume)**: https://dj-foambot.mikecerqua.ca
- **Original Pi-Guy (ElevenLabs)**: https://ai-guy.mikecerqua.ca

## Costs (Estimated)

| Feature | Provider | Cost |
|---------|----------|------|
| Voice (TTS+STT+LLM) | Hume AI EVI | ~$0.05-0.10/min |
| Vision | Google Gemini | ~$0.001/image |
| Music/Sounds | Local files | FREE |

## Resources

- [Hume AI Documentation](https://dev.hume.ai/docs)
- [Hume EVI Overview](https://dev.hume.ai/docs/speech-to-speech-evi/overview)
- [Hume Tool Use Guide](https://dev.hume.ai/docs/speech-to-speech-evi/features/tool-use)
