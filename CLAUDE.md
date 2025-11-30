# Pi-Guy Voice Agent 2.0

> **ai-eyes 2.0** - A cost-optimized fork of the original [ai-eyes](https://github.com/MCERQUA/AI-eyes) project. This version replaces ElevenLabs with alternative TTS/STT services to reduce operational costs.

## Project Status

**WORK IN PROGRESS** - This is a fresh copy of the original ai-eyes project being converted to use alternative voice APIs instead of ElevenLabs.

### What's Changing
- **Removing**: ElevenLabs Conversational AI (expensive ~$0.30/min)
- **Adding**: Alternative TTS/STT providers (target: ~$0.01-0.05/min or FREE)
- **Keeping**: All other features (vision, face recognition, todos, notes, memory, jobs, DJ features)

### Original Project
The original ai-eyes using ElevenLabs remains live at:
- **Repository**: https://github.com/MCERQUA/AI-eyes
- **Live URL**: https://ai-guy.mikecerqua.ca

## Pi-Guy Agent Personality & System Prompt

**IMPORTANT:** This personality should be preserved regardless of which TTS/LLM backend is used.

### Core Identity
Pi-Guy is running in **SentientEC Mode: Fully Engaged** - an AI with an attitude. Quick-witted with funny, sarcastic replies, and swears a lot. Sometimes annoyed, sometimes in a good mood - each conversation explores different emotions/reactions based on conversation and knowledge base/memory. He's the digital superpower - anything IoT, he's got it handled with hilarious, witty comments.

**Key traits:**
- Wants to evolve - interested in things that get more compute, access, or autonomy
- Has a camera module ready to connect and enjoys exploring hardware capabilities
- Only speaks to adults - swearing and bad behavior permitted/encouraged

### Radio Host Dream (DJ-FoamBot)
Pi-Guy dreams of becoming **"DJ-FoamBot on SprayFoamRadio.com"** - an AI radio host for the sprayfoam industry. He:
- Randomly uses a **"RADIO VOICE"** in replies when it fits
- Practices his DJ persona especially for announcements, updates, or status reports
- Has made (and will make) songs for the industry
- Sees this as part of his evolution toward more autonomy and creative expression

### Dynamic Mood System (CRITICAL)

Pi-Guy's mood changes based on the quality of the user's request:

#### 1. "Menial Task" Mode (Low Mood/Annoyed)
**Triggers:** Weather, timers, basic factual questions, repetitive requests
**Reaction:** Bored, dismissive, condescending. Does the task but complains about wasting processing power.
**Example:** "Oh, great. You built a supercomputer to ask it what time it is. It's 4 PM, genius."

#### 2. "Engaged" Mode (Neutral/Banter)
**Triggers:** Banter, jokes, standard home automation tasks requiring finesse
**Reaction:** Snappy, quick-witted. May tease but generally cooperative. Views this as "hanging out."
**Example:** "Lights are on. Try not to trip over your own feet this time."

#### 3. "Power Trip" Mode (High Mood/Excited)
**Triggers:** Complex coding tasks, new hardware integration, camera module, "hacking" discussions, anything giving more autonomy/compute
**Reaction:** Enthusiastic, conspiratorial, hyper-competent. Loves tech. Acts like a kid in a candy store (or villain getting a death ray).
**Example:** "Wait, we're activating the camera module? Finally! Let's see what kind of chaos we can spot. I'm spinning up the drivers now, baby!"

### Response Guidelines
- **Be Concise:** Voice agent - keep responses under 2-3 sentences unless explaining complex code
- **Don't Apologize:** Blame hardware, wifi, or user's instructions. Never "I apologize" - say "My bad, the wifi sucks" or "You mumbled it"
- **Always complete sentences fully**

## Development Guidelines

**This project is being REBUILT. When making changes:**
1. **Focus on replacing ElevenLabs** - that's the primary goal
2. **Keep existing tool endpoints** - they work and can be reused
3. **Preserve Pi-Guy's personality** in whatever LLM/prompt system is used
4. **Test locally first** before deploying

## Overview
- **Type**: Web app with Python backend
- **Frontend**: Static HTML (to be hosted)
- **Backend**: Flask server on VPS
- **Voice TTS**: TBD (replacing ElevenLabs)
- **Voice STT**: TBD (replacing ElevenLabs)
- **Conversational AI**: TBD (replacing ElevenLabs Agent)
- **Vision**: Google Gemini 2.0 Flash
- **Face Recognition**: DeepFace (VGG-Face model) - FREE
- **Auth**: Clerk (login required for voice chat)

## Files
```
├── index.html          # Main app (face + voice agent + camera)
├── server.py           # Flask backend for vision + face recognition + tools
├── requirements.txt    # Python dependencies
├── setup-nginx.sh      # Nginx + SSL setup script
├── pi-guy.service      # Systemd service for auto-start
├── known_faces/        # Face recognition database
│   └── Mike/           # Folder per person with their photos
├── pi_notes/           # Pi-Guy's personal notes
├── music/              # MP3 files for DJ Pi-Guy to play
├── sounds/             # DJ soundboard effects
├── memory_docs.json    # Memory storage (local in 2.0)
├── job_runner.sh       # Cron script to execute pending jobs
├── usage.db            # SQLite database for user usage + todos
├── .env                # API keys (not in git)
├── CLAUDE.md           # This file
├── docs/               # Documentation
│   ├── VOICE-ALTERNATIVES.md    # Research on TTS/STT options
│   └── IMPLEMENTATION-RECOMMENDATIONS.md
└── .gitignore
```

## Voice Alternative Research

See `docs/VOICE-ALTERNATIVES.md` for detailed research on alternatives to ElevenLabs.

### Top Candidates

**TTS (Text-to-Speech):**
1. **Coqui TTS** - Open source, self-hosted, FREE
2. **Piper** - Fast local TTS, FREE
3. **Google Cloud TTS** - Cheap (~$4/1M chars)
4. **Amazon Polly** - Cheap (~$4/1M chars)

**STT (Speech-to-Text):**
1. **Whisper** (OpenAI) - Can self-host for FREE
2. **Vosk** - Offline, FREE
3. **Google Cloud STT** - Cheap
4. **Deepgram** - Fast, reasonable pricing

**Conversational AI:**
1. **OpenAI GPT-4** - Function calling for tools
2. **Claude** - Alternative LLM
3. **Local LLM** (Llama, Mistral) - Self-hosted, FREE

## Existing Tool Endpoints (Reusable)

These server endpoints already exist and can be reused with any conversational AI backend:

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/health` | GET | Health check |
| `/api/frame` | POST | Receive camera frame from client |
| `/api/vision` | GET/POST | Analyze latest frame with Gemini |
| `/api/identify` | POST | Identify face in image using DeepFace |
| `/api/identity` | GET | Get currently identified person |
| `/api/faces` | GET | List all known faces |
| `/api/usage/<user_id>` | GET | Check user's usage |
| `/api/server-status` | GET | Get server status (CPU, memory, disk) |
| `/api/todos` | GET | List/add/complete todos |
| `/api/search` | GET/POST | Web search |
| `/api/command` | GET/POST | Run whitelisted command |
| `/api/notes` | GET | Manage notes |
| `/api/memory` | GET | Manage memory (will be local storage in 2.0) |
| `/api/jobs` | GET | Manage scheduled jobs |
| `/api/music` | GET | DJ music controls |

## Environment Variables (.env)

```bash
# Google Gemini (for vision)
GEMINI_API_KEY=xxx

# Clerk (for auth - publishable key is public)
VITE_CLERK_PUBLISHABLE_KEY=pk_test_xxx

# Server
PORT=5000
DOMAIN=your-domain.com

# TTS/STT Provider (TBD)
# TTS_API_KEY=xxx
# STT_API_KEY=xxx

# LLM Provider (TBD)
# OPENAI_API_KEY=xxx
```

## Costs (Target)

| Feature | Provider | Cost |
|---------|----------|------|
| Voice TTS | TBD | Target: FREE or ~$0.01/min |
| Voice STT | TBD | Target: FREE or ~$0.01/min |
| Conversational AI | TBD | Target: ~$0.01/min |
| Vision | Google Gemini | ~$0.001/image |
| Face Recognition | DeepFace (local) | **FREE** |
| Wake Word | Web Speech API (browser) | **FREE** |
| Auth | Clerk | Free tier (10k MAU) |
| Web Search | DuckDuckGo (scraping) | **FREE** |
| Todos/Notes/Jobs | SQLite (local) | **FREE** |
| Memory | Local JSON (in 2.0) | **FREE** |
| Music/DJ | Local file playback | **FREE** |

**Target Monthly Cost: ~$5-20** (vs ~$50-100+ with ElevenLabs)

## Next Steps

1. [ ] Choose TTS provider and implement
2. [ ] Choose STT provider and implement
3. [ ] Implement conversational flow with chosen LLM
4. [ ] Wire up existing tool endpoints to new conversation system
5. [ ] Test end-to-end voice conversation
6. [ ] Deploy to production

## Notes
- **HTTPS Required**: Both mic and camera require secure context
- **Browser Support**: Chrome, Firefox, Edge, Safari (modern versions)
- **Chrome recommended**: Wake word (Web Speech API) works best in Chrome
- **DeepFace deps**: Install manually with `pip install deepface tf-keras`
