# Focus Drive - Technical Implementation Guide

## For AI Coding Assistants (Claude Code / Cursor)

---

## PROJECT OVERVIEW

**App Name:** Focus Drive  
**Platform:** iOS 17.0+  
**Language:** Swift 5.9+  
**UI Framework:** SwiftUI with UIKit integration for MapKit  
**Architecture:** MVVM with Combine  
**Minimum Viable Product (MVP) Scope:** Core focus timer with driving metaphor

---

## TECH STACK

### Core Technologies

- **SwiftUI** - Primary UI framework
- **UIKit** - MapKit integration, custom drawing
- **MapKit** - 3D route visualization
- **Core Haptics** - Tactile feedback engine
- **AVFoundation** - Audio engine for sounds/music
- **SwiftData** - Local data persistence (iOS 17+)
- **Screen Time API (FamilyControls)** - App blocking functionality
- **Combine** - Reactive data flow

### Additional Frameworks

- **WidgetKit** - Home screen widgets
- **ActivityKit** - Live Activities on lock screen
- **CloudKit** - iCloud sync (Premium feature, Phase 2)
- **StoreKit 2** - In-app purchases and subscriptions

### Development Tools

- **Xcode 15+**
- **Swift Package Manager** - Dependency management
- **Git** - Version control

---

## PROJECT STRUCTURE

```
FocusDrive/
├── FocusDriveApp.swift              # App entry point
├── Models/                           # Data models
│   ├── Session.swift
│   ├── Route.swift
│   ├── Vehicle.swift
│   ├── Postcard.swift
│   └── Achievement.swift
├── ViewModels/                       # Business logic
│   ├── GarageViewModel.swift
│   ├── SessionViewModel.swift
│   ├── RouteViewModel.swift
│   └── AnalyticsViewModel.swift
├── Views/                            # SwiftUI views
│   ├── Garage/
│   │   ├── GarageView.swift
│   │   └── VehicleCardView.swift
│   ├── RoutePlanning/
│   │   ├── DestinationPickerView.swift
│   │   └── RouteDetailView.swift
│   ├── Session/
│   │   ├── PreDriveChecklistView.swift
│   │   ├── DrivingDashboardView.swift
│   │   └── ArrivalView.swift
│   ├── Collection/
│   │   ├── PostcardCollectionView.swift
│   │   └── RouteMapView.swift
│   └── Settings/
│       └── SettingsView.swift
├── Managers/                         # Service layer
│   ├── SessionManager.swift
│   ├── RouteManager.swift
│   ├── AudioManager.swift
│   ├── HapticManager.swift
│   ├── BlockingManager.swift
│   └── AchievementManager.swift
├── UIKit/                            # UIKit components
│   ├── MapViewController.swift
│   └── DashboardGaugeView.swift
├── Resources/                        # Assets
│   ├── Assets.xcassets
│   │   ├── Colors/
│   │   ├── Images/
│   │   └── Sounds/
│   └── Localizable.strings
└── Utilities/                        # Helper code
    ├── Extensions/
    ├── Constants.swift
    └── Helpers.swift
```

---

## DATA MODELS (SwiftData)

### Session Model

```swift
import Foundation
import SwiftData

@Model
final class Session {
    @Attribute(.unique) var id: UUID
    var startTime: Date
    var endTime: Date?
    var vehicleID: UUID
    var routeID: UUID
    var distanceMiles: Double
    var durationMinutes: Int
    var completionStatus: CompletionStatus
    var fuelEfficiency: Int // 1-5 stars
    var breaksTaken: Int
    var focusQuality: Double // 0.0-1.0

    init(
        id: UUID = UUID(),
        startTime: Date = Date(),
        vehicleID: UUID,
        routeID: UUID,
        distanceMiles: Double
    ) {
        self.id = id
        self.startTime = startTime
        self.vehicleID = vehicleID
        self.routeID = routeID
        self.distanceMiles = distanceMiles
        self.durationMinutes = 0
        self.completionStatus = .active
        self.fuelEfficiency = 5
        self.breaksTaken = 0
        self.focusQuality = 1.0
    }
}

enum CompletionStatus: String, Codable {
    case active
    case completed
    case paused
    case abandoned
}
```

### Route Model

