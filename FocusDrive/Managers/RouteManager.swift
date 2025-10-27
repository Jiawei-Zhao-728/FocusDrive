import Foundation
import MapKit
import SwiftData

/// Manages route calculation, destination management, and unlocking logic
@Observable
final class RouteManager {
    // MARK: - Properties
    var availableDestinations: [Destination] = []
    var savedRoutes: [Route] = []
    var isCalculatingRoute: Bool = false
    
    private let modelContext: ModelContext
    
    // MARK: - Initialization
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        loadDestinations()
        loadRoutes()
    }
    
    // MARK: - Route Calculation
    
    /// Calculates a route from origin to destination using MapKit
    /// - Parameters:
    ///   - origin: Starting coordinate
    ///   - destination: Ending coordinate
    ///   - completion: Callback with calculated route or nil if failed
    func calculateRoute(
        from origin: CLLocationCoordinate2D,
        to destination: CLLocationCoordinate2D,
        completion: @escaping (Route?) -> Void
    ) {
        isCalculatingRoute = true
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: origin))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination))
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        
        print("🗺️ Calculating route from \(origin.latitude), \(origin.longitude) to \(destination.latitude), \(destination.longitude)")
        
        directions.calculate { [weak self] response, error in
            guard let self = self else { return }
            
            self.isCalculatingRoute = false
            
            if let error = error {
                print("❌ Route calculation error: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let mkRoute = response?.routes.first else {
                print("❌ No routes found")
                completion(nil)
                return
            }
            
            // Convert MKRoute to our Route model
            let distanceMiles = mkRoute.distance * AppConstants.metersToMiles
            let durationMinutes = Int(mkRoute.expectedTravelTime / 60)
            
            let newRoute = Route(
                originName: "Current Location",
                destinationName: "Selected Destination",
                originCoordinate: origin,
                destinationCoordinate: destination,
                distanceMiles: distanceMiles,
                estimatedDurationMinutes: durationMinutes
            )
            
            // Save route to SwiftData
            self.modelContext.insert(newRoute)
            try? self.modelContext.save()
            self.savedRoutes.append(newRoute)
            
            print("✅ Route calculated: \(distanceMiles.formattedMiles), ~\(durationMinutes) min")
            
            completion(newRoute)
        }
    }
    
    /// Calculates a route to a destination from a given origin
    /// - Parameters:
    ///   - destination: Destination object
    ///   - origin: Starting coordinate
    ///   - completion: Callback with calculated route
    func calculateRoute(
        to destination: Destination,
        from origin: CLLocationCoordinate2D,
        completion: @escaping (Route?) -> Void
    ) {
        isCalculatingRoute = true
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: origin))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination.coordinate))
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        
        print("🗺️ Calculating route to \(destination.name)")
        
        directions.calculate { [weak self] response, error in
            guard let self = self else { return }
            
            self.isCalculatingRoute = false
            
            if let error = error {
                print("❌ Route calculation error: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let mkRoute = response?.routes.first else {
                print("❌ No routes found to \(destination.name)")
                completion(nil)
                return
            }
            
            // Convert MKRoute to our Route model
            let distanceMiles = mkRoute.distance * AppConstants.metersToMiles
            let durationMinutes = Int(mkRoute.expectedTravelTime / 60)
            
            let newRoute = Route(
                originName: "Current Location",
                destinationName: destination.name,
                originCoordinate: origin,
                destinationCoordinate: destination.coordinate,
                distanceMiles: distanceMiles,
                estimatedDurationMinutes: durationMinutes
            )
            
            // Save route to SwiftData
            self.modelContext.insert(newRoute)
            try? self.modelContext.save()
            self.savedRoutes.append(newRoute)
            
            print("✅ Route to \(destination.name): \(distanceMiles.formattedMiles), ~\(durationMinutes) min")
            
            completion(newRoute)
        }
    }
    
    // MARK: - Destination Management
    
    /// Searches for destinations using natural language query
    /// - Parameter query: Search string (e.g., "coffee shop", "New York")
    /// - Returns: Array of matching destinations
    func searchDestinations(query: String) async -> [Destination] {
        guard !query.isEmpty else { return [] }
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        
        let search = MKLocalSearch(request: request)
        
        print("🔍 Searching destinations for: \(query)")
        
        do {
            let response = try await search.start()
            let destinations = response.mapItems.map { item in
                Destination(
                    name: item.name ?? "Unknown",
                    coordinate: item.placemark.coordinate,
                    category: .general,
                    description: item.placemark.title
                )
            }
            
            print("✅ Found \(destinations.count) destinations for '\(query)'")
            return destinations
        } catch {
            print("❌ Search error: \(error.localizedDescription)")
            return []
        }
    }
    
    /// Unlocks a new destination (adds to available destinations)
    /// - Parameter destination: Destination to unlock
    func unlockDestination(_ destination: Destination) {
        // Check if already unlocked
        guard !availableDestinations.contains(where: { $0.id == destination.id }) else {
            print("⚠️ Destination '\(destination.name)' already unlocked")
            return
        }
        
        availableDestinations.append(destination)
        print("🔓 Unlocked destination: \(destination.name)")
    }
    
    /// Filters destinations by category
    /// - Parameter category: Category to filter by
    /// - Returns: Array of destinations in that category
    func destinations(for category: DestinationCategory) -> [Destination] {
        return availableDestinations.filter { $0.category == category }
    }
    
    /// Gets nearby destinations to a given coordinate
    /// - Parameters:
    ///   - coordinate: Center coordinate
    ///   - radiusMiles: Search radius in miles
    /// - Returns: Array of nearby destinations
    func nearbyDestinations(
        to coordinate: CLLocationCoordinate2D,
        within radiusMiles: Double = 500
    ) -> [Destination] {
        return SeedData.nearbyDestinations(to: coordinate, within: radiusMiles)
    }
    
    /// Gets destinations sorted by distance from a coordinate
    /// - Parameter coordinate: Reference coordinate
    /// - Returns: Array of destinations sorted by distance
    func destinationsSortedByDistance(from coordinate: CLLocationCoordinate2D) -> [Destination] {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        return availableDestinations.sorted { dest1, dest2 in
            let loc1 = CLLocation(latitude: dest1.latitude, longitude: dest1.longitude)
            let loc2 = CLLocation(latitude: dest2.latitude, longitude: dest2.longitude)
            return location.distance(from: loc1) < location.distance(from: loc2)
        }
    }
    
    /// Gets a random destination
    /// - Returns: Random destination or nil if none available
    func randomDestination() -> Destination? {
        return availableDestinations.randomElement()
    }
    
    // MARK: - Route Management
    
    /// Gets all completed routes
    /// - Returns: Array of completed routes
    func completedRoutes() -> [Route] {
        return savedRoutes.filter { $0.completed }
    }
    
    /// Gets routes to a specific destination
    /// - Parameter destinationName: Name of the destination
    /// - Returns: Array of matching routes
    func routes(to destinationName: String) -> [Route] {
        return savedRoutes.filter { $0.destinationName == destinationName }
    }
    
    /// Marks a route as completed
    /// - Parameter route: Route to mark as completed
    func markRouteCompleted(_ route: Route) {
        route.completed = true
        route.completionDate = Date()
        route.timesCompleted += 1
        try? modelContext.save()
        
        print("✅ Route to '\(route.destinationName)' marked as completed (\(route.timesCompleted)x)")
    }
    
    // MARK: - Statistics
    
    /// Total number of completed routes
    var totalCompletedRoutes: Int {
        completedRoutes().count
    }
    
    /// Total distance of all completed routes
    var totalDistanceTraveled: Double {
        completedRoutes().reduce(0) { $0 + $1.distanceMiles }
    }
    
    /// Number of unique destinations visited
    var uniqueDestinationsVisited: Int {
        Set(completedRoutes().map { $0.destinationName }).count
    }
    
    // MARK: - Private Methods
    
    /// Loads seed destinations from SeedData
    private func loadDestinations() {
        // Load all 50 initial destinations from seed data
        availableDestinations = SeedData.initialDestinations
        print("📍 Loaded \(availableDestinations.count) destinations from seed data")
        
        // Log category breakdown
        let citiesCount = availableDestinations.filter { $0.category == .city }.count
        let naturesCount = availableDestinations.filter { $0.category == .nature }.count
        let landmarksCount = availableDestinations.filter { $0.category == .landmark }.count
        let beachesCount = availableDestinations.filter { $0.category == .beach }.count
        let mountainsCount = availableDestinations.filter { $0.category == .mountain }.count
        
        print("  📊 Cities: \(citiesCount), Nature: \(naturesCount), Landmarks: \(landmarksCount), Beaches: \(beachesCount), Mountains: \(mountainsCount)")
    }
    
    /// Loads saved routes from SwiftData
    private func loadRoutes() {
        let descriptor = FetchDescriptor<Route>(
            sortBy: [SortDescriptor(\.completionDate, order: .reverse)]
        )
        savedRoutes = (try? modelContext.fetch(descriptor)) ?? []
        
        let completedCount = savedRoutes.filter { $0.completed }.count
        print("🛣️ Loaded \(savedRoutes.count) routes (\(completedCount) completed)")
    }
    
    /// Reloads routes from database (useful after updates)
    func reloadRoutes() {
        loadRoutes()
    }
}

