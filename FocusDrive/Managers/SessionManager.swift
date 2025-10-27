import Foundation
import Combine
import SwiftData

/// Manages active focus sessions, timer logic, and completion tracking
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
    
    // Speed simulation properties
    private var baseSpeed: Double = 60.0
    private var speedVariation: Double = 0.0
    private var lastSpeedUpdate: Date = Date()
    
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
    
    /// Starts a new focus session with the selected vehicle and route
    func startSession(vehicle: Vehicle, route: Route) {
        // Create new session
        let session = Session(
            vehicleID: vehicle.id,
            routeID: route.id,
            distanceMiles: route.distanceMiles
        )
        
        activeSession = session
        isSessionActive = true
        sessionStartDate = Date()
        elapsedTime = 0
        distanceProgress = 0
        fuelRemaining = 1.0
        currentSpeed = 0
        
        // Start timer (updates every second)
        startTimer()
        
        // Play engine start sound
        audioManager.playEngineStart(vehicleType: vehicle.type)
        hapticManager.playEngineStart()
        
        // Start ambient driving sounds
        audioManager.startDrivingAmbient()
        
        // Update vehicle stats
        vehicle.timesUsed += 1
        
        // Save to database
        modelContext.insert(session)
        try? modelContext.save()
        
        print("🚗 Session started - Destination: \(route.destinationName), Distance: \(route.distanceMiles.formattedMiles)")
    }
    
    /// Pauses the current session
    func pauseSession() {
        guard activeSession != nil else { return }
        
        isSessionActive = false
        timer?.invalidate()
        timer = nil
        audioManager.pauseAmbient()
        
        // Update session status
        activeSession?.completionStatus = .paused
        try? modelContext.save()
        
        print("⏸️ Session paused - Elapsed: \(elapsedTime.formattedDuration)")
    }
    
    /// Resumes a paused session
    func resumeSession() {
        guard activeSession != nil else { return }
        
        isSessionActive = true
        startTimer()
        audioManager.resumeAmbient()
        
        activeSession?.completionStatus = .active
        try? modelContext.save()
        
        print("▶️ Session resumed")
    }
    
    /// Ends the current session
    /// - Parameter completed: Whether the session was completed successfully or abandoned
    func endSession(completed: Bool) {
        timer?.invalidate()
        timer = nil
        isSessionActive = false
        
        guard let session = activeSession else { return }
        
        // Update session properties
        session.endTime = Date()
        session.completionStatus = completed ? .completed : .abandoned
        session.durationMinutes = Int(elapsedTime / 60)
        
        // Update fuel efficiency based on completion
        if completed {
            session.fuelEfficiency = calculateFuelEfficiency()
        } else {
            session.fuelEfficiency = max(1, Int(fuelRemaining * 5))
        }
        
        // Update focus quality (based on completion and fuel efficiency)
        session.focusQuality = completed ? fuelRemaining : (fuelRemaining * 0.5)
        
        // Stop audio
        audioManager.stopAll()
        
        // Play completion sound and haptic if completed
        if completed {
            audioManager.playArrival()
            hapticManager.playArrival()
            print("🎉 Session completed! Duration: \(session.durationMinutes) min, Distance: \(session.distanceMiles.formattedMiles)")
        } else {
            print("❌ Session abandoned - Progress: \(Int(distanceProgress / session.distanceMiles * 100))%")
        }
        
        // Update vehicle with distance traveled
        updateVehicleStats(for: session)
        
        // Update route completion status
        updateRouteStats(for: session, completed: completed)
        
        // Save to database
        try? modelContext.save()
        
        // Reset state
        activeSession = nil
        elapsedTime = 0
        distanceProgress = 0
        fuelRemaining = 1.0
        currentSpeed = 0
    }
    
    // MARK: - Private Methods
    
    /// Starts the timer that updates session state every second
    private func startTimer() {
        timer = Timer.scheduledTimer(
            withTimeInterval: AppConstants.timerUpdateInterval,
            repeats: true
        ) { [weak self] _ in
            self?.updateSession()
        }
        
        // Ensure timer runs in common run loop modes (works during scrolling, etc.)
        RunLoop.current.add(timer!, forMode: .common)
    }
    
    /// Updates session state every second
    private func updateSession() {
        guard let session = activeSession, isSessionActive else { return }
        
        // Increment elapsed time
        elapsedTime += 1.0
        
        // Calculate progress (0.0 - 1.0)
        let totalDurationSeconds = Double(session.durationMinutes * 60)
        let estimatedDuration = (session.distanceMiles / 60.0) * 3600 // Assuming average 60 mph
        let progress = elapsedTime / estimatedDuration
        
        // Update distance progress
        distanceProgress = min(session.distanceMiles, session.distanceMiles * progress)
        
        // Update fuel (depletes linearly with progress)
        fuelRemaining = max(0.0, 1.0 - progress)
        
        // Update simulated speed with realistic variations
        updateSpeed()
        
        // Save session progress periodically (every 10 seconds)
        if Int(elapsedTime) % 10 == 0 {
            try? modelContext.save()
        }
        
        // Check for completion
        if progress >= 1.0 || fuelRemaining <= 0.0 {
            endSession(completed: true)
        }
        
        // Check for low fuel warning
        if fuelRemaining <= AppConstants.lowFuelThreshold && fuelRemaining > AppConstants.criticalFuelThreshold {
            if Int(elapsedTime) % 30 == 0 { // Every 30 seconds
                hapticManager.playLowFuelWarning()
            }
        }
    }
    
    /// Updates simulated speed with realistic variations
    private func updateSpeed() {
        // Update speed variation every 2-3 seconds
        let now = Date()
        if now.timeIntervalSince(lastSpeedUpdate) > Double.random(in: 2.0...3.0) {
            // Gradually change speed within cruise range
            let targetSpeed = Double.random(in: AppConstants.cruiseSpeedMin...AppConstants.cruiseSpeedMax)
            speedVariation = (targetSpeed - baseSpeed) * 0.3 // Smooth transition
            baseSpeed += speedVariation
            lastSpeedUpdate = now
        }
        
        // Add small random fluctuations
        let fluctuation = Double.random(in: -2.0...2.0)
        currentSpeed = max(AppConstants.minSpeed, min(AppConstants.maxSpeed, baseSpeed + fluctuation))
    }
    
    /// Calculates fuel efficiency rating (1-5 stars) based on session performance
    private func calculateFuelEfficiency() -> Int {
        // Higher fuel remaining = better efficiency
        if fuelRemaining >= 0.8 {
            return 5
        } else if fuelRemaining >= 0.6 {
            return 4
        } else if fuelRemaining >= 0.4 {
            return 3
        } else if fuelRemaining >= 0.2 {
            return 2
        } else {
            return 1
        }
    }
    
    /// Updates vehicle statistics after session ends
    private func updateVehicleStats(for session: Session) {
        // Find the vehicle used in this session
        let vehicleDescriptor = FetchDescriptor<Vehicle>()
        let vehicles = (try? modelContext.fetch(vehicleDescriptor)) ?? []
        
        if let vehicle = vehicles.first(where: { $0.id == session.vehicleID }) {
            vehicle.totalMilesDriven += session.distanceMiles
            print("🚙 Vehicle '\(vehicle.name)' - Total miles: \(vehicle.totalMilesDriven.formattedMiles)")
        }
    }
    
    /// Updates route statistics after session ends
    private func updateRouteStats(for session: Session, completed: Bool) {
        // Find the route used in this session
        let routeDescriptor = FetchDescriptor<Route>()
        let routes = (try? modelContext.fetch(routeDescriptor)) ?? []
        
        if let route = routes.first(where: { $0.id == session.routeID }) {
            if completed {
                route.completed = true
                route.completionDate = Date()
                route.timesCompleted += 1
                print("📍 Route '\(route.destinationName)' completed \(route.timesCompleted) time(s)")
            }
        }
    }
    
    // MARK: - Public Helpers
    
    /// Returns formatted time remaining in the session
    var timeRemaining: TimeInterval {
        guard let session = activeSession else { return 0 }
        let estimatedDuration = (session.distanceMiles / 60.0) * 3600 // Assuming average 60 mph
        return max(0, estimatedDuration - elapsedTime)
    }
    
    /// Returns progress percentage (0-100)
    var progressPercentage: Int {
        guard let session = activeSession else { return 0 }
        return Int((distanceProgress / session.distanceMiles) * 100)
    }
    
    /// Returns distance remaining in miles
    var distanceRemaining: Double {
        guard let session = activeSession else { return 0 }
        return max(0, session.distanceMiles - distanceProgress)
    }
    
    /// Returns whether fuel is critically low
    var isFuelCritical: Bool {
        return fuelRemaining <= AppConstants.criticalFuelThreshold
    }
    
    /// Returns whether fuel is running low
    var isFuelLow: Bool {
        return fuelRemaining <= AppConstants.lowFuelThreshold && !isFuelCritical
    }
}