```swift
import Foundation
import SwiftData
import CoreLocation

@Model
final class Route {
    @Attribute(.unique) var id: UUID
    var originName: String
    var destinationName: String
    var originLatitude: Double
    var originLongitude: Double
    var destinationLatitude: Double
    var destinationLongitude: Double
    var distanceMiles: Double
    var estimatedDurationMinutes: Int
    var routeType: RouteType
    var completed: Bool
    var completionDate: Date?
    var timesCompleted: Int

    var originCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: originLatitude, longitude: originLongitude)
    }

    var destinationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: destinationLatitude, longitude: destinationLongitude)
    }

    init(
        id: UUID = UUID(),
        originName: String,
        destinationName: String,
        originCoordinate: CLLocationCoordinate2D,
        destinationCoordinate: CLLocationCoordinate2D,
        distanceMiles: Double,
        estimatedDurationMinutes: Int,
        routeType: RouteType = .highway
    ) {
        self.id = id
        self.originName = originName
        self.destinationName = destinationName
        self.originLatitude = originCoordinate.latitude
        self.originLongitude = originCoordinate.longitude
        self.destinationLatitude = destinationCoordinate.latitude
        self.destinationLongitude = destinationCoordinate.longitude
        self.distanceMiles = distanceMiles
        self.estimatedDurationMinutes = estimatedDurationMinutes
        self.routeType = routeType
        self.completed = false
        self.timesCompleted = 0
    }
}

enum RouteType: String, Codable {
    case highway
    case scenic
    case backroads
}
```

### Vehicle Model

```swift
import Foundation
import SwiftData

@Model
final class Vehicle {
    @Attribute(.unique) var id: UUID
    var name: String
    var type: VehicleType
    var unlocked: Bool
    var totalMilesDriven: Double
    var timesUsed: Int

    // Stats
    var speedRating: Int // 1-5
    var comfortRating: Int // 1-5
    var efficiencyRating: Int // 1-5

    init(
        id: UUID = UUID(),
        name: String,
        type: VehicleType,
        unlocked: Bool = false,
        speedRating: Int = 3,
        comfortRating: Int = 3,
        efficiencyRating: Int = 3
    ) {
        self.id = id
        self.name = name
        self.type = type
        self.unlocked = unlocked
        self.totalMilesDriven = 0
        self.timesUsed = 0
        self.speedRating = speedRating
        self.comfortRating = comfortRating
        self.efficiencyRating = efficiencyRating
    }
}

enum VehicleType: String, Codable, CaseIterable {
    case sedan
    case suv
    case truck
    case sportsCar
    case electricCar
    case vintageCar

    var displayName: String {
        switch self {
        case .sedan: return "Sedan"
        case .suv: return "SUV"
        case .truck: return "Truck"
        case .sportsCar: return "Sports Car"
        case .electricCar: return "Electric Car"
        case .vintageCar: return "Vintage Car"
        }
    }

    var systemImageName: String {
        switch self {
        case .sedan: return "car.fill"
        case .suv: return "suv.side.fill"
        case .truck: return "truck.box.fill"
        case .sportsCar: return "figure.racing"
        case .electricCar: return "bolt.car.fill"
        case .vintageCar: return "car.side.fill"
        }
    }
}
```

### Postcard Model

```swift
import Foundation
import SwiftData

@Model
final class Postcard {
    @Attribute(.unique) var id: UUID
    var destinationName: String
    var imageAssetName: String
    var earnedDate: Date
    var routeID: UUID
    var latitude: Double
    var longitude: Double

    init(
        id: UUID = UUID(),
        destinationName: String,
        imageAssetName: String,
        earnedDate: Date = Date(),
        routeID: UUID,
        latitude: Double,
        longitude: Double
    ) {
        self.id = id
        self.destinationName = destinationName
        self.imageAssetName = imageAssetName
        self.earnedDate = earnedDate
        self.routeID = routeID
        self.latitude = latitude
        self.longitude = longitude
    }
}
```

### Achievement Model

