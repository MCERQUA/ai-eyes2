# DJ-FoamBot Tools Reference

**Master reference for all Hume AI tools and configurations for DJ-FoamBot.**

> **⚠️ CRITICAL FOR CLAUDE - READ BEFORE ANY CONFIG UPDATES:**
>
> 1. **ALWAYS get the full config FIRST** before making changes:
>    ```bash
>    curl -s "https://api.hume.ai/v0/evi/configs/$HUME_CONFIG_ID" \
>      -H "X-Hume-Api-Key: $HUME_API_KEY"
>    ```
> 2. **Hume configs are VERSIONED** - each update creates a new version
> 3. **When updating, you MUST include**:
>    - `prompt` (or it becomes empty!)
>    - `voice` (required for EVI3)
>    - `tools` (or they get detached!)
> 4. Update this file with any changes you make

---

## Hume AI Configuration

```
Config ID: 3c824978-efa3-40df-bac2-023127b30e31
Config Name: DJ-FoamBot-SprayFoamRadio
Voice: DJ-FoamBot (Custom Cloned)
Voice ID: bdcf156c-6678-4720-9f91-46bf8063bd7f
EVI Version: 3
```

### Current Tools

| Tool Name | Tool ID | Purpose |
|-----------|---------|---------|
| play_music | `791378df-6c3a-4d52-966c-96e5c3f78981` | Music playback control |
| dj_soundboard | `46645424-1257-4bd0-8fde-e8ed6cd87edb` | DJ sound effects |
| look_and_see | `b7b1e0a5-2cb0-4895-bcbf-b258b4796d42` | Camera vision |

---

## Tool Details

### 1. Music (play_music)

**Purpose**: Control music playback for the radio station

**Tool ID**: `791378df-6c3a-4d52-966c-96e5c3f78981`

**Parameters**:
- `action` (required): `play`, `pause`, `stop`, `skip`, `volume`, `status`, `list`
- `track` (optional): Track name to play
- `volume` (optional): Volume level 0-100

**Available Tracks**:
1. "Call Me Mrs. Sprayfoam" (2:50)
2. "Espuma y Calidez 2" (4:05)
3. "Foam Everything" (1:40)
4. "Foam It - We Insulate You Right" (1:40)
5. "Hey Diddle Diddle" (2:44)
6. "OG Polyurethane Gang" (1:08)
7. "Polyurethane Gang" (1:07)
8. "Comfy Life (Spanish Version)" (4:05)

---

### 2. DJ Soundboard (dj_soundboard)

**Purpose**: Play DJ sound effects for dramatic radio moments

**Tool ID**: `46645424-1257-4bd0-8fde-e8ed6cd87edb`

**Parameters**:
- `sound` (required): Sound effect name

**Available Sounds**:
- `air_horn` - Classic DJ horn
- `scratch` - Vinyl scratching
- `siren` - Alert siren
- `rewind` - Pull it back
- `crowd_cheer` - Crowd goes wild
- `yeah` - Hype vocal
- `lets_go` - Get hyped
- `laser` - Pew pew
- `impact` - Punch/hit
- `bruh` - Disappointment
- `sad_trombone` - Fail sound

**Note**: Sounds are triggered via text detection - when DJ says trigger words like "air horn", the frontend plays the sound automatically.

---

### 3. Vision (look_and_see)

**Purpose**: See through the camera using Gemini Vision API

**Tool ID**: `b7b1e0a5-2cb0-4895-bcbf-b258b4796d42`

**Parameters**:
- `prompt` (optional): Specific thing to look for

**Triggers**: "look", "see", "what is this", "check this out"

**Dependencies**:
- Camera must be enabled
- `GEMINI_API_KEY` in .env

---

## Updating the Hume Config

### Step 1: Get Current Config

```bash
curl -s "https://api.hume.ai/v0/evi/configs/3c824978-efa3-40df-bac2-023127b30e31" \
  -H "X-Hume-Api-Key: $HUME_API_KEY" | python3 -m json.tool
```

