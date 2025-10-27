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