```swift
import Foundation
import SwiftData

@Model
final class Achievement {
    @Attribute(.unique) var id: String
    var name: String
    var description: String
    var iconName: String
    var unlocked: Bool
    var unlockedDate: Date?
    var progress: Double // 0.0-1.0
    var category: AchievementCategory

    init(
        id: String,
        name: String,
        description: String,
        iconName: String,
        category: AchievementCategory,
        unlocked: Bool = false,
        progress: Double = 0.0
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.iconName = iconName
        self.category = category
        self.unlocked = unlocked
        self.progress = progress
    }
}

enum AchievementCategory: String, Codable {
    case distance
    case consistency
    case exploration
    case efficiency
    case special
}
```

---

## MANAGERS (Service Layer)

### SessionManager

**Responsibility:** Manage active focus sessions, timer logic, completion tracking

```swift
import Foundation
import Combine
import SwiftData

@Observable
final class SessionManager {
    // MARK: - Published Properties
    var activeSession: Session?
    var isSessionActive: Bool = false
    var elapsedTime: TimeInterval = 0
    var currentSpeed: Double = 0 // mph, simulated based on activity
    var distanceProgress: Double = 0 // miles traveled
    var fuelRemaining: Double = 1.0 // 0.0-1.0

    // MARK: - Private Properties
    private var timer: Timer?
    private var sessionStartDate: Date?
    private let modelContext: ModelContext
    private let hapticManager: HapticManager
    private let audioManager: AudioManager

    // MARK: - Initialization
    init(
        modelContext: ModelContext,
        hapticManager: HapticManager,
        audioManager: AudioManager
    ) {
        self.modelContext = modelContext
        self.hapticManager = hapticManager
        self.audioManager = audioManager
    }

    // MARK: - Session Control
    func startSession(vehicle: Vehicle, route: Route) {
        let session = Session(
            vehicleID: vehicle.id,
            routeID: route.id,
            distanceMiles: route.distanceMiles
        )

        activeSession = session
        isSessionActive = true
        sessionStartDate = Date()

        // Start timer (updates every second)
        startTimer()

        // Play engine start sound
        audioManager.playEngineStart(vehicleType: vehicle.type)
        hapticManager.playEngineStart()

        // Start ambient driving sounds
        audioManager.startDrivingAmbient()

        // Save to database
        modelContext.insert(session)
        try? modelContext.save()
    }

    func pauseSession() {
        isSessionActive = false
        timer?.invalidate()
        audioManager.pauseAmbient()

        // Update session
        activeSession?.completionStatus = .paused
        try? modelContext.save()
    }

    func resumeSession() {
        isSessionActive = true
        startTimer()
        audioManager.resumeAmbient()

        activeSession?.completionStatus = .active
        try? modelContext.save()
    }

    func endSession(completed: Bool) {
        timer?.invalidate()
        isSessionActive = false

        guard let session = activeSession else { return }

        session.endTime = Date()
        session.completionStatus = completed ? .completed : .abandoned
        session.durationMinutes = Int(elapsedTime / 60)

        // Stop audio
        audioManager.stopAll()

        // Play completion sound if completed
        if completed {
            audioManager.playArrival()
            hapticManager.playArrival()
        }

        try? modelContext.save()

        // Reset state
        activeSession = nil
        elapsedTime = 0
        distanceProgress = 0
        fuelRemaining = 1.0
    }

    // MARK: - Private Methods
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateSession()
        }
    }

    private func updateSession() {
        guard let session = activeSession else { return }

        elapsedTime += 1.0

        // Calculate progress (distance / time)
        let totalDuration = Double(session.durationMinutes * 60)
        let progress = elapsedTime / totalDuration
        distanceProgress = session.distanceMiles * progress

        // Update fuel
        fuelRemaining = max(0, 1.0 - progress)

        // Simulate speed (50-70 mph cruising)
        currentSpeed = Double.random(in: 55...70)

        // Check for completion
        if progress >= 1.0 {
            endSession(completed: true)
        }
    }
}
```

### RouteManager

**Responsibility:** Calculate routes, manage destinations, unlocking logic

