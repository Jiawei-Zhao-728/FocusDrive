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

