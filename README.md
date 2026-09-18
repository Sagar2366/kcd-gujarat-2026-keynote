# KCD Gujarat 2026 Keynote — Setup Guide

## What's in this folder

```
index.html          ← The entire website (single file, no build step)
data.js             ← Map data (contributors, chapters, cities)
india-map.svg       ← India map for the interactive Good tab
SPEAKER-SCRIPT.md   ← Full speaker script with timing guide
img/                ← All images (photos, logos, backgrounds)
```

## How to run on ANY laptop

### Option 1 — Python (Mac/Linux/Windows)

```bash
# Open Terminal, cd into this folder
cd kcd-gujarat-keynote

# Start server
python3 -m http.server 8080

# Open browser
# Go to http://localhost:8080
```

### Option 2 — Node.js

```bash
npx serve .
# Opens at http://localhost:3000
```

### Option 3 — Just double-click

Open `index.html` directly in Chrome/Firefox. Everything works except the interactive map (which needs a local server due to SVG loading).

## Requirements

- **Any modern browser** (Chrome, Firefox, Safari, Edge)
- **Python 3** OR **Node.js** for the local server (only needed for the map)
- **No internet required** — everything is self-contained, except GitHub contributor avatars (which gracefully fail to a fallback)
- **No build step** — no npm install, no webpack, nothing

## Navigation

- **Arrow keys** (← →) or **spacebar** to move between slides
- **Arrow buttons** (bottom-right) also work
- **Tabs** (Good / Bad / Unspoken) on the main content slide
- **Click contributors** on the Good tab to expand their bios
- **Click cities** on the map to filter by location

## Slide Flow

1. **Intro** — Title + your photo
2. **Kem Cho Gujarat** — Gujarati greeting
3. **Main Content** — 3 tabs (Good, Bad, Unspoken)
4. **Your Move** — Call to action (6 role cards)
5. **Vultr** — Sponsor slide with event photos
6. **Thank You** — Closing statement + social links

## Presenting Tips

- Use **F11** (or Cmd+Shift+F on Mac) for fullscreen browser
- Works best at **1920×1080** resolution
- If presenting on a projector, test the dark background visibility first
- Keep the speaker script open on your phone or a second screen