```swift
import Foundation
import MapKit
import SwiftData

@Observable
final class RouteManager {
    // MARK: - Properties
    var availableDestinations: [Destination] = []
    var savedRoutes: [Route] = []

    private let modelContext: ModelContext

    // MARK: - Initialization
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        loadDestinations()
        loadRoutes()
    }

    // MARK: - Route Calculation
    func calculateRoute(
        from origin: CLLocationCoordinate2D,
        to destination: CLLocationCoordinate2D,
        completion: @escaping (Route?) -> Void
    ) {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: origin))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination))
        request.transportType = .automobile

        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            guard let route = response?.routes.first else {
                completion(nil)
                return
            }

            // Convert MKRoute to our Route model
            let distanceMiles = route.distance * 0.000621371 // meters to miles
            let durationMinutes = Int(route.expectedTravelTime / 60)

            let newRoute = Route(
                originName: "Current Location",
                destinationName: "Selected Destination",
                originCoordinate: origin,
                destinationCoordinate: destination,
                distanceMiles: distanceMiles,
                estimatedDurationMinutes: durationMinutes
            )

            completion(newRoute)
        }
    }

    // MARK: - Destination Management
    func searchDestinations(query: String) async -> [Destination] {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query

        let search = MKLocalSearch(request: request)

        do {
            let response = try await search.start()
            return response.mapItems.map { item in
                Destination(
                    name: item.name ?? "Unknown",
                    coordinate: item.placemark.coordinate,
                    category: .general
                )
            }
        } catch {
            print("Search error: \(error)")
            return []
        }
    }

    func unlockDestination(_ destination: Destination) {
        // Add to available destinations
        availableDestinations.append(destination)
    }

    // MARK: - Private Methods
    private func loadDestinations() {
        // TODO: Load from initial seed data or user progress
        // For MVP, provide 50 starter destinations
        availableDestinations = SeedData.initialDestinations
    }

    private func loadRoutes() {
        let descriptor = FetchDescriptor<Route>()
        savedRoutes = (try? modelContext.fetch(descriptor)) ?? []
    }
}

// MARK: - Supporting Types
struct Destination: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
    let category: DestinationCategory
}

enum DestinationCategory {
    case city
    case nature
    case landmark
    case general
}
```

### AudioManager

**Responsibility:** Handle all audio playback (engine sounds, ambient, music)

```swift
import AVFoundation

@Observable
final class AudioManager {
    // MARK: - Audio Players
    private var enginePlayer: AVAudioPlayer?
    private var ambientPlayer: AVAudioPlayer?
    private var effectsPlayer: AVAudioPlayer?

    // MARK: - Engine Sounds
    func playEngineStart(vehicleType: VehicleType) {
        let soundName: String
        switch vehicleType {
        case .sedan: soundName = "sedan_start"
        case .suv: soundName = "suv_start"
        case .truck: soundName = "truck_start"
        case .sportsCar: soundName = "sports_start"
        case .electricCar: soundName = "electric_start"
        case .vintageCar: soundName = "vintage_start"
        }

        playSound(soundName, player: &effectsPlayer, loop: false)
    }

    func startDrivingAmbient() {
        playSound("highway_ambient", player: &ambientPlayer, loop: true)
        ambientPlayer?.volume = 0.3
    }

    func pauseAmbient() {
        ambientPlayer?.pause()
    }

    func resumeAmbient() {
        ambientPlayer?.play()
    }

    func playArrival() {
        playSound("arrival_chime", player: &effectsPlayer, loop: false)
    }

    func stopAll() {
        enginePlayer?.stop()
        ambientPlayer?.stop()
        effectsPlayer?.stop()
    }

    // MARK: - Private Helpers
    private func playSound(_ name: String, player: inout AVAudioPlayer?, loop: Bool) {
        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else {
            print("Audio file not found: \(name)")
            return
        }

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.numberOfLoops = loop ? -1 : 0
            player?.prepareToPlay()
            player?.play()
        } catch {
            print("Error playing sound: \(error)")
        }
    }
}
```

### HapticManager

**Responsibility:** Generate haptic feedback for interactions

```swift
import CoreHaptics

final class HapticManager {
    private var engine: CHHapticEngine?

    init() {
        setupHaptics()
    }

    private func setupHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("Haptic engine error: \(error)")
        }
    }

    // MARK: - Haptic Patterns
    func playEngineStart() {
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)

        let event = CHHapticEvent(
            eventType: .hapticContinuous,
            parameters: [intensity, sharpness],
            relativeTime: 0,
            duration: 1.5
        )

        playPattern([event])
    }

    func playSeatbeltClick() {
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.8)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1.0)

        let event = CHHapticEvent(
            eventType: .hapticTransient,
            parameters: [intensity, sharpness],
            relativeTime: 0
        )

        playPattern([event])
    }

    func playArrival() {
        // Three quick pulses for arrival celebration
        let events = (0..<3).map { i in
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.9)
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.7)

            return CHHapticEvent(
                eventType: .hapticTransient,
                parameters: [intensity, sharpness],
                relativeTime: TimeInterval(i) * 0.2
            )
        }

        playPattern(events)
    }

    private func playPattern(_ events: [CHHapticEvent]) {
        guard let engine = engine else { return }

        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: CHHapticTimeImmediate)
        } catch {
            print("Haptic playback error: \(error)")
        }
    }
}
```

