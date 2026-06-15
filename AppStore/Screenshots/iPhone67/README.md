# iPhone 6.7" Screenshots (iPhone 14/15 Pro)

**Apple spec**: 1290×2796 px (portrait) or 2796×1290 (landscape)
**Required**: At least 5 screenshots showing different features
**Upload to**: App Store Connect → App Store → 6.7" iPhone Display

## Pending Real Device Capture (P1)

These screenshots must show **real device** captured screens, not simulator mocks.
The current app needs:

1. **Home screen** — list of stretch sessions (light theme)
2. **Session detail** — duration, description, start button
3. **Active player** — timer running, controls visible
4. **Stats / progress** — streak counter, achievements
5. **Premium paywall** — feature comparison (use IAP screenshot from InAppPurchase/)

## Status

- ⏳ Real device capture pending (P1 - awaiting real device from 佛老爷)
- 🎨 Mockup template: see `AppStore/Assets/UI/UI-Mockup-v1.png` (early design, NOT final)
- 📐 Color theme: purple/coral (matches app icon, see `AppStore/Assets/Icon/Icon-1024@1x.png`)

## Generation Command (placeholder for future)

When ready to generate mockup screenshots:
```bash
# Use simulator screenshots as placeholder until real device arrives
xcrun simctl io booted screenshot /tmp/home.png
# Or generate with image_generate referencing app UI mockup
```

## Naming Convention

`SS_<sequence>_<feature>_iPhone67.png`
Example: `SS_01_Home_iPhone67.png`, `SS_02_Session_iPhone67.png`

---

_Last updated: 2026-06-15 by Katherine-E2wa1m (Tier 1 self-reassign)_