# FocusDrive - Xcode Project Setup Guide

## 🎯 Goal

Create a working Xcode project for FocusDrive and import all Swift files.

**Estimated Time:** 5-10 minutes

---

## 📋 Prerequisites

- macOS with Xcode 15+ installed
- All Swift files are in the current directory structure

---

## 🚀 Step-by-Step Setup

### Step 1: Create New Xcode Project

1. **Open Xcode**

   - Launch Xcode from Applications

2. **Create New Project**

   - Click "Create New Project" or File → New → Project (⇧⌘N)

3. **Choose Template**

   - Select **iOS** tab
   - Choose **App** template
   - Click **Next**

4. **Configure Project**

   - **Product Name:** `FocusDrive`
   - **Team:** Select your team (or leave as None)
   - **Organization Identifier:** `com.yourname` (replace with your name)
   - **Bundle Identifier:** Will auto-generate as `com.yourname.FocusDrive`
   - **Interface:** **SwiftUI**
   - **Language:** **Swift**
   - **Storage:** Check ✅ **Use SwiftData**
   - **Include Tests:** Uncheck (optional)
   - Click **Next**

5. **Choose Location**
   - Navigate to: `/Users/jiaweizhao/Downloads/Personal_Project/`
   - **IMPORTANT:** Save as `FocusDrive-Xcode` (different name to avoid conflict)
   - Click **Create**

---

### Step 2: Delete Default Files

Xcode creates some default files we don't need:

1. In the Project Navigator (left sidebar), **select and delete**:
   - `ContentView.swift` (click "Move to Trash")
   - `Item.swift` (click "Move to Trash")
   - `FocusDriveApp.swift` (click "Move to Trash" - we'll replace it)

---

### Step 3: Create Folder Structure

1. **Right-click** on the `FocusDrive` group (blue folder icon)
2. Select **New Group** for each of these:

   - `Models`
   - `Views`
   - `Managers`
   - `Utilities`
   - `Resources`

3. **Inside Views**, create sub-groups:

   - Right-click `Views` → New Group → `Garage`
   - Repeat for: `RoutePlanning`, `Session`, `Collection`, `Settings`

4. **Inside Utilities**, create sub-group:
   - Right-click `Utilities` → New Group → `Extensions`

Your structure should look like:

```
FocusDrive (project)
├── Models/
├── Views/
│   ├── Garage/
│   ├── RoutePlanning/
│   ├── Session/
│   ├── Collection/
│   └── Settings/
├── Managers/
├── Utilities/
│   └── Extensions/
└── Resources/
```

---

### Step 4: Add Swift Files

Now we'll import all the Swift files we created.

#### 4.1 Add FocusDriveApp.swift

1. **Right-click** the `FocusDrive` group (the top one)
2. Select **Add Files to "FocusDrive"...**
3. Navigate to: `/Users/jiaweizhao/Downloads/Personal_Project/FocusDrive/FocusDrive/`
4. Select `FocusDriveApp.swift`
5. Make sure **"Copy items if needed"** is checked
6. Make sure **"FocusDrive" target** is checked
7. Click **Add**

#### 4.2 Add Models

1. **Right-click** the `Models` group
2. Select **Add Files to "FocusDrive"...**
3. Navigate to: `/Users/jiaweizhao/Downloads/Personal_Project/FocusDrive/FocusDrive/Models/`
4. **Select ALL model files** (⌘-click to select multiple):
   - `Achievement.swift`
   - `Destination.swift`
   - `Postcard.swift`
   - `Route.swift`
   - `SeedData.swift`
   - `Session.swift`
   - `Vehicle.swift`
5. Check **"Copy items if needed"**
6. Check **"FocusDrive" target**
7. Click **Add**

#### 4.3 Add Managers

1. **Right-click** the `Managers` group
2. Select **Add Files to "FocusDrive"...**
3. Navigate to: `/Users/jiaweizhao/Downloads/Personal_Project/FocusDrive/FocusDrive/Managers/`
4. **Select ALL manager files**:
   - `SessionManager.swift`
   - `RouteManager.swift`
   - `AudioManager.swift`
   - `HapticManager.swift`
   - `BlockingManager.swift`
   - `AchievementManager.swift`
5. Check **"Copy items if needed"**
6. Check **"FocusDrive" target**
7. Click **Add**

#### 4.4 Add Utilities

1. **Right-click** the `Utilities` group
2. Select **Add Files to "FocusDrive"...**
3. Navigate to: `/Users/jiaweizhao/Downloads/Personal_Project/FocusDrive/FocusDrive/Utilities/`
4. **Select**:
   - `Constants.swift`
   - `Helpers.swift`
5. Check **"Copy items if needed"**
6. Check **"FocusDrive" target**
7. Click **Add**

#### 4.5 Add Extensions

1. **Right-click** the `Extensions` group (inside Utilities)
2. Select **Add Files to "FocusDrive"...**
3. Navigate to: `.../FocusDrive/FocusDrive/Utilities/Extensions/`
4. **Select**:
   - `Color+Extensions.swift`
   - `View+Extensions.swift`
5. Check **"Copy items if needed"**
6. Check **"FocusDrive" target**
7. Click **Add**

#### 4.6 Add TestSessionView

1. **Right-click** the `Views` group
2. Select **Add Files to "FocusDrive"...**
3. Navigate to: `.../FocusDrive/FocusDrive/Views/`
4. Select `TestSessionView.swift`
5. Check **"Copy items if needed"**
6. Check **"FocusDrive" target**
7. Click **Add**

---

### Step 5: Configure Project Settings

#### 5.1 Set Minimum iOS Version

1. Click on the **FocusDrive project** (blue icon at the top of Navigator)
2. Select the **FocusDrive target** (under TARGETS)
3. Click **General** tab
4. Under **Deployment Info**:
   - **Minimum Deployments:** Set to **iOS 17.0**

#### 5.2 Add Required Frameworks

1. Still in the **General** tab
2. Scroll to **Frameworks, Libraries, and Embedded Content**
3. Click the **+** button and add:

   - **MapKit.framework**
   - **CoreHaptics.framework**
   - **AVFoundation.framework**

4. For Screen Time API (optional, requires special entitlement):
   - We'll handle this separately as it requires Apple approval

#### 5.3 Configure Info.plist

1. Click on **FocusDrive** target
2. Click **Info** tab
3. Click **+** under **Custom iOS Target Properties**
4. Add these keys:

**Location Usage:**

- Key: `NSLocationWhenInUseUsageDescription`
- Value: `FocusDrive needs your location to calculate routes and suggest nearby destinations.`

**For future Screen Time API (optional):**

- Key: `NSUserTrackingUsageDescription`
- Value: `FocusDrive uses Screen Time API to help you focus by blocking distracting apps.`

---

### Step 6: Configure Capabilities (Optional)

These are optional but recommended for full functionality:

1. Click **FocusDrive** target
2. Click **Signing & Capabilities** tab
3. Click **+ Capability** and add:
   - **Maps** (for route calculation)
   - **Background Modes** → Check "Audio, AirPlay, and Picture in Picture"

**Note:** FamilyControls (Screen Time) requires special Apple approval and cannot be added without it.

---

### Step 7: Build and Run

1. **Select a simulator** from the scheme dropdown (top left)

   - Recommended: iPhone 15 Pro (iOS 17.0+)

2. **Build the project**

   - Press **⌘B** or Product → Build
   - Wait for build to complete
   - Fix any errors (there shouldn't be any)

3. **Run the app**
   - Press **⌘R** or Product → Run
   - Wait for simulator to launch
   - TestSessionView should appear!

---

## 🎉 Success!

If everything worked, you should see:

- TestSessionView with vehicle selection
- 5 sample destinations
- Working manager status indicators
- Ability to start and run a focus session

---

## 🐛 Troubleshooting

### Build Errors

**"Cannot find type 'Session' in scope"**

- Solution: Make sure all Model files were added correctly
- Check that files show up under FocusDrive target membership

**"No such module 'MapKit'"**

- Solution: Add MapKit framework (Step 5.2)
- Clean build folder (⇧⌘K) and rebuild

**"Cannot find 'SeedData' in scope"**

- Solution: Make sure `SeedData.swift` was added to the project
- Check it's in the Models group

**"Type 'Vehicle' has no member 'type'"**

- Solution: Make sure `Vehicle.swift` includes the full implementation
- Clean and rebuild

### Runtime Errors

**"Failed to initialize model container"**

- Solution: Make sure SwiftData was enabled when creating project
- Check all @Model classes are imported

**App crashes on launch**

- Solution: Check console for error messages
- Make sure FocusDriveApp.swift was added correctly
- Verify all seed data initialization works

**"No vehicles available"**

- Solution: Seed data didn't initialize
- Check console logs for SwiftData errors
- Delete app from simulator and reinstall

---

## 📱 Testing Checklist

Once running, verify:

- [ ] App launches without crashes
- [ ] TestSessionView appears
- [ ] Manager status shows "✅ Ready" for all managers
- [ ] One vehicle (Classic Sedan) is available
- [ ] 5 destinations are shown
- [ ] Can select vehicle and destination
- [ ] Route calculates successfully
- [ ] Session starts when tapping "Start Session"
- [ ] Timer updates every second
- [ ] Console shows detailed logs
- [ ] Achievements section appears after session

---

## 🔄 If Something Goes Wrong

### Nuclear Option: Start Fresh

1. Close Xcode
2. Delete the Xcode project folder
3. Follow this guide again from Step 1
4. Make sure to check "Copy items if needed" when adding files

### Verify File Structure

Your Xcode project should show:

```
FocusDrive
├── FocusDriveApp.swift
├── Models (7 files)
├── Managers (6 files)
├── Views
│   └── TestSessionView.swift
├── Utilities
│   ├── Constants.swift
│   ├── Helpers.swift
│   └── Extensions (2 files)
├── Resources
└── Assets.xcassets
```

---

## 🚀 Next Steps

### Once Project is Running:

1. **Test the Demo**

   - Follow TEST_VIEW_GUIDE.md
   - Start a session
   - Watch live updates
   - Verify console logging

2. **Add Audio Files (Optional)**

   - Import 8 audio files to Assets.xcassets
   - Test audio playback

3. **Test on Device (Optional)**

   - Connect iPhone
   - Run on device for haptic testing
   - Test background audio

4. **Build Production UI (Phase 4)**
   - GarageView
   - DestinationPickerView
   - DrivingDashboardView
   - ArrivalView

---

## 📝 Project Configuration Summary

| Setting             | Value                             |
| ------------------- | --------------------------------- |
| **Project Name**    | FocusDrive                        |
| **Bundle ID**       | com.yourname.FocusDrive           |
| **Min iOS Version** | 17.0                              |
| **Interface**       | SwiftUI                           |
| **Language**        | Swift                             |
| **Storage**         | SwiftData                         |
| **Frameworks**      | MapKit, CoreHaptics, AVFoundation |
| **Files**           | 18 Swift files                    |
| **Lines of Code**   | ~2,900+                           |

---

## ✅ Verification

After setup, your project should:

- ✅ Build without errors
- ✅ Run in simulator
- ✅ Show TestSessionView
- ✅ Have all 6 managers initialized
- ✅ Be able to start focus sessions
- ✅ Display live session updates
- ✅ Log detailed console output

---

**Project setup complete! You're ready to run FocusDrive in Xcode.** 🎉

Press ⌘R to see all your managers in action!
