import SwiftUI
import SwiftData

@main
struct FocusDriveApp: App {
    // MARK: - SwiftData Model Container
    let modelContainer: ModelContainer
    
    init() {
        do {
            // Configure the SwiftData model container with all models
            modelContainer = try ModelContainer(
                for: Session.self,
                     Route.self,
                     Vehicle.self,
                     Postcard.self,
                     Achievement.self
            )
            
            // Seed initial data if needed
            seedInitialDataIfNeeded()
        } catch {
            fatalError("Failed to initialize model container: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            // Use TestSessionView to demo all managers
            TestSessionView()
        }
        .modelContainer(modelContainer)
    }
    
    // MARK: - Data Seeding
    private func seedInitialDataIfNeeded() {
        let context = modelContainer.mainContext
        
        // Check if vehicles already exist
        let vehicleDescriptor = FetchDescriptor<Vehicle>()
        let existingVehicles = (try? context.fetch(vehicleDescriptor)) ?? []
        
        // Seed initial vehicles if none exist
        if existingVehicles.isEmpty {
            seedInitialVehicles(context: context)
        }
        
        // Check if achievements already exist
        let achievementDescriptor = FetchDescriptor<Achievement>()
        let existingAchievements = (try? context.fetch(achievementDescriptor)) ?? []
        
        // Seed initial achievements if none exist
        if existingAchievements.isEmpty {
            seedInitialAchievements(context: context)
        }
        
        // Save context
        try? context.save()
    }
    
    private func seedInitialVehicles(context: ModelContext) {
        // Starter vehicle - unlocked by default
        let sedan = Vehicle(
            name: "Classic Sedan",
            type: .sedan,
            unlocked: true,
            speedRating: 3,
            comfortRating: 4,
            efficiencyRating: 4
        )
        context.insert(sedan)
        
        // Locked vehicles to unlock through progress
        let suv = Vehicle(
            name: "Adventure SUV",
            type: .suv,
            unlocked: false,
            speedRating: 3,
            comfortRating: 5,
            efficiencyRating: 3
        )
        context.insert(suv)
        
        let sportsCar = Vehicle(
            name: "Lightning Coupe",
            type: .sportsCar,
            unlocked: false,
            speedRating: 5,
            comfortRating: 3,
            efficiencyRating: 2
        )
        context.insert(sportsCar)
        
        let electricCar = Vehicle(
            name: "Eco Cruiser",
            type: .electricCar,
            unlocked: false,
            speedRating: 4,
            comfortRating: 4,
            efficiencyRating: 5
        )
        context.insert(electricCar)
        
        let truck = Vehicle(
            name: "Workhorse Truck",
            type: .truck,
            unlocked: false,
            speedRating: 2,
            comfortRating: 3,
            efficiencyRating: 2
        )
        context.insert(truck)
        
        let vintageCar = Vehicle(
            name: "Vintage Roadster",
            type: .vintageCar,
            unlocked: false,
            speedRating: 3,
            comfortRating: 2,
            efficiencyRating: 3
        )
        context.insert(vintageCar)
    }
    
    private func seedInitialAchievements(context: ModelContext) {
        let achievements = [
            // Distance achievements
            Achievement(
                id: "first_mile",
                name: "First Mile",
                achievementDescription: "Complete your first mile",
                iconName: "road.lanes",
                category: .distance
            ),
            Achievement(
                id: "century_club",
                name: "Century Club",
                achievementDescription: "Drive 100 total miles",
                iconName: "100.circle.fill",
                category: .distance
            ),
            Achievement(
                id: "road_warrior",
                name: "Road Warrior",
                achievementDescription: "Drive 500 total miles",
                iconName: "star.fill",
                category: .distance
            ),
            
            // Consistency achievements
            Achievement(
                id: "three_day_streak",
                name: "Three Day Streak",
                achievementDescription: "Complete drives on 3 consecutive days",
                iconName: "flame.fill",
                category: .consistency
            ),
            Achievement(
                id: "week_warrior",
                name: "Week Warrior",
                achievementDescription: "Complete drives on 7 consecutive days",
                iconName: "calendar",
                category: .consistency
            ),
            
            // Exploration achievements
            Achievement(
                id: "first_destination",
                name: "First Destination",
                achievementDescription: "Complete your first route",
                iconName: "mappin.circle.fill",
                category: .exploration
            ),
            Achievement(
                id: "explorer",
                name: "Explorer",
                achievementDescription: "Complete 10 different destinations",
                iconName: "map.fill",
                category: .exploration
            ),
            
            // Efficiency achievements
            Achievement(
                id: "perfect_drive",
                name: "Perfect Drive",
                achievementDescription: "Complete a drive with 5-star fuel efficiency",
                iconName: "gauge.high",
                category: .efficiency
            ),
            Achievement(
                id: "efficiency_master",
                name: "Efficiency Master",
                achievementDescription: "Maintain 5-star efficiency for 10 drives",
                iconName: "bolt.circle.fill",
                category: .efficiency
            )
        ]
        
        achievements.forEach { context.insert($0) }
    }
}

// MARK: - Temporary Content View
struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var vehicles: [Vehicle]
    @Query private var achievements: [Achievement]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    VStack(spacing: 8) {
                        Image(systemName: "car.fill")
                            .font(.system(size: 60))
                            .foregroundStyle(.blue)
                        Text("FocusDrive")
                            .font(.largeTitle.bold())
                        Text("Phase 2: Data Layer Complete ✅")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    
                    // Data Status
                    GroupBox("Data Status") {
                        VStack(alignment: .leading, spacing: 12) {
                            StatusRow(
                                icon: "car.fill",
                                title: "Vehicles",
                                count: vehicles.count,
                                detail: "\(vehicles.filter { $0.unlocked }.count) unlocked"
                            )
                            Divider()
                            StatusRow(
                                icon: "trophy.fill",
                                title: "Achievements",
                                count: achievements.count,
                                detail: "\(achievements.filter { $0.unlocked }.count) earned"
                            )
                            Divider()
                            StatusRow(
                                icon: "mappin.circle.fill",
                                title: "Destinations",
                                count: SeedData.initialDestinations.count,
                                detail: "Ready to explore"
                            )
                        }
                    }
                    .padding(.horizontal)
                    
                    // Destinations Preview
                    GroupBox("Sample Destinations") {
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(Array(SeedData.initialDestinations.prefix(5))) { destination in
                                HStack {
                                    Image(systemName: destination.category.iconName)
                                        .foregroundStyle(.blue)
                                        .frame(width: 30)
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(destination.name)
                                            .font(.subheadline.bold())
                                        if let description = destination.description {
                                            Text(description)
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                        }
                                    }
                                    Spacer()
                                    Text(destination.category.displayName)
                                        .font(.caption2)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color.blue.opacity(0.1))
                                        .clipShape(Capsule())
                                }
                                if destination.id != SeedData.initialDestinations.prefix(5).last?.id {
                                    Divider()
                                }
                            }
                            
                            Text("+ \(SeedData.initialDestinations.count - 5) more destinations")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.top, 4)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Next Steps
                    GroupBox("Next Phase") {
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Phase 3: Core Managers", systemImage: "gearshape.2.fill")
                                .font(.headline)
                            Text("Ready to implement SessionManager, RouteManager, AudioManager, HapticManager, and BlockingManager")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("Setup Status")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct StatusRow: View {
    let icon: String
    let title: String
    let count: Int
    let detail: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(.blue)
                .frame(width: 30)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline.bold())
                Text(detail)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Text("\(count)")
                .font(.title2.bold())
                .foregroundStyle(.blue)
        }
    }
}

