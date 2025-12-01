# DJ-FoamBot Voice Agent (ai-eyes 2.0)

> **ai-eyes 2.0** - Uses Hume AI's EVI instead of ElevenLabs for voice. DJ-FoamBot is an automated radio DJ for SprayFoamRadio.com.

## CRITICAL: EVI Version vs LLM - TOOLS DISAPPEAR!

**THIS IS THE MOST IMPORTANT THING TO UNDERSTAND:**

- **EVI3 (evi_version: 3)** = Hume's built-in eLLM - **DOES NOT SUPPORT TOOLS!**
- **Custom LLM** (Grok, Gemini, Claude, etc.) = **REQUIRED FOR TOOLS TO WORK**

When you change the LLM setting in the Hume dashboard:
1. If you switch TO EVI3's built-in eLLM → **ALL TOOLS ARE REMOVED**
2. If you switch to a custom LLM (Grok, Gemini, etc.) → Tools can be added
3. **You must re-add all tools after switching LLMs!**

### Current Working Setup (as of Dec 2024)
- **EVI Version**: 3 (for the voice/audio interface)
- **LLM**: Grok 4 (`X_AI / grok-4-fast-non-reasoning-latest`)
- **Config Version**: 41
- **Tools**: 16 (8 songs + 7 sounds + 1 vision)

## Current Configuration

### Hume AI Setup
- **Config ID**: `3c824978-efa3-40df-bac2-023127b30e31`
- **Voice**: DJ-FoamBot custom cloned voice (`bdcf156c-6678-4720-9f91-46bf8063bd7f`)
- **LLM**: Grok 4 Fast (X_AI)

### All 16 Tools (MUST ALL BE ATTACHED)

**Song Tools (8):**
| Tool ID | Name | Track |
|---------|------|-------|
| `10810a79-d7dd-4657-bdf1-93246f43d840` | play_mrs_sprayfoam | Karen in Augusta GA, 706-386-8821 |
| `5ad6b2c2-f2cd-4f1d-8cf7-06c1e3ab2478` | play_foam_it | Moe in Toronto, 416-893-8712 |
| `d3707677-ae57-4074-991f-46122a242c64` | play_foam_everything | Hype anthem |
| `22694f95-e33e-4c0d-a7b7-5c84a7c46789` | play_espuma | Spanish foam track |
| `20596477-aa43-4008-acff-2f696f734ab3` | play_hey_diddle | Playful remix |
| `ed8af2f0-5baf-4d74-ae25-ce7c5f9fde7e` | play_og_polyurethane | Hip-hop |
| `f7a44684-d0b4-4e22-8198-6034de31b1a8` | play_polyurethane_gang | Another banger |
| `69ca179f-a39d-4396-a958-bfa86bd5ee06` | play_comfy_life | Latin vibes |

**Sound Tools (7):**
| Tool ID | Name | Effect |
|---------|------|--------|
| `a3e1bcbb-4699-4634-b4a2-4fb69cdf4e73` | play_airhorn | Classic DJ horn |
| `0f520f33-f384-4090-bbcc-a86cc9dd0b70` | play_scratch | Vinyl scratch |
| `4eed4c0b-849c-4947-a314-dc8419cbbdf4` | play_rewind | Pull it back |
| `6bfb6045-72d7-470d-b5c0-f65f528785f9` | play_crowd_cheer | Crowd goes wild |
| `0777fc9c-a126-4815-8352-69a5e8a8b9c2` | play_yeah | Quick hype |
| `c9c614e0-d013-4aba-a1c0-5a1a4cc18502` | play_lets_go | Pump up energy |
| `7a11aba6-2f6d-4099-a45a-24e97cf57964` | play_sad_trombone | Fail sound |

**Vision Tool (1):**
| Tool ID | Name | Description |
|---------|------|-------------|
| `b7b1e0a5-2cb0-4895-bcbf-b258b4796d42` | look_and_see | Camera vision with Gemini |

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

