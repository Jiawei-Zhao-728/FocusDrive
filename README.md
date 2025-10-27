# 🚗 FocusDrive

**Turn your focus sessions into epic road trips.**

FocusDrive is an innovative iOS productivity app that transforms the mundane act of setting a timer into an immersive virtual driving experience. Instead of watching a countdown, you plan routes, select vehicles, and "drive" to real destinations while staying focused on your work.

<div align="center">

[![iOS](https://img.shields.io/badge/iOS-17.0+-blue.svg)](https://developer.apple.com/ios/)
[![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)](https://swift.org)
[![SwiftUI](https://img.shields.io/badge/SwiftUI-blue.svg)](https://developer.apple.com/xcode/swiftui/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

</div>

---

## 🎯 The Problem

Traditional Pomodoro timers are boring. Watching numbers count down doesn't make you _want_ to start working—it just reminds you how long you'll be stuck there. For many people (especially those with ADHD), **the hardest part isn't staying focused—it's starting in the first place.**

## 💡 The Solution

**FocusDrive makes task initiation exciting by framing productivity as adventure rather than obligation.**

Instead of "I need to work for 2 hours," it becomes "I'm driving to Yosemite National Park!" The journey becomes the reward, turning focus time into an engaging game you actually want to play.

---

## ✨ Key Features

### 🚙 **Choose Your Vehicle**

Select from 6 different vehicle types, each suited to different work styles:

- **Sports Car** - Intense work, short bursts (15-45 min)
- **Sedan** - Balanced focus, studying (45-90 min)
- **SUV** - Creative work, flexible thinking (60-120 min)
- **Truck** - Heavy projects, long hauls (2-4 hours)
- **Electric Car** - Eco mode, sustainable focus (30-60 min)
- **Vintage Car** - Leisurely pace, reading (30-90 min)

### 🗺️ **Real Destinations**

Drive to 50+ real locations across the United States:

- 🏙️ Major cities (NYC, SF, Chicago, Miami...)
- 🏞️ National Parks (Yosemite, Yellowstone, Grand Canyon...)
- 🗽 Landmarks (Statue of Liberty, Golden Gate Bridge...)
- 🏖️ Beaches (Miami Beach, Santa Monica...)
- ⛰️ Mountains (Rocky Mountains, Appalachian Trail...)

Routes are calculated using **Apple Maps** with real distances and durations.

### 🎮 **Live Driving Experience**

During your focus session:

- **Dashboard Interface** - Speed, fuel gauge, distance traveled
- **3D Map View** - Watch your progress along the route
- **Realistic Physics** - Speed varies with "road conditions"
- **Fuel System** - Depletes as you drive (represents energy/focus)
- **Audio Feedback** - Engine sounds and highway ambiance
- **Haptic Feedback** - Feel the road through subtle vibrations

### 🏆 **Gamification**

- **Collect Postcards** - Earn vintage-style postcards for each destination
- **Unlock Achievements** - 9+ achievements across 5 categories
- **Track Statistics** - Total miles, routes completed, focus quality
- **Streak Tracking** - Build consecutive day streaks
- **Vehicle Progression** - Unlock new vehicles as you drive more

### 🚫 **App Blocking (Optional)**

Enable "Road Mode" to block distracting apps during your drive:

- Integrates with iOS Screen Time API
- Choose which categories to block (social media, games, etc.)
- Gentle reminders if you try to access blocked apps

---

## 🎬 How It Works

### 1. **Pre-Drive Ritual** (30-60 seconds)

- Open the app to your garage
- Select a vehicle
- Choose a destination (or search for one)
- Review the calculated route
- Complete the pre-drive checklist:
  - Adjust seat ✓
  - Check mirrors ✓
  - Fasten seatbelt ✓
  - Enable Road Mode ✓
  - Start engine 🚗

### 2. **Active Session**

- Put your phone down or use other apps
- The journey happens in the background
- Real-time dashboard shows your progress:
  - Current speed (based on activity)
  - Distance traveled
  - Fuel remaining
  - Time until arrival
- Optional rest stops (Pomodoro-style breaks)

### 3. **Arrival**

- Celebration animation when you "arrive"
- Earn a collectible postcard
- View session statistics
- Track achievements unlocked

---

## 🎨 Design Philosophy

### **Immersive Metaphor**

The entire app commits to the driving metaphor. Every interaction reinforces the feeling of taking a road trip, making focus time feel like an adventure rather than work.

### **Realistic Details**

- Real locations with actual coordinates
- Accurate route distances from Apple Maps
- Vehicle-specific engine sounds (coming soon)
- Haptic feedback that simulates road texture
- Fuel gauge that represents your mental energy

### **Minimal Friction**

- 30-second setup for experienced users
- Quick Start option for repeat routes
- Background operation when using other apps
- No annoying notifications during focus time

### **Generous Free Tier**

Core functionality is completely free:

- Unlimited focus sessions
- All vehicles and destinations unlockable
- Full gamification system
- App blocking features

Premium features focus on analytics and customization, not locking core features.

---

## 🛠️ Technical Architecture

### **Built With**

- **SwiftUI** - Modern declarative UI
- **SwiftData** - Native persistence layer
- **MapKit** - Real route calculation
- **Core Haptics** - Tactile feedback
- **AVFoundation** - Spatial audio engine
- **Screen Time API** - App blocking integration

### **Project Structure**

```
FocusDrive/
├── Models/               # 7 SwiftData models
│   ├── Session.swift     # Focus session tracking
│   ├── Route.swift       # Driving routes
│   ├── Vehicle.swift     # Car collection
│   ├── Achievement.swift # Gamification
│   └── ...
├── Managers/            # 6 business logic managers (1,431 lines)
│   ├── SessionManager   # Timer & progress tracking
│   ├── RouteManager     # MapKit integration
│   ├── AudioManager     # Sound playback
│   ├── HapticManager    # Tactile feedback
│   ├── BlockingManager  # Screen Time API
│   └── AchievementManager
├── Views/               # SwiftUI interfaces
│   ├── Garage/          # Vehicle selection
│   ├── RoutePlanning/   # Destination picker
│   ├── Session/         # Driving dashboard
│   └── ...
└── Utilities/           # Helpers & extensions
```

### **Architecture Highlights**

- **MVVM** pattern with reactive `@Observable` managers
- **Clean separation** of concerns (UI, business logic, data)
- **SwiftData** for modern, type-safe persistence
- **Dependency injection** for testability
- **Production-ready** error handling and logging

---

## 📊 Current Status

### ✅ **Phase 1-3: Complete (Backend Ready)**

- ✅ All 7 data models implemented
- ✅ 6 managers with full business logic (1,431 lines)
- ✅ 50 destinations with real coordinates
- ✅ MapKit route calculation working
- ✅ Audio & haptic systems ready
- ✅ Achievement tracking functional
- ✅ App blocking integration complete
- ✅ Test interface for validation

### 🚧 **Phase 4: In Progress (UI Development)**

- [ ] GarageView - Vehicle selection screen
- [ ] DestinationPickerView - Map-based destination picker
- [ ] DrivingDashboardView - Main session interface
- [ ] ArrivalView - Completion celebration
- [ ] SettingsView - App preferences

### 📅 **Future Phases**

- **Phase 5:** Polish & Assets (audio files, app icon)
- **Phase 6:** TestFlight Beta
- **Phase 7:** App Store Launch

---

## 🚀 Roadmap

### **Short-term** (Next 2-3 weeks)

- [ ] Complete primary UI views
- [ ] Add audio files for all 6 vehicle types
- [ ] Design app icon and launch screen
- [ ] Implement animations and transitions
- [ ] Device testing and optimization

### **Medium-term** (1-2 months)

- [ ] Premium features (analytics dashboard)
- [ ] Apple Watch companion app
- [ ] Siri Shortcuts integration
- [ ] Additional vehicle types and destinations
- [ ] Seasonal events and themed challenges

### **Long-term** (3-6 months)

- [ ] iPad optimization
- [ ] International destinations
- [ ] User-generated routes (share custom drives)
- [ ] Focus mode automation (trigger iOS Focus)
- [ ] CarPlay integration (parked mode)

---

## 🎯 Target Audience

- **Students** struggling to start studying
- **Remote Workers** needing focus structure
- **ADHD Users** seeking engaging productivity tools
- **Productivity Enthusiasts** tired of boring timers
- **Anyone** who finds traditional Pomodoro apps unmotivating

---

## 🏁 Getting Started

### **Requirements**

- Xcode 15.0+
- iOS 17.0+ device or simulator
- macOS 14.0+ (for development)

### **Installation**

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/FocusDrive.git

# Navigate to project
cd FocusDrive

# Open in Xcode
open FocusDrive.xcodeproj
```

### **Running the App**

1. Select a simulator or connected device
2. Press `⌘R` to build and run
3. Test using the `TestSessionView` interface

---

## 🤝 Contributing

Contributions are welcome! Whether you're fixing bugs, adding features, or improving documentation, your help makes FocusDrive better.

### **Ways to Contribute**

- 🐛 Report bugs via Issues
- 💡 Suggest features or improvements
- 🎨 Design new vehicle types or destinations
- 📝 Improve documentation
- 🔧 Submit pull requests

### **Development Guidelines**

- Follow Swift style guidelines
- Write descriptive commit messages
- Test thoroughly before submitting PRs
- Update documentation for new features

---

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- Inspired by **Focus Flight** and the power of immersive metaphors
- Built for the ADHD community and productivity enthusiasts
- Special thanks to everyone who believes in making focus fun

---

## 📞 Contact

**Developer:** Jiawei Zhao  
**Project Link:** [https://github.com/YOUR_USERNAME/FocusDrive](https://github.com/YOUR_USERNAME/FocusDrive)

---

<div align="center">

**Built with ❤️ and lots of virtual road trips** 🚗💨

_Making productivity an adventure, one drive at a time._

</div>
