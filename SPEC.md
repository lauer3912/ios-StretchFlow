# StretchGoGo - Product Specification

## 1. Project Overview

**App Name:** StretchGoGo
**Bundle ID:** `com.ggsheng.StretchGoGo`
**Team:** ZhiFeng Sun (9L6N2ZF26B)

**Core Functionality:** A daily stretching & yoga companion app that guides users through guided stretching sessions with timer-based animations, body part targeting, habit tracking, and progress statistics. Available in dark and light themes.

**Target Market:** Western markets (US, EU, UK, CA, AU) - Health & Fitness enthusiasts, office workers, athletes
**Monetization:** One-time purchase @ $9.9 (Premium Unlock)
**iOS Version Support:** iOS 15.0+

---

## 2. UI/UX Specification

### Screen Structure

1. **HomeScreen** - Main dashboard with today's session and streak
2. **SessionPlayerScreen** - Active stretch session with timer, animation, progress
3. **LibraryScreen** - Browse all available sessions by category
4. **SessionDetailScreen** - Session info before starting
5. **StatisticsScreen** - Calendar heatmap, weekly/monthly stats
6. **ProfileScreen** - User settings, preferences, reminders
7. **SettingsScreen** - App settings, iCloud sync, data export
8. **AchievementsScreen** - Unlock badges and milestones

### Navigation Structure
- **UITabBarController** with 4 tabs:
  - Home (house icon)
  - Library (grid icon)
  - Stats (chart icon)
  - Profile (person icon)

### Visual Design

#### Color Palette

**Light Theme:**
- Primary: `#5B4CD4` (Vibrant Purple)
- Secondary: `#7B73E8` (Light Purple)
- Accent: `#FF6B6B` (Coral)
- Background: `#FAFAFA`
- Surface: `#FFFFFF`
- Text Primary: `#1A1A2E`
- Text Secondary: `#6B6B7B`

**Dark Theme:**
- Primary: `#8B83FF` (Bright Purple)
- Secondary: `#6B63E8` (Medium Purple)
- Accent: `#FF7B7B` (Soft Coral)
- Background: `#0D0D1A`
- Surface: `#1A1A2E`
- Text Primary: `#FFFFFF`
- Text Secondary: `#9B9BAD`

#### Typography
- **Primary Font:** SF Pro Display
- **Heading 1:** 28pt Bold
- **Heading 2:** 22pt Semibold
- **Body:** 16pt Regular
- **Caption:** 13pt Regular
- **Button:** 16pt Semibold

#### Spacing System (8pt Grid)
- xs: 4pt
- sm: 8pt
- md: 16pt
- lg: 24pt
- xl: 32pt
- xxl: 48pt

### Views & Components

#### Reusable Components
- **StretchCard** - Session card with thumbnail, title, duration, difficulty
- **TimerRing** - Circular progress indicator for session timer
- **BodyMapView** - Visual body part selector (front/back)
- **StreakBadge** - Current streak display with flame icon
- **CalendarHeatmap** - GitHub-style activity calendar
- **AchievementBadge** - Unlockable badge with progress ring
- **ActionButton** - Primary CTA button with gradient
- **SegmentedPicker** - Duration/intensity selector
- **BottomSheet** - Modal for session options

---

## 3. Functionality Specification

### Core Features (50+)

#### Session & Playback (15)
1. Guided stretch session playback
2. Session timer with countdown
3. Pause/resume session
4. Skip to next exercise
5. Exercise animation display
6. Current exercise indicator
7. Total elapsed time display
8. Rest period timer between exercises
9. Audio cue for exercise transitions
10. Voice guidance narration
11. Session completion celebration
12. Quick session restart
13. Session difficulty levels (Beginner/Intermediate/Advanced)
14. Session duration presets (5/10/15/20/30 min)
15. Session preview mode

#### Library & Content (8)
16. Browse sessions by category
17. Browse sessions by duration
18. Browse sessions by body part
19. Favorite sessions
20. Recently played sessions
21. Recommended for you
22. Search sessions
23. Filter by difficulty
24. Sort by popularity/newest

#### Body Part Targeting (6)
25. Full body sessions
26. Upper body (shoulders, arms, chest)
27. Lower body (legs, hips, glutes)
28. Back & spine
29. Neck & shoulders
30. Hip flexors & IT band

#### Tracking & Statistics (8)
31. Daily stretch completion logging
32. Calendar heatmap visualization
33. Current streak counter
34. Longest streak record
35. Weekly summary chart
36. Monthly summary chart
37. Total minutes stretched
38. Total sessions completed

#### Achievements & Gamification (5)
39. First session completed
40. 7-day streak badge
41. 30-day streak badge
42. 100 total minutes badge
43. Weekend warrior badge

#### Personalization (6)
44. Reminder notifications
45. Reminder time customization
46. Preferred session duration
47. Sound effects on/off
48. Voice guidance on/off
49. Haptic feedback on/off
50. Auto-play next session

#### Data & Sync (4)
51. iCloud data sync
52. Local data persistence
53. Session history export (JSON)
54. Reset all data

#### Settings (3)
55. Dark/Light theme toggle
56. Notification settings
57. Privacy Policy display

---

## 4. Technical Specification

### Architecture
- **Pattern:** MVVM (Model-View-ViewModel)
- **UI Framework:** SwiftUI
- **Minimum iOS:** 15.0

### Dependencies (Swift Package Manager)
- None required for core functionality (using native SwiftUI)

### Data Models
- `StretchSession` - Session definition
- `Exercise` - Individual exercise within session
- `UserProgress` - Per-user tracking data
- `Achievement` - Achievement definition
- `UserSettings` - App preferences

### Storage
- **UserDefaults** - User settings, preferences
- **SQLite (via SQLite.swift)** - Session data, progress records
- **iCloud Key-Value Store** - Cross-device sync

### Assets Required
- App Icon (1024x1024 + all required sizes)
- Exercise illustration images (PNG, 750x750)
- Achievement badge images (PNG, 300x300)
- Tab bar icons (SF Symbols)
- Onboarding illustrations (3 screens)

---

## 5. Privacy & Compliance

- **Privacy Policy URL:** `https://lauer3912.github.io/ios-StretchFlow/docs/PrivacyPolicy.html`
- **No HealthKit required**
- **No user accounts required**
- **All data stored locally**

---

## 6. App Store Metadata

**Keywords:** stretch, yoga, fitness, health, exercise, workout, relaxation, meditation, flexibility, daily workout
**Category:** Health & Fitness
**Price:** $9.99 (USD)
**Content Rating:** 4+
