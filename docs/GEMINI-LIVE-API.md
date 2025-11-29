# Gemini Live API - Real-Time Video & Audio Streaming

**Research Date:** November 2025

## Overview

The Gemini Live API is Google's new real-time multimodal streaming API that enables low-latency, bidirectional voice and video interactions with Gemini models. Unlike the standard Gemini API (which we currently use for single-frame vision analysis), the Live API maintains a persistent WebSocket connection for continuous streaming.

**Key Difference from Current Implementation:**
- **Current (Gemini 2.0 Flash)**: Single image analysis per API call, ~2-3 second latency
- **Live API**: Continuous video stream at 1 FPS, real-time audio in/out, sub-second latency

## Key Features

### Real-Time Multimodal Understanding
- Continuous streams of audio, video, and text
- Process video at **1 frame per second (1 FPS)**
- Low-latency responses with natural conversation flow
- Voice Activity Detection (VAD) for natural interruptions

### Supported Modalities
| Input | Output |
|-------|--------|
| Audio (16-bit PCM, 16kHz mono) | Audio (24kHz mono) |
| Video (base64 JPEG, 1024x1024) | Text |
| Text | Function calls |
| Screen share | |

### Language Support
- 30+ languages supported
- Multiple voice options available

## Technical Specifications

### WebSocket Endpoint
```
wss://generativelanguage.googleapis.com/ws/google.ai.generativelanguage.v1beta.GenerativeService.BidiGenerateContent
```

### Supported Models
- `gemini-2.5-flash-preview-native-audio-dialog` (recommended)
- `gemini-2.0-flash-live-001` (being deprecated)
- `gemini-live-2.5-flash-preview`

### Session Limits
| Limit | Value |
|-------|-------|
| Audio-only session | 15 minutes max |
| Audio + Video session | **2 minutes max** |
| Concurrent sessions per API key | 3 |
| Tokens per minute | 4M |
| Default session length | 10 minutes |

### Video Specifications
- **Format**: Base64 encoded JPEG (RGB)
- **Resolution**: 1024x1024 recommended
- **Frame rate**: Processed at 1 FPS (regardless of send rate)
- **Token rate**: ~258 tokens per second of video

### Audio Specifications
- **Input**: 16-bit PCM, 16kHz sample rate, mono
- **Output**: 24kHz sample rate, mono
- **Token rate**: ~25 tokens per second (both directions)

## Pricing (as of Nov 2025)

### Per-Token Pricing (gemini-2.0-flash-live-001)
| Type | Input | Output |
|------|-------|--------|
| Text | $0.35/1M tokens | $1.50/1M tokens |
| Audio/Image/Video | $2.10/1M tokens | $8.50/1M tokens |

### Session-Based Costs
- **Session setup**: $0.005 per session
- **Active time**: $0.025 per minute of conversation

### Important Billing Notes
- With Proactive Audio Mode enabled, input tokens charged while listening
- Session context window tokens are re-processed each turn
- Text transcription tokens charged at text output rate

## Implementation Approaches

### 1. Server-to-Server (Recommended for Production)
```
Client <---> Your Backend <--WebSocket--> Gemini Live API
```
- More control over data flow
- Better security (API key stays server-side)
- Can integrate with existing infrastructure

### 2. Client-to-Server (Better Performance)
```
Client <--WebSocket--> Gemini Live API
```
- Lower latency (bypasses backend)
- Requires ephemeral tokens for security
- Better for real-time streaming

### 3. Third-Party Integrations
- **Daily**: WebRTC integration
- **LiveKit**: Real-time communication platform
- **Voximplant**: Voice/video platform

## Message Flow

### Connection Setup
1. Connect to WebSocket endpoint
2. Send `BidiGenerateContentSetup` with config
3. Wait for `setupComplete` acknowledgment
4. Begin streaming audio/video

### Client Messages
- `BidiGenerateContentSetup` - Initial configuration
- `BidiGenerateContentClientContent` - Conversation updates
- `BidiGenerateContentRealtimeInput` - Real-time audio/video streams
- `BidiGenerateContentToolResponse` - Function call responses

### Server Messages
- `setupComplete` - Ready to receive streams
- `serverContent` - Model responses (text/audio)
- `toolCall` - Function execution requests
- `goAway` - Session ending

## Python Example (Basic)

