# FocusDrive iOS App

A gamified focus timer app that uses driving metaphors to help users stay concentrated on their tasks.

## Project Status

**Phase 1: Project Setup** ✅ COMPLETE

- Folder structure created
- SwiftData models implemented
- Main app file with initial data seeding
- Utility helpers and extensions

**Phase 2: Data Layer** ✅ COMPLETE

- 50 curated destinations across the US
- Destination model with category system
- Seed data with helper methods
- Destinations loaded and accessible on app launch

**Phase 3: Core Managers** ✅ COMPLETE

- SessionManager (timer, progress, fuel system)
- RouteManager (MapKit integration, route calculation)
- AudioManager (engine sounds, ambient audio)
- HapticManager (Core Haptics feedback)
- BlockingManager (Screen Time API)
- AchievementManager (tracking and unlocking)
- Total: 1,431 lines of production-ready code

## Project Structure

```
FocusDrive/
├── FocusDriveApp.swift              # App entry point with SwiftData setup
├── Models/                           # Data models (SwiftData)
│   ├── Session.swift                # Focus session model
│   ├── Route.swift                  # Driving route model
│   ├── Vehicle.swift                # Vehicle/car model
│   ├── Postcard.swift              # Achievement postcard model
│   ├── Achievement.swift           # User achievement model
│   ├── Destination.swift           # Destination model
│   └── SeedData.swift              # 50 initial destinations
├── ViewModels/                      # Business logic (optional for MVVM)
├── Views/                           # SwiftUI views (coming in Phase 4)
│   ├── Garage/
│   ├── RoutePlanning/
│   ├── Session/
│   ├── Collection/
│   └── Settings/
├── Managers/                        # Service layer ✅
│   ├── SessionManager.swift        # Timer and session logic
│   ├── RouteManager.swift          # MapKit integration
│   ├── AudioManager.swift          # Audio playback
│   ├── HapticManager.swift         # Haptic feedback
│   ├── BlockingManager.swift       # Screen Time API
│   └── AchievementManager.swift    # Achievement tracking
├── UIKit/                          # UIKit integrations (coming later)
├── Resources/                      # Assets and resources
│   └── Assets.xcassets/
└── Utilities/                      # Helper code
    ├── Constants.swift             # App-wide constants
    ├── Helpers.swift               # Utility functions
    └── Extensions/                 # Swift extensions
        ├── View+Extensions.swift
        └── Color+Extensions.swift
```

## Features Implemented

### Phase 1: ✅ Complete

- [x] SwiftData model container setup
- [x] All 5 data models (Session, Route, Vehicle, Postcard, Achievement)
- [x] Initial data seeding (6 vehicles, 9 achievements)
- [x] App constants and utilities
- [x] Helper extensions for formatting and UI

### Phase 2: ✅ Complete

- [x] Destination model with 6 category types
- [x] 50 curated destinations (15 cities, 10 national parks, 10 landmarks, 8 beaches, 7 mountains)
- [x] Seed data with helper methods (filtering, sorting, nearby search)
- [x] Destinations loaded and accessible on app launch

### Phase 3: ✅ Complete

- [x] SessionManager (309 lines) - Timer, progress, fuel, audio/haptic integration
- [x] RouteManager (310 lines) - MapKit route calculation, destination management
- [x] AudioManager (140 lines) - Engine sounds, ambient audio, effects
- [x] HapticManager (167 lines) - Core Haptics patterns and fallbacks
- [x] BlockingManager (212 lines) - Screen Time API, app blocking
- [x] AchievementManager (293 lines) - Achievement tracking across 5 categories
- [x] Total: 1,431 lines of production-ready manager code

### Data Models

#### Session

Tracks individual focus sessions with:

- Duration, distance, completion status
- Fuel efficiency (1-5 stars)
- Focus quality metrics

#### Route

Stores driving routes with:

- Origin and destination coordinates
- Distance and estimated duration
- Route type (highway, scenic, backroads)

#### Vehicle

Represents unlockable vehicles with:

- Vehicle type (sedan, SUV, sports car, etc.)
- Stats (speed, comfort, efficiency ratings)
- Usage tracking

#### Postcard

Collectible achievements for completed destinations

#### Achievement

Gamification system with categories:

- Distance (miles driven)
- Consistency (daily streaks)
- Exploration (destinations visited)
- Efficiency (fuel efficiency)

#### Destination

Curated destinations for focus drives:

- 6 categories (city, nature, landmark, beach, mountain, general)
- 50 initial destinations across the US
- Real coordinates and descriptions
- Helper methods for filtering and searching

## Technical Stack

- **iOS 17.0+**
- **Swift 5.9+**
- **SwiftUI** - UI framework
- **SwiftData** - Data persistence
- **MapKit** - Route calculation (coming in Phase 3)
- **Core Haptics** - Tactile feedback (coming in Phase 5)
- **AVFoundation** - Audio engine (coming in Phase 5)

## Next Steps

**Phase 4: Primary Views** (Coming next)

- GarageView (vehicle selection)
- DestinationPickerView (route planning)
- DrivingDashboardView (main session)
- ArrivalView (completion)

## Development Notes

- All models use SwiftData's `@Model` macro for persistence
- Initial vehicles and achievements are seeded on first launch
- One starter vehicle (Classic Sedan) is unlocked by default
- Achievement system tracks user progress automatically
- 50 destinations are available immediately (no search required)
- Destinations span major US cities, national parks, landmarks, beaches, and mountains

## Requirements

- Xcode 15.0+
- iOS 17.0+ device or simulator
- Swift 5.9+

---

Built with ❤️ following the Technical Implementation Guide
