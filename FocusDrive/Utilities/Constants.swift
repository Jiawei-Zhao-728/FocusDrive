import Foundation

// MARK: - App Constants
enum AppConstants {
    // MARK: - Timing
    static let timerUpdateInterval: TimeInterval = 1.0
    static let minimumSessionDuration: TimeInterval = 60 // 1 minute
    static let maximumSessionDuration: TimeInterval = 14400 // 4 hours
    
    // MARK: - Distance
    static let metersToMiles: Double = 0.000621371
    static let milesToMeters: Double = 1609.34
    
    // MARK: - Speed
    static let minSpeed: Double = 0
    static let maxSpeed: Double = 80 // mph
    static let cruiseSpeedMin: Double = 55
    static let cruiseSpeedMax: Double = 70
    
    // MARK: - Fuel
    static let fuelDepletionRate: Double = 0.0001 // per second
    static let lowFuelThreshold: Double = 0.2
    static let criticalFuelThreshold: Double = 0.1
    
    // MARK: - Vehicle Unlock Requirements
    static let milesForSUV: Double = 50
    static let milesForSportsCar: Double = 100
    static let milesForElectricCar: Double = 150
    static let milesForTruck: Double = 200
    static let milesForVintageCar: Double = 300
    
    // MARK: - Achievement Thresholds
    static let firstMileThreshold: Double = 1
    static let centuryClubThreshold: Double = 100
    static let roadWarriorThreshold: Double = 500
    static let explorerDestinations: Int = 10
    static let efficiencyMasterCount: Int = 10
    
    // MARK: - Audio
    static let ambientVolume: Float = 0.3
    static let effectsVolume: Float = 0.7
    static let musicVolume: Float = 0.5
    
    // MARK: - UI
    static let gaugeLineWidth: CGFloat = 8
    static let cardCornerRadius: CGFloat = 12
    static let defaultPadding: CGFloat = 16
    static let largeCardHeight: CGFloat = 200
}