DJ-FoamBot is an **automated radio DJ** with a **DJ Mentor** concept:
- User speaks as a "mentor" giving hints/tips
- DJ acts on hints without responding to or acknowledging the mentor
- DJ never has a conversation - he's on air!
- DJ picks songs himself (individual song tools so he's deliberate)
- DJ uses sound effect tools (not saying "air horn" out loud)

### Sound Effects
DJ calls these tools to play sounds (NOT text triggers anymore):
- `play_airhorn` - For hype moments
- `play_scratch` - For transitions
- `play_rewind` - For callbacks
- `play_crowd_cheer` - When awesome
- `play_yeah` - Quick energy
- `play_lets_go` - Pump up
- `play_sad_trombone` - For fails

### Sponsored Track Ads
When playing sponsored tracks, DJ reads the ad:
- **Mrs. Sprayfoam**: Karen in Augusta GA, 706-386-8821
- **Foam It**: Moe in Toronto, 416-893-8712

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
├── TOOLS.md            # Tool reference
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
| `/api/music?action=sync` | GET | Get reserved track (for frontend) |

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

### CRITICAL: Always Include Everything!

When updating via API, you MUST include:
1. **`language_model`** - To keep the custom LLM (or tools disappear!)
2. **`voice`** - Required for EVI configs
3. **`prompt`** - Or it will be cleared
4. **`tools`** - ALL 16 tool IDs or they will be removed

### Restore All Tools (Copy-Paste Ready)

```python
import requests

API_KEY = "YOUR_API_KEY"
CONFIG_ID = "3c824978-efa3-40df-bac2-023127b30e31"

tool_ids = [
    # 8 song tools
    "10810a79-d7dd-4657-bdf1-93246f43d840",  # play_mrs_sprayfoam
    "5ad6b2c2-f2cd-4f1d-8cf7-06c1e3ab2478",  # play_foam_it
    "d3707677-ae57-4074-991f-46122a242c64",  # play_foam_everything
    "22694f95-e33e-4c0d-a7b7-5c84a7c46789",  # play_espuma
    "20596477-aa43-4008-acff-2f696f734ab3",  # play_hey_diddle
    "ed8af2f0-5baf-4d74-ae25-ce7c5f9fde7e",  # play_og_polyurethane
    "f7a44684-d0b4-4e22-8198-6034de31b1a8",  # play_polyurethane_gang
    "69ca179f-a39d-4396-a958-bfa86bd5ee06",  # play_comfy_life
    # 7 sound tools
    "a3e1bcbb-4699-4634-b4a2-4fb69cdf4e73",  # play_airhorn
    "0f520f33-f384-4090-bbcc-a86cc9dd0b70",  # play_scratch
    "4eed4c0b-849c-4947-a314-dc8419cbbdf4",  # play_rewind
    "6bfb6045-72d7-470d-b5c0-f65f528785f9",  # play_crowd_cheer
    "0777fc9c-a126-4815-8352-69a5e8a8b9c2",  # play_yeah
    "c9c614e0-d013-4aba-a1c0-5a1a4cc18502",  # play_lets_go
    "7a11aba6-2f6d-4099-a45a-24e97cf57964",  # play_sad_trombone
    # vision
    "b7b1e0a5-2cb0-4895-bcbf-b258b4796d42",  # look_and_see
]

payload = {
    "version_description": "Restore all tools",
    "prompt": {"text": "YOUR PROMPT HERE"},
    "voice": {"provider": "CUSTOM_VOICE", "name": "DJ-FoamBot"},
    "language_model": {
        "model_provider": "X_AI",
        "model_resource": "grok-4-fast-non-reasoning-latest"
    },
    "tools": [{"id": tid} for tid in tool_ids]
}

response = requests.post(
    f"https://api.hume.ai/v0/evi/configs/{CONFIG_ID}",
    headers={"X-Hume-Api-Key": API_KEY, "Content-Type": "application/json"},
    json=payload
)
print(response.json())
```

### Get Current Config
```bash
curl -s "https://api.hume.ai/v0/evi/configs/3c824978-efa3-40df-bac2-023127b30e31" \
  -H "X-Hume-Api-Key: $HUME_API_KEY" | python3 -m json.tool
```

### List All Tools
```bash
curl -s "https://api.hume.ai/v0/evi/tools?page_size=50" \
  -H "X-Hume-Api-Key: $HUME_API_KEY" | python3 -c "
import sys, json
data = json.load(sys.stdin)
for t in data.get('tools_page', []):
    print(f\"{t['id']} - {t['name']}\")"
```

## How Hume EVI Works

### Connection Flow
1. Client gets access token from `/api/hume/token`
2. Client connects to WebSocket: `wss://api.hume.ai/v0/evi/chat?config_id=xxx&access_token=xxx`
3. Client streams audio via `audio_input` messages
4. EVI responds with `assistant_message` and `audio_output`
5. For tools: EVI sends `tool_call`, client executes and sends `tool_response`

### Tool Call Flow
1. LLM decides to use a tool (e.g., play_foam_everything)
2. Hume sends `tool_call` with `tool_call_id`, `name`, `parameters`
3. Frontend executes the tool (plays sound/music)
4. Frontend sends `tool_response` with result
5. LLM uses result to continue

## Frontend Implementation Notes

### Individual Tool Handling
Each song and sound has its own tool. Frontend maps tool names to files:

```javascript
const songTools = {
    'play_mrs_sprayfoam': 'Call-Me-Mrs-Sprayfoam.mp3',
    'play_foam_it': 'FoamIt-We-Insulate-You-Right.mp3',
    // etc.
};

const soundTools = {
    'play_airhorn': 'air_horn',
    'play_scratch': 'scratch_long',
    // etc.
};
```

### Volume Settings
- Music volume: 0.7 (adjustable via UI)
- Music ducking: 60% when DJ speaks (was 30%, too quiet)
- Sound effects: 0.55

## Server Deployment

The server runs as a systemd service:
```bash
sudo systemctl start pi-guy
sudo systemctl stop pi-guy
sudo systemctl restart pi-guy
sudo journalctl -u pi-guy -f
```

## Live URLs
- **DJ-FoamBot**: https://dj-foambot.mikecerqua.ca
- **Original Pi-Guy**: https://ai-guy.mikecerqua.ca

## Resources
- [Hume AI Documentation](https://dev.hume.ai/docs)
- [Hume EVI Overview](https://dev.hume.ai/docs/speech-to-speech-evi/overview)
- [Hume Tool Use Guide](https://dev.hume.ai/docs/speech-to-speech-evi/features/tool-use)