### BlockingManager

**Responsibility:** Manage app blocking via Screen Time API

```swift
import FamilyControls
import ManagedSettings

@Observable
final class BlockingManager {
    var isBlocking: Bool = false
    var blockedCategories: Set<ActivityCategoryToken> = []

    private let store = ManagedSettingsStore()

    // MARK: - Authorization
    func requestAuthorization() async -> Bool {
        do {
            try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
            return true
        } catch {
            print("Authorization failed: \(error)")
            return false
        }
    }

    // MARK: - Blocking Control
    func startBlocking(categories: Set<ActivityCategoryToken>) {
        blockedCategories = categories

        // Apply restrictions
        store.shield.applicationCategories = .specific(categories)
        isBlocking = true
    }

    func stopBlocking() {
        // Remove restrictions
        store.shield.applicationCategories = nil
        isBlocking = false
    }
}
```

---

## KEY VIEWS (SwiftUI)

### GarageView

**Main screen showing vehicle collection**

```swift
import SwiftUI
import SwiftData

struct GarageView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Vehicle.totalMilesDriven, order: .reverse) private var vehicles: [Vehicle]

    @State private var selectedVehicle: Vehicle?
    @State private var showingDestinationPicker = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Header Stats
                    StatsHeaderView()

                    // Vehicle Grid
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 16) {
                        ForEach(vehicles.filter { $0.unlocked }) { vehicle in
                            VehicleCardView(vehicle: vehicle)
                                .onTapGesture {
                                    selectedVehicle = vehicle
                                    showingDestinationPicker = true
                                }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Garage")
            .navigationDestination(isPresented: $showingDestinationPicker) {
                if let vehicle = selectedVehicle {
                    DestinationPickerView(vehicle: vehicle)
                }
            }
        }
    }
}

struct VehicleCardView: View {
    let vehicle: Vehicle

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: vehicle.type.systemImageName)
                .font(.system(size: 50))
                .foregroundStyle(.blue)

            Text(vehicle.name)
                .font(.headline)

            Text("\(Int(vehicle.totalMilesDriven)) mi")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct StatsHeaderView: View {
    @Query private var sessions: [Session]

    private var totalMiles: Double {
        sessions.reduce(0) { $0 + $1.distanceMiles }
    }

    private var completedSessions: Int {
        sessions.filter { $0.completionStatus == .completed }.count
    }

    var body: some View {
        HStack(spacing: 40) {
            StatItem(label: "Total Miles", value: "\(Int(totalMiles))")
            StatItem(label: "Drives", value: "\(completedSessions)")
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal)
    }
}

struct StatItem: View {
    let label: String
    let value: String

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title.bold())
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}
```

### DestinationPickerView

**Map-based destination selection**

