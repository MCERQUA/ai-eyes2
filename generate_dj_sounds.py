#!/usr/bin/env python3
"""
Generate DJ sound effects using ElevenLabs Text-to-Sound Effects API
Run once to cache all sounds, then they're free to use forever!
"""

import os
import requests
from dotenv import load_dotenv

load_dotenv()

API_KEY = os.getenv('ELEVENLABS_API_KEY')
SOUNDS_DIR = 'sounds'

# DJ sound effects to generate
DJ_SOUNDS = {
    # Air horns - the classic!
    'air_horn': {
        'prompt': 'Loud DJ air horn blast, powerful foghorn style, 2 quick blasts',
        'duration': 2.0
    },
    'air_horn_triple': {
        'prompt': 'Triple DJ air horn blast, ba ba baaaa pattern, loud and celebratory',
        'duration': 3.0
    },
    'air_horn_long': {
        'prompt': 'Long sustained DJ air horn, building intensity, stadium horn',
        'duration': 4.0
    },

    # Sirens
    'siren_rise': {
        'prompt': 'Club siren sound effect, rising pitch, electronic dance music style',
        'duration': 3.0
    },
    'siren_woop': {
        'prompt': 'Police siren woop woop, quick two-tone, DJ remix style',
        'duration': 2.0
    },

    # DJ scratches
    'scratch': {
        'prompt': 'Vinyl record scratch, classic hip-hop DJ turntable scratch, quick and sharp',
        'duration': 1.5
    },
    'scratch_long': {
        'prompt': 'Extended DJ scratch solo, multiple scratches, turntablist style',
        'duration': 3.0
    },

    # Transitions
    'rewind': {
        'prompt': 'Tape rewind sound effect, DJ rewind, rapid tape reverse',
        'duration': 2.0
    },
    'record_stop': {
        'prompt': 'Record player stopping abruptly, vinyl slowdown and stop',
        'duration': 2.0
    },
    'whoosh': {
        'prompt': 'Whoosh transition sound effect, cinematic swoosh, fast movement',
        'duration': 1.0
    },

    # Impacts and drops
    'bass_drop': {
        'prompt': 'Heavy bass drop impact, EDM club style, deep sub bass hit',
        'duration': 2.0
    },
    'impact': {
        'prompt': 'Electronic impact hit, punchy club sound, DJ transition impact',
        'duration': 1.0
    },

    # Crowd sounds
    'applause': {
        'prompt': 'Crowd applause and cheering, enthusiastic club audience, celebration',
        'duration': 4.0
    },
    'applause_short': {
        'prompt': 'Quick applause burst, short crowd cheer',
        'duration': 1.5
    },
    'crowd_hype': {
        'prompt': 'Crowd going wild, excited screaming and cheering, festival atmosphere',
        'duration': 3.0
    },

    # Fun extras
    'laser': {
        'prompt': 'Electronic laser zap sound, sci-fi pew pew, retro arcade',
        'duration': 1.0
    },
    'vinyl_pop': {
        'prompt': 'Vinyl record static crackle and pop, nostalgic record player',
        'duration': 2.0
    },
    'gunshot': {
        'prompt': 'Gunshot sound effect, single shot, action movie style',
        'duration': 1.0
    },
    'explosion': {
        'prompt': 'Explosion boom, cinematic impact, dramatic',
        'duration': 2.0
    },
}

def generate_sound(name, prompt, duration):
    """Generate a sound effect using ElevenLabs API"""
    print(f"🎵 Generating '{name}'...")

    url = "https://api.elevenlabs.io/v1/sound-generation"

    headers = {
        "xi-api-key": API_KEY,
        "Content-Type": "application/json"
    }

    data = {
        "text": prompt,
        "duration_seconds": duration,
        "prompt_influence": 0.5
    }

    response = requests.post(url, headers=headers, json=data)

    if response.status_code == 200:
        filepath = os.path.join(SOUNDS_DIR, f"{name}.mp3")
        with open(filepath, 'wb') as f:
            f.write(response.content)
        print(f"   ✅ Saved to {filepath}")
        return True
    else:
        print(f"   ❌ Error: {response.status_code} - {response.text}")
        return False

def main():
    # Create sounds directory
    os.makedirs(SOUNDS_DIR, exist_ok=True)

    print("🎧 DJ-FoamBot Sound Generator")
    print("=" * 40)
    print(f"Generating {len(DJ_SOUNDS)} sound effects...")
    print()

    success = 0
    failed = 0

    for name, config in DJ_SOUNDS.items():
        # Skip if already exists
        filepath = os.path.join(SOUNDS_DIR, f"{name}.mp3")
        if os.path.exists(filepath):
            print(f"⏭️  '{name}' already exists, skipping...")
            success += 1
            continue

        if generate_sound(name, config['prompt'], config['duration']):
            success += 1
        else:
            failed += 1

    print()
    print("=" * 40)
    print(f"✅ Success: {success}")
    print(f"❌ Failed: {failed}")
    print()
    print("Sounds are cached in the 'sounds/' directory.")
    print("They're now FREE to use forever! 🎉")

if __name__ == '__main__':
    main()
