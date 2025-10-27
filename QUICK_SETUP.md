# FocusDrive - Quick Setup Checklist

## ⚡️ 5-Minute Setup

### ✅ Step 1: Create Project (2 min)

1. Open Xcode → Create New Project
2. Choose: iOS → App
3. Settings:
   - Name: `FocusDrive`
   - Interface: `SwiftUI`
   - Storage: ✅ `SwiftData`
   - iOS: `17.0`
4. Save to new folder (e.g., `FocusDrive-Xcode`)

### ✅ Step 2: Delete Defaults (30 sec)

Delete these files:

- ❌ ContentView.swift
- ❌ Item.swift
- ❌ FocusDriveApp.swift (we'll replace it)

### ✅ Step 3: Create Groups (1 min)

Right-click FocusDrive → New Group:

- Models
- Managers
- Views
- Utilities
  - Extensions (sub-group)

### ✅ Step 4: Add Files (2 min)

**Models/** (7 files):

```
Achievement.swift
Destination.swift
Postcard.swift
Route.swift
SeedData.swift
Session.swift
Vehicle.swift
```

**Managers/** (6 files):

```
SessionManager.swift
RouteManager.swift
AudioManager.swift
HapticManager.swift
BlockingManager.swift
AchievementManager.swift
```

**Utilities/** (2 files):

```
Constants.swift
Helpers.swift
```

**Utilities/Extensions/** (2 files):

```
Color+Extensions.swift
View+Extensions.swift
```

**Views/** (1 file):

```
TestSessionView.swift
```

**Root/** (1 file):

```
FocusDriveApp.swift
```

### ✅ Step 5: Configure (30 sec)

1. Target → General → Minimum Deployments: `iOS 17.0`
2. Target → Info → Add:
   - `NSLocationWhenInUseUsageDescription`: "For route calculation"

### ✅ Step 6: Run! (30 sec)

- Press **⌘R**
- Select iPhone 15 Pro simulator
- TestSessionView should appear!

---

## 🎯 File Import Tips

When adding files:

- ✅ **Always check** "Copy items if needed"
- ✅ **Always check** FocusDrive target
- ✅ Add to correct group in Navigator
- ✅ Select multiple files with ⌘-click

---

## 📦 What You Should See

After import:

```
FocusDrive/
├── FocusDriveApp.swift          ✅
├── Models/                      ✅ 7 files
├── Managers/                    ✅ 6 files
├── Views/
│   └── TestSessionView.swift   ✅
├── Utilities/
│   ├── Constants.swift          ✅
│   ├── Helpers.swift            ✅
│   └── Extensions/              ✅ 2 files
└── Assets.xcassets              ✅
```

Total: **19 files** imported

---

## ✅ Success Indicators

When you run (⌘R):

- ✅ Builds without errors
- ✅ TestSessionView appears
- ✅ Shows "Classic Sedan" vehicle
- ✅ Shows 5 destinations
- ✅ All managers show "✅ Ready"
- ✅ Console logs appear

---

## 🚨 Common Issues

**Build Error:** "Cannot find type 'Session'"
→ Solution: Rebuild (⇧⌘K then ⌘B)

**No vehicles shown:**
→ Solution: Check FocusDriveApp.swift was added

**App crashes:**
→ Solution: Check console, verify all models added

---

## 📍 File Locations

All files are here:

```
/Users/jiaweizhao/Downloads/Personal_Project/FocusDrive/FocusDrive/
├── Models/
├── Managers/
├── Views/
├── Utilities/
└── FocusDriveApp.swift
```

---

## 🎉 You're Done!

Once running:

1. Select a vehicle
2. Pick a destination
3. Tap "Start Session"
4. Watch the magic happen! ✨

For detailed testing instructions, see: `TEST_VIEW_GUIDE.md`
