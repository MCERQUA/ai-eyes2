# DJ-FoamBot - SprayFoam Radio AI DJ

> **ai-eyes 2.0** - Now powered by **Hume AI** for voice conversations. The legendary AI radio host for SprayFoamRadio.com!

An AI DJ with an animated face, powered by Hume EVI (Empathic Voice Interface) with Gemini Vision capabilities.

![DJ-FoamBot](https://img.shields.io/badge/DJ--FoamBot-SprayFoam%20Radio-blue)
![Hume AI](https://img.shields.io/badge/Voice-Hume%20AI-purple)
![License](https://img.shields.io/badge/License-MIT-green)

## What is DJ-FoamBot?

DJ-FoamBot is an automated radio DJ for the spray foam insulation industry. He:
- Plays music continuously without prompting
- Makes DJ announcements with sound effects
- Has a custom cloned voice
- Uses tools to control music playback and see through the camera

## Technology Stack

| Feature | Provider |
|---------|----------|
| Voice/Conversation | **Hume AI EVI v3** |
| Voice Cloning | Hume AI Custom Voice |
| Vision | Google Gemini 2.0 Flash |
| Sound Effects | Browser-based text detection |
| Authentication | Clerk |

## Features

- **Animated Face** - Sci-fi inspired face with blinking eyes and expressions
- **Custom Voice** - Cloned DJ voice using Hume AI
- **Music Player** - 8 spray foam industry tracks
- **DJ Soundboard** - Air horns, scratches, crowd cheers, and more
- **Vision** - Camera integration with Gemini Vision API
- **Wake Word** - Hands-free activation

## Track Library

1. "Call Me Mrs. Sprayfoam" (2:50) - Phone: 706-386-8821
2. "Espuma y Calidez 2" (4:05) - Spanish foam track
3. "Foam Everything" (1:40) - Hype anthem
4. "Foam It - We Insulate You Right" (1:40) - Phone: 416-893-8712
5. "Hey Diddle Diddle" (2:44) - Playful remix
6. "OG Polyurethane Gang" (1:08) - Hip-hop
7. "Polyurethane Gang" (1:07) - Another banger
8. "Comfy Life (Spanish Version)" (4:05) - Latin vibes

## Configuration

### Hume AI Setup

```
Config ID: 3c824978-efa3-40df-bac2-023127b30e31
Voice: DJ-FoamBot (Custom Cloned)
Tools:
  - play_music: Control music playback
  - dj_soundboard: DJ sound effects
  - look_and_see: Camera vision
```

### Environment Variables

```bash
# Hume.ai Configuration
HUME_API_KEY=your_api_key
HUME_SECRET_KEY=your_secret_key
HUME_CONFIG_ID=3c824978-efa3-40df-bac2-023127b30e31
HUME_VOICE_ID=bdcf156c-6678-4720-9f91-46bf8063bd7f

# Google Gemini (Vision)
GEMINI_API_KEY=your_gemini_key

# Clerk (Auth)
VITE_CLERK_PUBLISHABLE_KEY=pk_test_xxx
```

## Files

```
├── index.html          # Main app (face + voice + camera)
├── server.py           # Flask backend for vision + music API
├── music/              # MP3 tracks for DJ playback
├── sounds/             # DJ soundboard effects
├── CLAUDE.md           # Development instructions
├── TOOLS.md            # Tool reference (Hume AI)
└── .env                # API keys (not in git)
```

## Development

### Running Locally

1. Set up environment variables in `.env`
2. Start the server: `python3 server.py`
3. Open `index.html` in browser

### Updating the Hume Config

```bash
# Get current config
curl -s "https://api.hume.ai/v0/evi/configs/$HUME_CONFIG_ID" \
  -H "X-Hume-Api-Key: $HUME_API_KEY"

# Create new version
curl -X POST "https://api.hume.ai/v0/evi/configs/$HUME_CONFIG_ID" \
  -H "X-Hume-Api-Key: $HUME_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "version_description": "Description of changes",
    "prompt": {"text": "New prompt text"},
    "voice": {"provider": "CUSTOM_VOICE", "name": "DJ-FoamBot"},
    "tools": [
      {"id": "tool-id-1"},
      {"id": "tool-id-2"}
    ]
  }'
```

## Sound Effects

Say these words and sounds play automatically:
- `air horn` - Classic DJ horn
- `scratch` - Vinyl scratching
- `rewind` - Pull it back
- `crowd cheer` - Crowd goes wild
- `yeah` / `lets go` - Hype vocals
- `bruh` / `sad trombone` - Fails

## Credits

- [Hume AI](https://hume.ai) - Empathic Voice Interface
- [Google Gemini](https://deepmind.google/technologies/gemini/) - Vision AI
- [Clerk](https://clerk.com) - Authentication

---

**Live at**: https://dj-foambot.mikecerqua.ca