```python
import asyncio
import websockets
import json
import base64

GEMINI_API_KEY = "your-api-key"
WS_URL = f"wss://generativelanguage.googleapis.com/ws/google.ai.generativelanguage.v1beta.GenerativeService.BidiGenerateContent?key={GEMINI_API_KEY}"

async def stream_video():
    async with websockets.connect(WS_URL) as ws:
        # Setup message
        setup = {
            "setup": {
                "model": "models/gemini-2.5-flash-preview-native-audio-dialog",
                "generation_config": {
                    "response_modalities": ["AUDIO", "TEXT"]
                }
            }
        }
        await ws.send(json.dumps(setup))

        # Wait for setup complete
        response = await ws.recv()
        print("Setup complete:", response)

        # Send video frame
        with open("frame.jpg", "rb") as f:
            frame_data = base64.b64encode(f.read()).decode()

        video_msg = {
            "realtime_input": {
                "media_chunks": [{
                    "mime_type": "image/jpeg",
                    "data": frame_data
                }]
            }
        }
        await ws.send(json.dumps(video_msg))

        # Receive response
        async for message in ws:
            print("Response:", message)

asyncio.run(stream_video())
```

## Potential Integration with Pi-Guy

### Option 1: Replace Current Vision System
Replace the current frame-by-frame Gemini Vision API calls with Live API streaming.

**Pros:**
- Real-time continuous vision (no 2-second polling)
- Natural conversation about what Pi-Guy sees
- Lower latency responses

**Cons:**
- 2-minute limit for video sessions
- Higher cost for continuous streaming
- More complex implementation
- Would need to coordinate with ElevenLabs voice

### Option 2: Hybrid Approach
Keep ElevenLabs for voice, use Live API just for enhanced vision when needed.

**Pros:**
- Keep existing stable voice system
- Use Live API for "watch mode" features
- Can fall back to current vision if Live API unavailable

**Cons:**
- Two separate AI systems to coordinate
- Potential response conflicts

### Option 3: Full Live API Migration
Replace both ElevenLabs voice AND current vision with Gemini Live API.

**Pros:**
- Single unified AI system
- Native multimodal (voice + vision together)
- Potentially lower total cost

**Cons:**
- Major rewrite required
- Lose ElevenLabs voice quality and features
- Lose existing tools/personality setup
- Session limits (2 min video, 15 min audio)

## Limitations to Consider

1. **Video processed at 1 FPS** - Not suitable for fast-moving content
2. **2-minute video session limit** - Would need session management
3. **3 concurrent sessions per API key** - Multi-user scaling issues
4. **Preview status** - API may change
5. **No persistent memory** - Unlike ElevenLabs knowledge base

## Resources

### Official Documentation
- [Live API Getting Started](https://ai.google.dev/gemini-api/docs/live)
- [WebSocket API Reference](https://ai.google.dev/api/live)
- [Vertex AI Live API](https://cloud.google.com/vertex-ai/generative-ai/docs/live-api)

### Code Examples
- [Google's Live API Web Console (React)](https://github.com/google-gemini/live-api-web-console)
- [Python Starter Code](https://github.com/google-gemini/cookbook/blob/main/gemini-2/websockets/live_api_starter.py)
- [Colab Quickstart](https://colab.research.google.com/github/google-gemini/cookbook/blob/main/quickstarts/Get_started_LiveAPI.ipynb)

### Blog Posts
- [Gemini 2.0 Multimodal Interactions](https://developers.googleblog.com/en/gemini-2-0-level-up-your-apps-with-real-time-multimodal-interactions/)
- [Gemini 2.5 Flash/Pro and Live API](https://developers.googleblog.com/en/gemini-2-5-flash-pro-live-api-veo-2-gemini-api/)
- [Building Real-Time Video AI Service](https://akka.io/blog/building-real-time-video-ai-service-with-google-gemini)

### Pricing
- [Gemini API Pricing](https://ai.google.dev/gemini-api/docs/pricing)
- [Vertex AI Pricing](https://cloud.google.com/vertex-ai/generative-ai/pricing)

## Recommendation

For Pi-Guy, I recommend **Option 2: Hybrid Approach** as the first step:

1. Keep ElevenLabs for voice (proven, stable, personality/tools intact)
2. Add a new "Live Vision Mode" that uses Gemini Live API for continuous video analysis
3. Use it for specific scenarios like:
   - "Watch this and tell me what happens"
   - Real-time narration of activities
   - Security monitoring mode

This gives us the benefits of real-time video understanding without risking the stable voice system we already have.

## Next Steps

1. Test Live API with simple Python WebSocket client
2. Measure latency and cost in practice
3. Design "Live Vision Mode" UI toggle
4. Implement backend WebSocket proxy
5. Add frontend video streaming to Live API
6. Integrate responses with existing speech system