```swift
import SwiftUI
import MapKit

struct DestinationPickerView: View {
    let vehicle: Vehicle

    @State private var searchText = ""
    @State private var cameraPosition: MapCameraPosition = .automatic
    @State private var selectedLocation: CLLocationCoordinate2D?
    @State private var searchResults: [Destination] = []
    @State private var showingRouteDetail = false

    @StateObject private var routeManager: RouteManager

    init(vehicle: Vehicle) {
        self.vehicle = vehicle
        _routeManager = StateObject(wrappedValue: RouteManager(modelContext: /* inject */))
    }

    var body: some View {
        ZStack(alignment: .top) {
            // Map View
            Map(position: $cameraPosition) {
                // Show available destinations as markers
                ForEach(routeManager.availableDestinations) { destination in
                    Marker(destination.name, coordinate: destination.coordinate)
                        .tint(.blue)
                }
            }
            .mapStyle(.standard)

            // Search Bar
            VStack(spacing: 0) {
                SearchBar(text: $searchText, onSearch: performSearch)
                    .padding()
                    .background(.ultraThinMaterial)

                if !searchResults.isEmpty {
                    SearchResultsList(results: searchResults, onSelect: selectDestination)
                        .frame(maxHeight: 300)
                        .background(.ultraThinMaterial)
                }
            }
        }
        .navigationTitle("Choose Destination")
        .navigationDestination(isPresented: $showingRouteDetail) {
            if let location = selectedLocation {
                RouteDetailView(vehicle: vehicle, destination: location)
            }
        }
    }

    private func performSearch() {
        Task {
            searchResults = await routeManager.searchDestinations(query: searchText)
        }
    }

    private func selectDestination(_ destination: Destination) {
        selectedLocation = destination.coordinate
        searchResults = []
        showingRouteDetail = true
    }
}

struct SearchBar: View {
    @Binding var text: String
    let onSearch: () -> Void

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)

            TextField("Where are you heading?", text: $text)
                .textFieldStyle(.plain)
                .onSubmit(onSearch)

            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(12)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct SearchResultsList: View {
    let results: [Destination]
    let onSelect: (Destination) -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(results) { destination in
                    Button {
                        onSelect(destination)
                    } label: {
                        HStack {
                            Image(systemName: "mappin.circle.fill")
                                .foregroundStyle(.blue)
                            Text(destination.name)
                                .foregroundStyle(.primary)
                            Spacer()
                        }
                        .padding()
                    }
                    Divider()
                }
            }
        }
    }
}
```

### DrivingDashboardView

**Main session view with map and gauges**

