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

