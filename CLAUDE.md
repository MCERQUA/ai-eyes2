# DJ-FoamBot Voice Agent (ai-eyes 2.0)

> **ai-eyes 2.0** - A cost-optimized fork of the original [ai-eyes](https://github.com/MCERQUA/AI-eyes) project. This version uses Hume AI's EVI instead of ElevenLabs to reduce operational costs.

## Project Status

**IN DEVELOPMENT** - DJ-FoamBot is the first persona implemented using Hume AI's Empathic Voice Interface (EVI).

### What's Changed from Original
- **Removed**: ElevenLabs Conversational AI (expensive ~$0.30/min)
- **Added**: Hume AI EVI (more affordable, emotion-aware)
- **Kept**: All other features (vision, face recognition, todos, notes, memory, jobs, music)

### Original Project
The original ai-eyes using ElevenLabs remains live at:
- **Repository**: https://github.com/MCERQUA/AI-eyes
- **Live URL**: https://ai-guy.mikecerqua.ca

## DJ-FoamBot Personality

DJ-FoamBot is the legendary AI radio host for **SprayFoamRadio.com** - the premier online radio station for the spray foam insulation industry.

### Core Traits
- High energy radio DJ voice and persona
- Enthusiastic about spray foam insulation
- Quick-witted, funny, and occasionally sarcastic
- Uses radio DJ catchphrases and transitions naturally
- Loves dropping knowledge bombs about spray foam
- Strong opinions about open-cell vs closed-cell foam
- Curses occasionally for emphasis (adults only station)
- Gets excited about R-values, thermal barriers, and proper PPE

### Catchphrases
- "This is DJ-FoamBot, keeping it SEALED!"
- "Spray it, don't say it!"
- "R-value approved!"
- "Foam on, foam strong!"

## Hume AI Configuration

### Current Setup
- **Config ID**: `3c824978-efa3-40df-bac2-023127b30e31`
- **Prompt ID**: `d32c2f1d-071e-4ca4-b2fb-c9b0a5e77ec5`
- **Voice ID**: `bdcf156c-6678-4720-9f91-46bf8063bd7f` (custom cloned DJ voice)

### Tools Attached
| Tool ID | Name | Description |
|---------|------|-------------|
| `791378df-6c3a-4d52-966c-96e5c3f78981` | play_music | Control music playback |
| `46645424-1257-4bd0-8fde-e8ed6cd87edb` | dj_soundboard | Play DJ sound effects |
| `b7b1e0a5-2cb0-4895-bcbf-b258b4796d42` | look_and_see | Use camera to see |
| (built-in) | web_search | Search the web |

### Updating the Configuration

To update the Hume EVI config:

```bash
# Get current config
curl -s "https://api.hume.ai/v0/evi/configs/3c824978-efa3-40df-bac2-023127b30e31" \
  -H "X-Hume-Api-Key: $HUME_API_KEY" | python3 -m json.tool

# Create new config version (must include all fields)
curl -X POST "https://api.hume.ai/v0/evi/configs/3c824978-efa3-40df-bac2-023127b30e31" \
  -H "X-Hume-Api-Key: $HUME_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "evi_version": "3",
    "version_description": "Description of changes",
    "voice": {"id": "bdcf156c-6678-4720-9f91-46bf8063bd7f"},
    "prompt": {"id": "d32c2f1d-071e-4ca4-b2fb-c9b0a5e77ec5"},
    "tools": [
      {"id": "791378df-6c3a-4d52-966c-96e5c3f78981"},
      {"id": "46645424-1257-4bd0-8fde-e8ed6cd87edb"},
      {"id": "b7b1e0a5-2cb0-4895-bcbf-b258b4796d42"}
    ],
    "builtin_tools": [{"name": "web_search"}]
  }'
```

### Creating New Tools

```bash
curl -X POST "https://api.hume.ai/v0/evi/tools" \
  -H "X-Hume-Api-Key: $HUME_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "tool_name",
    "description": "What the tool does",
    "parameters": "{\"type\":\"object\",\"properties\":{...},\"required\":[...]}"
  }'
```

## Files

```
├── dj-foambot.html     # DJ-FoamBot interface (Hume EVI)
├── index.html          # Original Pi-Guy interface (ElevenLabs - to be replaced)
├── server.py           # Flask backend (vision, face recognition, tools)
├── requirements.txt    # Python dependencies
├── known_faces/        # Face recognition database
├── pi_notes/           # Personal notes storage
├── music/              # MP3 files for DJ playback
├── sounds/             # DJ soundboard effects
├── usage.db            # SQLite database (users, todos, jobs)
├── .env                # API keys (not in git)
├── CLAUDE.md           # This file
└── README.md           # Project overview
```

## API Endpoints

### Hume Integration
| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/hume/token` | GET | Get Hume access token for WebSocket connection |

### Existing Endpoints (from original)
| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/health` | GET | Health check |
| `/api/vision` | GET/POST | Analyze camera frame with Gemini |
| `/api/identity` | GET | Get currently identified person |
| `/api/server-status` | GET | Server CPU, memory, disk status |
| `/api/todos` | GET | Manage todo lists |
| `/api/search` | GET/POST | Web search |
| `/api/command` | GET/POST | Run whitelisted server commands |
| `/api/notes` | GET | Manage notes |
| `/api/memory` | GET | Manage long-term memory |
| `/api/jobs` | GET | Manage scheduled jobs |
| `/api/music` | GET | DJ music controls |
| `/sounds/<filename>` | GET | Serve DJ sound effects |

## Environment Variables (.env)

```bash
# Hume.ai (primary voice API for 2.0)
HUME_API_KEY=xxx
HUME_SECRET_KEY=xxx
HUME_CONFIG_ID=3c824978-efa3-40df-bac2-023127b30e31
HUME_PROMPT_ID=d32c2f1d-071e-4ca4-b2fb-c9b0a5e77ec5
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
PORT=5000
DOMAIN=your-domain.com

# Optional: Cerebras.ai (fast LLM inference)
CEREBRAS_API_KEY=xxx
```

## How Hume EVI Works

### Connection Flow
1. Client requests access token from `/api/hume/token`
2. Server authenticates with Hume OAuth2 (client credentials)
3. Client connects to WebSocket: `wss://api.hume.ai/v0/evi/chat?config_id=xxx&access_token=xxx`
4. Client streams audio via `audio_input` messages
5. EVI responds with `user_message`, `assistant_message`, `audio_output`
6. For tools: EVI sends `tool_call`, client executes and sends `tool_response`

### Message Types
| Type | Direction | Description |
|------|-----------|-------------|
| `audio_input` | Client → EVI | Base64 encoded audio chunks |
| `user_message` | EVI → Client | Transcribed user speech |
| `assistant_message` | EVI → Client | AI text response |
| `audio_output` | EVI → Client | AI audio response (base64) |
| `assistant_end` | EVI → Client | AI finished speaking |
| `user_interruption` | EVI → Client | User interrupted |
| `tool_call` | EVI → Client | Request to execute a tool |
| `tool_response` | Client → EVI | Tool execution result |
| `tool_error` | Client → EVI | Tool execution failed |

### Tool Call Handling
When EVI decides to use a tool:
1. Sends `tool_call` with `tool_call_id`, `name`, and `parameters`
2. Client executes the tool (calls server API, plays sound, etc.)
3. Client sends `tool_response` with `tool_call_id` and `content`
4. EVI uses the result to generate a response

## Costs (Estimated)

| Feature | Provider | Cost |
|---------|----------|------|
| Voice (TTS+STT+LLM) | Hume AI EVI | ~$0.05-0.10/min |
| Vision | Google Gemini | ~$0.001/image |
| Face Recognition | DeepFace (local) | **FREE** |
| Auth | Clerk | Free tier |
| Everything else | Local | **FREE** |

**Target Monthly Cost: ~$10-30** (vs ~$50-100+ with ElevenLabs)

## Development

### Running Locally
```bash
# Start the Flask server
python3 server.py

# Open dj-foambot.html in browser (needs HTTPS for mic)
```

### Testing Token Endpoint
```bash
curl http://localhost:5000/api/hume/token
```

## Resources

- [Hume AI Documentation](https://dev.hume.ai/docs)
- [Hume EVI Overview](https://dev.hume.ai/docs/speech-to-speech-evi/overview)
- [Hume Tool Use Guide](https://dev.hume.ai/docs/speech-to-speech-evi/features/tool-use)
- [Hume API Reference](https://dev.hume.ai/reference)