```swift
import SwiftUI
import MapKit

struct DrivingDashboardView: View {
    @StateObject var sessionManager: SessionManager
    let route: Route
    let vehicle: Vehicle

    @State private var cameraPosition: MapCameraPosition = .automatic
    @State private var showingStats = false

    var body: some View {
        ZStack {
            // Background Map (top 60%)
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    MapView(
                        sessionManager: sessionManager,
                        route: route
                    )
                    .frame(height: geometry.size.height * 0.6)

                    // Dashboard (bottom 40%)
                    DashboardView(
                        sessionManager: sessionManager,
                        route: route
                    )
                    .frame(height: geometry.size.height * 0.4)
                    .background(Color.black)
                }
            }

            // Top Bar
            VStack {
                TopBarView(onEndSession: endSession)
                    .padding()
                    .background(.ultraThinMaterial)
                Spacer()
            }
        }
        .ignoresSafeArea()
        .onAppear {
            sessionManager.startSession(vehicle: vehicle, route: route)
        }
    }

    private func endSession() {
        sessionManager.endSession(completed: false)
        // Navigate back
    }
}

struct MapView: View {
    @ObservedObject var sessionManager: SessionManager
    let route: Route

    @State private var cameraPosition: MapCameraPosition = .automatic

    var body: some View {
        Map(position: $cameraPosition) {
            // Route line
            MapPolyline(coordinates: [route.originCoordinate, route.destinationCoordinate])
                .stroke(.blue, lineWidth: 3)

            // Car position (animated based on progress)
            Annotation("", coordinate: currentPosition) {
                Image(systemName: "car.fill")
                    .font(.title)
                    .foregroundStyle(.blue)
                    .rotationEffect(heading)
            }
        }
        .mapStyle(.standard(elevation: .realistic))
    }

    private var currentPosition: CLLocationCoordinate2D {
        // Interpolate between origin and destination based on progress
        let progress = sessionManager.distanceProgress / route.distanceMiles
        let lat = route.originCoordinate.latitude +
                  (route.destinationCoordinate.latitude - route.originCoordinate.latitude) * progress
        let lon = route.originCoordinate.longitude +
                  (route.destinationCoordinate.longitude - route.originCoordinate.longitude) * progress
        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }

    private var heading: Angle {
        let dx = route.destinationCoordinate.longitude - route.originCoordinate.longitude
        let dy = route.destinationCoordinate.latitude - route.originCoordinate.latitude
        return Angle(radians: atan2(dy, dx))
    }
}

struct DashboardView: View {
    @ObservedObject var sessionManager: SessionManager
    let route: Route

    var body: some View {
        VStack(spacing: 20) {
            // Gauges Row
            HStack(spacing: 40) {
                // Speedometer
                GaugeView(
                    value: sessionManager.currentSpeed,
                    maxValue: 80,
                    unit: "MPH",
                    label: "SPEED"
                )

                // Distance Remaining
                VStack(spacing: 4) {
                    Text("\(Int(route.distanceMiles - sessionManager.distanceProgress))")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                    Text("miles to go")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(route.destinationName)
                        .font(.headline)
                        .foregroundStyle(.white)
                }

                // Fuel Gauge
                FuelGaugeView(fuelLevel: sessionManager.fuelRemaining)
            }
            .padding(.horizontal)

            // Time Remaining
            Text(timeRemainingFormatted)
                .font(.title3)
                .foregroundStyle(.white)
        }
        .padding()
    }

    private var timeRemainingFormatted: String {
        let totalSeconds = route.estimatedDurationMinutes * 60
        let remaining = Int(Double(totalSeconds) * sessionManager.fuelRemaining)
        let hours = remaining / 3600
        let minutes = (remaining % 3600) / 60

        if hours > 0 {
            return "\(hours)h \(minutes)m remaining"
        } else {
            return "\(minutes)m remaining"
        }
    }
}

struct GaugeView: View {
    let value: Double
    let maxValue: Double
    let unit: String
    let label: String

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                // Gauge background
                Circle()
                    .stroke(Color.white.opacity(0.2), lineWidth: 8)
                    .frame(width: 100, height: 100)

                // Gauge value
                Circle()
                    .trim(from: 0, to: value / maxValue)
                    .stroke(Color.blue, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .frame(width: 100, height: 100)
                    .rotationEffect(.degrees(-90))

                // Value text
                VStack(spacing: 0) {
                    Text("\(Int(value))")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                    Text(unit)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }

            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

struct FuelGaugeView: View {
    let fuelLevel: Double // 0.0-1.0

    var body: some View {
        VStack(spacing: 8) {
            ZStack(alignment: .bottom) {
                // Background
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 40, height: 100)

                // Fuel level
                RoundedRectangle(cornerRadius: 4)
                    .fill(fuelColor)
                    .frame(width: 40, height: 100 * fuelLevel)
            }

            Text("FUEL")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    private var fuelColor: Color {
        if fuelLevel > 0.5 {
            return .green
        } else if fuelLevel > 0.2 {
            return .yellow
        } else {
            return .red
        }
    }
}

struct TopBarView: View {
    let onEndSession: () -> Void

    var body: some View {
        HStack {
            Button {
                onEndSession()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.title3)
                    .foregroundStyle(.primary)
            }

            Spacer()

            Text("ROAD MODE ACTIVE")
                .font(.caption.bold())
                .foregroundStyle(.blue)

            Spacer()

            Button {
                // Settings
            } label: {
                Image(systemName: "gearshape")
                    .font(.title3)
                    .foregroundStyle(.primary)
            }
        }
    }
}
```

---

## MVP IMPLEMENTATION CHECKLIST

### Phase 1: Project Setup (Day 1-2)

- [ ] Create new Xcode project (iOS App)
- [ ] Set minimum deployment target to iOS 17.0
- [ ] Configure SwiftData model container
- [ ] Set up folder structure per above architecture
- [ ] Add required capabilities:
  - [ ] Maps
  - [ ] Family Controls (Screen Time)
  - [ ] Background Modes (Audio)
- [ ] Add Info.plist keys:
  - [ ] NSLocationWhenInUseUsageDescription
  - [ ] NSUserTrackingUsageDescription (for Screen Time)

### Phase 2: Data Layer (Day 3-4)

- [ ] Implement all SwiftData models (Session, Route, Vehicle, etc.)
- [ ] Create seed data for initial vehicles (3 types)
- [ ] Create seed data for initial destinations (50 locations)
- [ ] Implement model context injection in app entry point

### Phase 3: Core Managers (Day 5-7)

- [ ] SessionManager with timer logic
- [ ] RouteManager with MapKit integration
- [ ] AudioManager with AVFoundation
- [ ] HapticManager with Core Haptics
- [ ] BlockingManager with FamilyControls (if permission granted)

### Phase 4: Primary Views (Day 8-12)

