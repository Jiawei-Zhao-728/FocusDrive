import SwiftUI
import SwiftData
import CoreLocation

/// Test view to demonstrate all managers in action
struct TestSessionView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var vehicles: [Vehicle]
    @Query private var achievements: [Achievement]
    
    @State private var sessionManager: SessionManager?
    @State private var routeManager: RouteManager?
    @State private var achievementManager: AchievementManager?
    @State private var audioManager = AudioManager()
    @State private var hapticManager = HapticManager()
    
    @State private var selectedVehicle: Vehicle?
    @State private var selectedDestination: Destination?
    @State private var calculatedRoute: Route?
    @State private var isCalculatingRoute = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    headerSection
                    
                    // Vehicle Selection
                    vehicleSelectionSection
                    
                    // Destination Selection
                    destinationSelectionSection
                    
                    // Route Info
                    if let route = calculatedRoute {
                        routeInfoSection(route: route)
                    }
                    
                    // Start Button
                    if calculatedRoute != nil && sessionManager?.activeSession == nil {
                        startButton
                    }
                    
                    // Live Session Display
                    if let manager = sessionManager, manager.activeSession != nil {
                        liveSessionSection(manager: manager)
                        controlButtons(manager: manager)
                    }
                    
                    // Recently Unlocked Achievements
                    if let achManager = achievementManager, !achManager.recentlyUnlocked.isEmpty {
                        achievementsSection(manager: achManager)
                    }
                    
                    // Manager Stats
                    managerStatsSection
                }
                .padding()
            }
            .navigationTitle("Test Session Manager")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                setupManagers()
            }
        }
    }
    
    // MARK: - Header
    
    private var headerSection: some View {
        VStack(spacing: 8) {
            Image(systemName: "car.circle.fill")
                .font(.system(size: 60))
                .foregroundStyle(.blue)
            Text("Session Manager Demo")
                .font(.title2.bold())
            Text("Test all managers in action")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.blue.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    // MARK: - Vehicle Selection
    
    private var vehicleSelectionSection: some View {
        GroupBox {
            VStack(alignment: .leading, spacing: 12) {
                Label("Select Vehicle", systemImage: "car.fill")
                    .font(.headline)
                
                let unlockedVehicles = vehicles.filter { $0.unlocked }
                
                if unlockedVehicles.isEmpty {
                    Text("No vehicles available")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(unlockedVehicles) { vehicle in
                        Button {
                            selectedVehicle = vehicle
                            hapticManager.playSelection()
                            print("🚗 Selected vehicle: \(vehicle.name)")
                        } label: {
                            HStack {
                                Image(systemName: vehicle.type.systemImageName)
                                    .font(.title2)
                                VStack(alignment: .leading) {
                                    Text(vehicle.name)
                                        .font(.subheadline.bold())
                                    Text("\(Int(vehicle.totalMilesDriven)) miles driven")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                if selectedVehicle?.id == vehicle.id {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(.green)
                                }
                            }
                            .padding(12)
                            .background(selectedVehicle?.id == vehicle.id ? Color.blue.opacity(0.1) : Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }
    
    // MARK: - Destination Selection
    
    private var destinationSelectionSection: some View {
        GroupBox {
            VStack(alignment: .leading, spacing: 12) {
                Label("Select Destination", systemImage: "mappin.circle.fill")
                    .font(.headline)
                
                // Show first 5 destinations as examples
                let sampleDestinations = SeedData.initialDestinations.prefix(5)
                
                ForEach(Array(sampleDestinations)) { destination in
                    Button {
                        selectedDestination = destination
                        hapticManager.playSelection()
                        calculateRoute(to: destination)
                        print("📍 Selected destination: \(destination.name)")
                    } label: {
                        HStack {
                            Image(systemName: destination.category.iconName)
                                .font(.title3)
                                .frame(width: 30)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(destination.name)
                                    .font(.subheadline.bold())
                                Text(destination.category.displayName)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            if selectedDestination?.id == destination.id {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.green)
                            }
                        }
                        .padding(12)
                        .background(selectedDestination?.id == destination.id ? Color.blue.opacity(0.1) : Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .buttonStyle(.plain)
                }
                
                if isCalculatingRoute {
                    HStack {
                        ProgressView()
                        Text("Calculating route...")
                            .font(.caption)
                    }
                    .padding(.top, 8)
                }
            }
        }
    }
    
    // MARK: - Route Info
    
    private func routeInfoSection(route: Route) -> some View {
        GroupBox {
            VStack(alignment: .leading, spacing: 12) {
                Label("Route Calculated", systemImage: "map.fill")
                    .font(.headline)
                    .foregroundStyle(.green)
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Distance")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text(route.distanceMiles.formattedMiles)
                            .font(.title3.bold())
                    }
                    Spacer()
                    VStack(alignment: .leading) {
                        Text("Duration")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text("\(route.estimatedDurationMinutes) min")
                            .font(.title3.bold())
                    }
                    Spacer()
                    VStack(alignment: .leading) {
                        Text("Destination")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text(route.destinationName)
                            .font(.caption.bold())
                            .lineLimit(1)
                    }
                }
            }
        }
    }
    
    // MARK: - Start Button
    
    private var startButton: some View {
        Button {
            startSession()
        } label: {
            Label("Start Session", systemImage: "play.fill")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
    
    // MARK: - Live Session Display
    
    private func liveSessionSection(manager: SessionManager) -> some View {
        GroupBox {
            VStack(spacing: 16) {
                // Status
                HStack {
                    Circle()
                        .fill(manager.isSessionActive ? Color.green : Color.orange)
                        .frame(width: 12, height: 12)
                    Text(manager.isSessionActive ? "Session Active" : "Session Paused")
                        .font(.headline)
                    Spacer()
                }
                
                // Elapsed Time
                VStack(spacing: 4) {
                    Text("Elapsed Time")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(manager.elapsedTime.formattedTime)
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .monospacedDigit()
                }
                
                Divider()
                
                // Stats Grid
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    StatCard(
                        title: "Current Speed",
                        value: "\(Int(manager.currentSpeed))",
                        unit: "MPH",
                        icon: "speedometer"
                    )
                    
                    StatCard(
                        title: "Progress",
                        value: "\(manager.progressPercentage)",
                        unit: "%",
                        icon: "flag.fill"
                    )
                    
                    StatCard(
                        title: "Distance",
                        value: String(format: "%.1f", manager.distanceProgress),
                        unit: "mi",
                        icon: "location.fill"
                    )
                    
                    StatCard(
                        title: "Remaining",
                        value: String(format: "%.1f", manager.distanceRemaining),
                        unit: "mi",
                        icon: "arrow.forward"
                    )
                }
                
                // Fuel Gauge
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Label("Fuel", systemImage: "fuelpump.fill")
                            .font(.subheadline.bold())
                        Spacer()
                        Text("\(Int(manager.fuelRemaining * 100))%")
                            .font(.subheadline.bold())
                            .foregroundStyle(fuelColor(manager.fuelRemaining))
                    }
                    
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(.systemGray5))
                                .frame(height: 24)
                            
                            RoundedRectangle(cornerRadius: 8)
                                .fill(fuelColor(manager.fuelRemaining))
                                .frame(width: geometry.size.width * manager.fuelRemaining, height: 24)
                        }
                    }
                    .frame(height: 24)
                }
            }
        }
    }
    
    // MARK: - Control Buttons
    
    private func controlButtons(manager: SessionManager) -> some View {
        HStack(spacing: 12) {
            if manager.isSessionActive {
                Button {
                    manager.pauseSession()
                    hapticManager.playTap()
                    print("⏸️ Session paused")
                } label: {
                    Label("Pause", systemImage: "pause.fill")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            } else {
                Button {
                    manager.resumeSession()
                    hapticManager.playTap()
                    print("▶️ Session resumed")
                } label: {
                    Label("Resume", systemImage: "play.fill")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            
            Button {
                endSession(completed: false)
            } label: {
                Label("End", systemImage: "stop.fill")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }
    
    // MARK: - Achievements Section
    
    private func achievementsSection(manager: AchievementManager) -> some View {
        GroupBox {
            VStack(alignment: .leading, spacing: 12) {
                Label("Recently Unlocked!", systemImage: "trophy.fill")
                    .font(.headline)
                    .foregroundStyle(.yellow)
                
                ForEach(manager.recentlyUnlocked) { achievement in
                    HStack {
                        Image(systemName: achievement.iconName)
                            .font(.title2)
                            .foregroundStyle(.yellow)
                        VStack(alignment: .leading) {
                            Text(achievement.name)
                                .font(.subheadline.bold())
                            Text(achievement.achievementDescription)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                    }
                    .padding(12)
                    .background(Color.yellow.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
        }
    }
    
    // MARK: - Manager Stats
    
    private var managerStatsSection: some View {
        GroupBox {
            VStack(alignment: .leading, spacing: 12) {
                Label("Manager Status", systemImage: "gearshape.2.fill")
                    .font(.headline)
                
                VStack(alignment: .leading, spacing: 8) {
                    ManagerStatusRow(name: "SessionManager", status: sessionManager != nil ? "✅ Ready" : "⏳ Loading")
                    ManagerStatusRow(name: "RouteManager", status: routeManager != nil ? "✅ Ready" : "⏳ Loading")
                    ManagerStatusRow(name: "AudioManager", status: "✅ Ready")
                    ManagerStatusRow(name: "HapticManager", status: "✅ Ready")
                    ManagerStatusRow(name: "AchievementManager", status: achievementManager != nil ? "✅ Ready" : "⏳ Loading")
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func setupManagers() {
        sessionManager = SessionManager(
            modelContext: modelContext,
            hapticManager: hapticManager,
            audioManager: audioManager
        )
        
        routeManager = RouteManager(modelContext: modelContext)
        achievementManager = AchievementManager(modelContext: modelContext)
        
        print("✅ All managers initialized")
    }
    
    private func calculateRoute(to destination: Destination) {
        guard let routeManager = routeManager else { return }
        
        isCalculatingRoute = true
        
        // Use a default origin (San Francisco for demo)
        let origin = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
        
        routeManager.calculateRoute(to: destination, from: origin) { route in
            DispatchQueue.main.async {
                isCalculatingRoute = false
                calculatedRoute = route
                if route != nil {
                    hapticManager.playTap()
                }
            }
        }
    }
    
    private func startSession() {
        guard let vehicle = selectedVehicle,
              let route = calculatedRoute,
              let manager = sessionManager else {
            print("❌ Cannot start session: missing vehicle or route")
            return
        }
        
        print("🎬 Starting session...")
        manager.startSession(vehicle: vehicle, route: route)
    }
    
    private func endSession(completed: Bool) {
        guard let manager = sessionManager else { return }
        
        print("🏁 Ending session...")
        manager.endSession(completed: completed)
        
        // Check achievements
        if let session = manager.activeSession, let achManager = achievementManager {
            achManager.checkAchievements(after: session)
        }
        
        // Reset state
        calculatedRoute = nil
        selectedVehicle = nil
        selectedDestination = nil
    }
    
    private func fuelColor(_ fuel: Double) -> Color {
        if fuel > 0.5 {
            return .green
        } else if fuel > 0.2 {
            return .yellow
        } else {
            return .red
        }
    }
}

// MARK: - Supporting Views

struct StatCard: View {
    let title: String
    let value: String
    let unit: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.blue)
            
            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text(value)
                    .font(.title2.bold())
                    .monospacedDigit()
                Text(unit)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct ManagerStatusRow: View {
    let name: String
    let status: String
    
    var body: some View {
        HStack {
            Text(name)
                .font(.caption)
            Spacer()
            Text(status)
                .font(.caption.monospacedDigit())
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - Preview

#Preview {
    TestSessionView()
        .modelContainer(for: [Vehicle.self, Achievement.self, Session.self, Route.self])
}

