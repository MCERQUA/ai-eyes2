# Pi-Guy Voice Agent

An interactive voice agent with an animated sci-fi face, powered by ElevenLabs Conversational AI.

## Overview
- **Type**: Static web app (pure HTML/CSS/JS)
- **Hosting**: GitHub Pages, Netlify, or Vercel
- **Voice**: ElevenLabs Conversational AI

## Files
```
├── index.html          # Main app (face + voice agent)
├── CLAUDE.md           # This file
└── .gitignore
```

## Features

### Animated Face
- **Eyes** that follow cursor movement
- **Realistic blinking** with random intervals
- **Expressions**: neutral, happy, sad, angry, thinking, surprised, listening
- **Waveform mouth** - animates when agent is speaking
- **Idle behavior** - eyes look around when inactive

### Voice Agent
- **Push-to-talk style**: Click phone button to start/end conversation
- **Real-time transcription**: Shows what you and the agent say
- **Status indicators**: Connecting, connected, listening, speaking
- **Browser mic access**: Uses Web Audio API

## Setup

### 1. Create an ElevenLabs Agent
1. Go to [elevenlabs.io/conversational-ai](https://elevenlabs.io/conversational-ai)
2. Create a new agent
3. Configure the agent's voice, personality, and knowledge base
4. Copy the **Agent ID**

### 2. Deploy the Site
**GitHub Pages:**
```bash
# Push to GitHub, then enable Pages in repo settings
```

**Netlify/Vercel:**
```bash
# Connect repo and deploy - no build step needed
```

### 3. Use the App
1. Open the deployed site
2. Enter your Agent ID when prompted (saved to localStorage)
3. Click the phone button to start a conversation
4. Speak to the agent - the face will react!

## Face API (JavaScript)

Control the face programmatically from the browser console:

```javascript
// Set mood
piGuy.setMood('happy')    // happy, sad, angry, thinking, surprised, listening, neutral

// Trigger blink
piGuy.blink()

// Change agent ID
piGuy.setAgentId('your-new-agent-id')

// Get current conversation
piGuy.getConversation()
```

## Keyboard Shortcuts
- **Space** or **Enter**: Start/stop conversation
- **Escape**: End conversation

## How It Works

1. **ElevenLabs SDK**: Loaded from CDN (`@11labs/client`)
2. **WebSocket Connection**: Real-time audio streaming
3. **Browser Microphone**: Captures user speech
4. **Mode Events**: Agent switches between listening/speaking modes
5. **Transcription**: Messages displayed as they're processed

## Customization

### Colors
Edit `:root` CSS variables in `index.html`:
```css
--blue: #0088ff;
--cyan: #00ffff;
--green: #00ff66;
--dark-bg: #050508;
```

### Face Size
Adjust `.eye` dimensions and `.eyes-container` gap.

### Agent Behavior
Configure in ElevenLabs dashboard:
- Voice selection
- System prompt / personality
- Knowledge base
- Response settings

## Notes
- **HTTPS Required**: Microphone access requires secure context
- **Browser Support**: Chrome, Firefox, Edge, Safari (modern versions)
- **No Backend**: Everything runs client-side
- **Agent ID Storage**: Saved in browser localStorage