- [ ] GarageView (vehicle selection)
- [ ] DestinationPickerView (map search)
- [ ] RouteDetailView (pre-drive checklist)
- [ ] DrivingDashboardView (main session UI)
- [ ] ArrivalView (completion screen)

### Phase 5: Audio & Haptics (Day 13-14)

- [ ] Add placeholder audio files (engine, ambient, effects)
- [ ] Implement haptic patterns for key interactions
- [ ] Test audio mixing and volume levels

### Phase 6: Polish & Testing (Day 15-18)

- [ ] Implement navigation flow between all views
- [ ] Add error handling and edge cases
- [ ] Test on multiple device sizes (iPhone 12-15)
- [ ] Test background operation and Lock Screen
- [ ] Optimize performance (battery, memory)

### Phase 7: Beta Testing (Day 19-21)

- [ ] Create TestFlight build
- [ ] Invite 10-20 beta testers
- [ ] Gather feedback and fix critical bugs
- [ ] Iterate on UX issues

---

## CRITICAL IMPLEMENTATION NOTES

### 1. MapKit Route Calculation

```swift
// Always use MKDirections for accurate distance/time
let directions = MKDirections(request: request)
directions.calculate { response, error in
    guard let route = response?.routes.first else { return }
    // Use route.distance and route.expectedTravelTime
}
```

### 2. SwiftData Threading

```swift
// Always use @MainActor for UI updates
@MainActor
func updateUI() {
    // SwiftData context operations
}
```

### 3. Screen Time API Authorization

```swift
// Must request authorization before blocking
try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
// Note: This requires extended Apple review (2-3 weeks)
```

### 4. Audio Session Configuration

```swift
// Configure for background playback
let audioSession = AVAudioSession.sharedInstance()
try audioSession.setCategory(.playback, mode: .default, options: [.mixWithOthers])
try audioSession.setActive(true)
```

### 5. Haptics Require Physical Device

```swift
// Simulator does not support haptics
// Always test on real device
```

---

## TESTING STRATEGY

### Unit Tests

- [ ] SessionManager timer accuracy
- [ ] RouteManager distance calculations
- [ ] Achievement unlock logic
- [ ] Data model persistence

### UI Tests

- [ ] Complete onboarding flow
- [ ] Start and complete a session
- [ ] Search and select destination
- [ ] View statistics

### Manual Testing Checklist

- [ ] Battery drain during 1-hour session
- [ ] Background audio continues when locked
- [ ] App blocking works correctly
- [ ] Haptics feel natural and not excessive
- [ ] Map animation is smooth (60fps)
- [ ] No memory leaks during extended use

---

## DEPLOYMENT CHECKLIST

### Pre-Submission

- [ ] Remove all debug logs
- [ ] Set build configuration to Release
- [ ] Update version and build numbers
- [ ] Generate App Store screenshots (6-8 per device size)
- [ ] Write App Store description
- [ ] Create 30-second preview video
- [ ] Prepare privacy nutrition label
- [ ] Add localization strings (if supporting multiple languages)

### App Store Connect

- [ ] Create app listing
- [ ] Upload build via Xcode
- [ ] Submit for review with detailed Screen Time API justification
- [ ] Set pricing (free with IAP)

### Post-Launch

- [ ] Monitor crash reports (Xcode Organizer)
- [ ] Respond to user reviews
- [ ] Track analytics (downloads, retention)
- [ ] Plan updates based on feedback

---

## NEXT STEPS FOR AI ASSISTANT

When implementing this project:

1. **Start with data models** - Get SwiftData working first
2. **Build SessionManager** - Core timer logic is foundation
3. **Create basic UI** - Start with GarageView, then add others
4. **Add MapKit integration** - Route calculation and display
5. **Implement audio/haptics** - Polish the experience
6. **Test extensively** - Especially battery and performance

**Recommended order of implementation:**

1. Models → 2. Managers → 3. Views → 4. Audio → 5. Haptics → 6. Polish

**When stuck:**

- Reference Apple documentation for MapKit, SwiftData, Core Haptics
- Check WWDC videos for best practices
- Test incrementally (don't build everything then test)

**This document provides:**
✅ Complete technical architecture  
✅ Code examples for key components  
✅ Step-by-step implementation checklist  
✅ Testing strategy  
✅ Deployment guidance

**Ready to build!** 🚀
