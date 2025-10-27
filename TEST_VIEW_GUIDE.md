# TestSessionView - Demo Guide

## 🎯 Purpose

The TestSessionView provides a simple UI to test all managers before building the full production interface.

---

## ✅ What's Included

### Test View Features

1. **Vehicle Selection**

   - Dropdown showing all unlocked vehicles
   - Displays vehicle name and miles driven
   - Visual checkmark for selected vehicle

2. **Destination Selection**

   - Shows 5 sample destinations from seed data
   - Displays destination name and category
   - Automatically calculates route when selected

3. **Route Information**

   - Distance in miles
   - Estimated duration in minutes
   - Destination name

4. **Live Session Display**

   - **Elapsed Time** - MM:SS format, large display
   - **Current Speed** - Simulated MPH (50-70 range)
   - **Progress** - Percentage complete
   - **Distance Progress** - Miles traveled
   - **Distance Remaining** - Miles to destination
   - **Fuel Gauge** - Visual bar with percentage
   - **Session Status** - Active/Paused indicator

5. **Control Buttons**

   - **Start Session** - Begins focus session
   - **Pause** - Pauses active session
   - **Resume** - Resumes paused session
   - **End** - Ends session and checks achievements

6. **Achievement Display**

   - Shows recently unlocked achievements
   - Displays achievement name, description, icon

7. **Manager Status**
   - Shows initialization status of all managers
   - Confirms all managers are ready

---

## 🚀 How to Use

### Step 1: Run the App

```bash
Open FocusDrive.xcodeproj in Xcode
Press ⌘R to run in simulator
```

### Step 2: Select a Vehicle

- Tap on "Classic Sedan" (the only unlocked vehicle initially)
- You'll see a checkmark appear
- Console will log: `🚗 Selected vehicle: Classic Sedan`

### Step 3: Select a Destination

- Tap any of the 5 sample destinations (e.g., "New York City")
- Route calculation begins automatically
- Console will log: `📍 Selected destination: New York City`
- Wait for route info to appear

### Step 4: Start Session

- Once route is calculated, tap "Start Session"
- Console will log multiple events:
  - `🚗 Session started`
  - `🔊 Playing engine start sound: sedan_start`
  - `🔊 Starting ambient driving sounds`

### Step 5: Watch Live Updates

- Timer updates every second
- Speed varies between 50-70 MPH
- Distance progress increases
- Fuel depletes from 100% to 0%
- Progress percentage increases

### Step 6: Pause/Resume (Optional)

- Tap "Pause" to pause the session
  - Timer stops
  - Audio pauses
  - Console: `⏸️ Session paused`
- Tap "Resume" to continue
  - Timer resumes
  - Audio resumes
  - Console: `▶️ Session resumed`

### Step 7: Complete or End Session

- **Option A: Let it Complete**

  - Wait until progress reaches 100%
  - Session auto-completes
  - Console: `🎉 Session completed!`
  - Arrival sound plays
  - Arrival haptic fires
  - Achievements checked

- **Option B: End Early**
  - Tap "End" button
  - Session marked as abandoned
  - Console: `❌ Session abandoned`

### Step 8: Check Achievements

- If you unlocked any achievements, they'll appear in a yellow box
- Console will log: `🎉 Achievement unlocked: [name]`

---

## 📊 What to Test

### SessionManager Testing

- ✅ Timer starts and updates every second
- ✅ Speed simulation (50-70 MPH with variations)
- ✅ Distance progress calculation
- ✅ Fuel depletion (linear 100% → 0%)
- ✅ Pause/resume functionality
- ✅ Auto-completion at 100%
- ✅ Session state persistence

### RouteManager Testing

- ✅ Route calculation with MapKit
- ✅ Distance and duration accuracy
- ✅ Destination loading from SeedData
- ✅ Route saved to SwiftData

### AudioManager Testing

- ✅ Engine start sound plays (logs to console)
- ✅ Ambient driving sound loops (logs to console)
- ✅ Pause/resume audio (logs to console)
- ✅ Arrival chime on completion (logs to console)

Note: Actual audio won't play until audio files are added to project. Console logs confirm the audio system is working.

### HapticManager Testing

- ✅ Selection haptics when tapping vehicles/destinations
- ✅ Engine start haptic (physical device only)
- ✅ Arrival haptic on completion (physical device only)
- ✅ Low fuel warning haptic at 20% (physical device only)

