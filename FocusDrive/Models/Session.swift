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

enum CompletionStatus: String, Codable, Comparable {
    case active
    case completed
    case paused
    case abandoned
    
    static func < (lhs: CompletionStatus, rhs: CompletionStatus) -> Bool {
        let order: [CompletionStatus] = [.active, .paused, .completed, .abandoned]
        guard let lhsIndex = order.firstIndex(of: lhs),
              let rhsIndex = order.firstIndex(of: rhs) else {
            return false
        }
        return lhsIndex < rhsIndex
    }
}

