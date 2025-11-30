# Pi-Guy Voice Agent 2.0

> **This is ai-eyes 2.0** - A cost-optimized fork of the original [ai-eyes](https://github.com/MCERQUA/AI-eyes) project. This version replaces ElevenLabs with alternative TTS/STT services to reduce operational costs while maintaining the same functionality.

An interactive AI voice agent with an animated sci-fi face. Pi-Guy can see through your camera, recognize faces, manage todos, search the web, run server commands, take notes, remember things permanently, and schedule jobs.

![Pi-Guy](https://img.shields.io/badge/Pi--Guy-AI%20Voice%20Agent%202.0-blue)
![Cost Optimized](https://img.shields.io/badge/Cost-Optimized-green)
![License](https://img.shields.io/badge/License-MIT-green)

## What's Different in 2.0?

| Feature | Original (ai-eyes) | 2.0 (ai-eyes2) |
|---------|-------------------|----------------|
| Voice TTS | ElevenLabs (~$0.30/min) | TBD - Alternative API |
| Voice STT | ElevenLabs | TBD - Alternative API |
| Conversational AI | ElevenLabs Agent | TBD - Self-hosted/Alternative |
| Vision | Google Gemini | Google Gemini (unchanged) |
| Face Recognition | DeepFace (FREE) | DeepFace (FREE) |
| Authentication | Clerk | Clerk (unchanged) |

### Goals
- **Reduce costs** - Replace expensive ElevenLabs API with cheaper/free alternatives
- **Maintain functionality** - Keep all the same features (vision, face recognition, todos, etc.)
- **Same personality** - Pi-Guy keeps his sarcastic, witty character
- **Self-hosted options** - Explore local TTS/STT models where possible

## Original Project

The original ai-eyes project using ElevenLabs is still running live at:
- **Repository**: https://github.com/MCERQUA/AI-eyes
- **Live**: https://ai-guy.mikecerqua.ca (original version)

This 2.0 version will run on its own infrastructure once complete.

## Features

- **Voice Conversations** - Natural voice chat (TTS/STT provider TBD)
- **Animated Face** - Sci-fi inspired face with blinking eyes, expressions, and waveform mouth
- **Vision** - Camera integration with Google Gemini for image analysis
- **Face Recognition** - Identifies people using DeepFace (runs locally, FREE)
- **Wake Word** - Hands-free activation with "Pi Guy" or "Hey AI"
- **Todo Lists** - Per-user task management via face recognition
- **Web Search** - DuckDuckGo search integration (FREE)
- **Server Commands** - Run whitelisted system commands
- **Notes System** - Personal note-taking for the AI
- **Long-term Memory** - Persistent memory storage
- **Job Scheduling** - Schedule one-time or recurring tasks (cron-style)
- **User Authentication** - Clerk integration with usage limits

## Status

**Work in Progress** - Currently evaluating alternative voice APIs:
- [ ] Evaluate TTS options (Coqui, Piper, Google Cloud TTS, etc.)
- [ ] Evaluate STT options (Whisper, Vosk, Google Cloud STT, etc.)
- [ ] Implement conversational flow without ElevenLabs Agent
- [ ] Test and integrate chosen solutions
- [ ] Deploy to production

## Architecture (Planned)

```
┌─────────────────────────────────────────────────────────────────┐
│                         Browser (Client)                         │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐              │
│  │ Animated    │  │ Voice Agent │  │ Camera      │              │
│  │ Face (CSS)  │  │ (New TTS)   │  │ (WebRTC)    │              │
│  └─────────────┘  └──────┬──────┘  └──────┬──────┘              │
└──────────────────────────┼────────────────┼─────────────────────┘
                           │                │
                      WebSocket        HTTP POST
                           │                │
┌──────────────────────────┴────────────────┴─────────────────────┐
│                      VPS Server (Flask)                          │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐              │
│  │ TTS Engine  │  │ STT Engine  │  │ LLM/Chat    │              │
│  │ (TBD)       │  │ (TBD)       │  │ (TBD)       │              │
│  └─────────────┘  └─────────────┘  └─────────────┘              │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐              │
│  │ Vision API  │  │ Face Recog  │  │ Jobs/Cron   │              │
│  │ (Gemini)    │  │ (DeepFace)  │  │ Scheduler   │              │
│  └─────────────┘  └─────────────┘  └─────────────┘              │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐              │
│  │ Todos       │  │ Notes       │  │ Memory      │              │
│  │ (SQLite)    │  │ (Files)     │  │ (Local)     │              │
│  └─────────────┘  └─────────────┘  └─────────────┘              │
└─────────────────────────────────────────────────────────────────┘
```

## Prerequisites

- **VPS/Server** with:
  - Ubuntu 20.04+ (or similar Linux)
  - Python 3.8+
  - nginx
  - Domain name with SSL (Let's Encrypt)
- **API Keys**:
  - [Google Gemini](https://makersuite.google.com/app/apikey) - Vision (paid, per-call)
  - [Clerk](https://clerk.com) - Authentication (free tier available)
  - TTS/STT provider API keys (TBD)

## Cost Comparison (Estimated)

| Feature | Original Cost | 2.0 Target |
|---------|--------------|------------|
| Voice (per minute) | ~$0.30 (ElevenLabs) | ~$0.01-0.05 or FREE |
| Vision (per image) | ~$0.001 (Gemini) | ~$0.001 (unchanged) |
| Face Recognition | FREE | FREE |
| Authentication | FREE | FREE |
| **Monthly estimate** | ~$50-100+ | ~$5-20 |

## Development

This project is being actively developed. Check the `docs/` folder for:
- `VOICE-ALTERNATIVES.md` - Research on TTS/STT alternatives
- `IMPLEMENTATION-RECOMMENDATIONS.md` - Implementation plans

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## License

MIT License - See [LICENSE](LICENSE) for details.

## Credits

- Original [ai-eyes](https://github.com/MCERQUA/AI-eyes) project
- [Google Gemini](https://deepmind.google/technologies/gemini/) - Vision AI
- [DeepFace](https://github.com/serengil/deepface) - Face recognition
- [Clerk](https://clerk.com) - Authentication

---

**Note**: This is version 2.0, a cost-optimized fork. The original ElevenLabs-powered version remains at [MCERQUA/AI-eyes](https://github.com/MCERQUA/AI-eyes).