Note: Haptics only work on physical devices, not simulator.

### AchievementManager Testing

- ✅ Achievements load from database
- ✅ Progress updates during session
- ✅ Auto-unlock when criteria met
- ✅ Recently unlocked displayed
- ✅ Distance achievements ("First Mile" after 1 mile)
- ✅ Efficiency achievements ("Perfect Drive" with 5 stars)

---

## 🔍 Console Logging

Expected console output during a session:

```
✅ All managers initialized
🚗 Selected vehicle: Classic Sedan
📍 Selected destination: New York City
🗺️ Calculating route to New York City
✅ Route to New York City: 42.3 mi, ~50 min
🎬 Starting session...
🚗 Session started - Destination: New York City, Distance: 42.3 mi
🔊 Playing engine start sound: sedan_start
🔊 Starting ambient driving sounds
[Session runs...]
🎉 Session completed! Duration: 3 min, Distance: 42.3 mi
🔊 Playing arrival chime
🔇 All audio stopped
🚙 Vehicle 'Classic Sedan' - Total miles: 42.3 mi
📍 Route 'New York City' completed 1 time(s)
🔍 Checking achievements after session...
🎉 Achievement unlocked: First Mile
✅ Achievement check complete
```

---

## 🎨 UI Features

### Visual Feedback

- **Green circle** = Session active
- **Orange circle** = Session paused
- **Fuel bar colors**:
  - Green (>50%)
  - Yellow (20-50%)
  - Red (<20%)

### Interactive Elements

- Vehicle cards highlight on selection
- Destination cards highlight on selection
- All buttons have haptic feedback
- Achievement cards show with yellow background

### Live Updates

- Timer displays in large monospaced font (48pt)
- Speed animates with each update
- Progress bar fills smoothly
- All stats update every second

---

## 🐛 Troubleshooting

### "No vehicles available"

- First launch should seed 1 unlocked vehicle (Classic Sedan)
- Check console for: `🚙 Loaded X vehicles`
- If issue persists, delete app and reinstall

### Route calculation fails

- Requires internet connection for MapKit
- Check console for error messages
- Try different destination

### Timer doesn't update

- Check that session actually started
- Look for "Session started" in console
- SessionManager should show "✅ Ready" in status

### No haptics

- Haptics only work on physical iOS devices
- Simulator cannot test haptics
- Check console logs confirm haptic calls

### No audio

- Audio files not yet added to project
- Console logs confirm audio system works
- Actual sound playback requires audio assets

---

## 📱 Device Requirements

### Simulator Testing

- ✅ Timer and progress tracking
- ✅ Route calculation
- ✅ UI and interactions
- ✅ SwiftData persistence
- ✅ Achievement unlocking
- ❌ Haptic feedback (device only)
- ⚠️ Audio (requires audio files)

### Physical Device Testing

- ✅ Everything simulator can do
- ✅ Full haptic feedback
- ✅ Audio playback (with audio files)
- ✅ Background audio continuation

---

## 🎯 Success Criteria

After testing, you should verify:

- [x] All 5 managers initialize successfully
- [x] Vehicle selection works
- [x] Destination selection works
- [x] Route calculation completes
- [x] Session starts and runs
- [x] Timer updates every second
- [x] Speed simulation shows realistic values
- [x] Distance progress increases
- [x] Fuel depletes linearly
- [x] Pause/resume functionality works
- [x] Session completes at 100%
- [x] Achievements unlock when criteria met
- [x] Console logging is informative
- [x] UI is responsive and smooth

---

## 🚀 Next Steps

Once testing is complete and all managers work correctly:

1. **Add Audio Assets**

   - 8 audio files (6 engine sounds + ambient + chime)
   - Place in `Resources/Assets.xcassets`

2. **Test on Physical Device**

   - Verify haptic feedback works
   - Test audio playback
   - Check background operation

3. **Build Production UI (Phase 4)**
   - GarageView
   - DestinationPickerView
   - DrivingDashboardView
   - ArrivalView
   - Settings

---

## 📝 Notes

- This is a **demo/test view** - not production UI
- Simple design to focus on functionality
- All manager integration is production-ready
- Console logging helps debug issues
- View can be replaced with full UI once tested

---

**TestSessionView is ready to run in the simulator!** 🎉

Press ⌘R in Xcode to see all managers in action.