### Step 2: Create New Version

```bash
curl -X POST "https://api.hume.ai/v0/evi/configs/3c824978-efa3-40df-bac2-023127b30e31" \
  -H "X-Hume-Api-Key: $HUME_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "version_description": "Description of changes",
    "prompt": {
      "text": "Full prompt text here..."
    },
    "voice": {
      "provider": "CUSTOM_VOICE",
      "name": "DJ-FoamBot"
    },
    "tools": [
      {"id": "791378df-6c3a-4d52-966c-96e5c3f78981"},
      {"id": "46645424-1257-4bd0-8fde-e8ed6cd87edb"},
      {"id": "b7b1e0a5-2cb0-4895-bcbf-b258b4796d42"}
    ]
  }'
```

### ⚠️ Common Mistakes

1. **Empty prompt** - If you don't include `prompt`, it becomes empty
2. **Missing voice** - EVI3 requires voice specification
3. **Tools detached** - If you don't include `tools`, they get removed
4. **Wrong voice format** - Use `{"provider": "CUSTOM_VOICE", "name": "DJ-FoamBot"}`

---

## Environment Variables

```bash
# Hume.ai Configuration
HUME_API_KEY=xxx
HUME_SECRET_KEY=xxx
HUME_CONFIG_ID=3c824978-efa3-40df-bac2-023127b30e31
HUME_PROMPT_ID=d2c9c45c-66ab-451b-bf5a-5033d5e97a54
HUME_VOICE_ID=bdcf156c-6678-4720-9f91-46bf8063bd7f
HUME_VOICE_NAME=DJ-FoamBot

# Tool IDs
HUME_TOOL_PLAY_MUSIC=791378df-6c3a-4d52-966c-96e5c3f78981
HUME_TOOL_DJ_SOUNDBOARD=46645424-1257-4bd0-8fde-e8ed6cd87edb
HUME_TOOL_LOOK_AND_SEE=b7b1e0a5-2cb0-4895-bcbf-b258b4796d42

# Google Gemini (Vision)
GEMINI_API_KEY=xxx

# Server
DOMAIN=dj-foambot.mikecerqua.ca
PORT=5001
```

---

## Hume Tool Call Flow

When DJ-FoamBot uses a tool, this is the WebSocket message flow:

1. **Hume sends tool_call**:
```json
{
  "type": "tool_call",
  "tool_call_id": "unique-id",
  "name": "play_music",
  "parameters": "{\"action\": \"play\"}"
}
```

2. **Client executes tool** (calls server API, plays sound, etc.)

3. **Client sends tool_response**:
```json
{
  "type": "tool_response",
  "tool_call_id": "unique-id",
  "content": "Now playing: Foam Everything"
}
```

4. **Hume continues conversation** using the tool response

---

## Adding a New Tool

### Step 1: Create Tool in Hume

```bash
curl -X POST "https://api.hume.ai/v0/evi/tools" \
  -H "X-Hume-Api-Key: $HUME_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "new_tool",
    "description": "What the tool does",
    "parameters": {
      "type": "object",
      "properties": {
        "param1": {
          "type": "string",
          "description": "Parameter description"
        }
      },
      "required": ["param1"]
    }
  }'
```

### Step 2: Attach to Config

Include the new tool ID in the tools array when updating the config.

### Step 3: Implement Handler

Add a handler in your frontend code to process the tool_call and return a tool_response.

---

## Version History

| Version | Date | Description |
|---------|------|-------------|
| 16 | 2024-12-01 | Fixed empty prompt issue |
| 15 | 2024-12-01 | Added v6 prompt (empty due to bug) |
| 9+ | 2024-12-01 | Tools attached (play_music, dj_soundboard, look_and_see) |
| 1 | 2024-11-29 | Initial DJ-FoamBot config |
