import Foundation
import CoreLocation

/// Represents a destination that users can select for their focus drive
struct Destination: Identifiable, Codable, Hashable {
    let id: UUID
    let name: String
    let latitude: Double
    let longitude: Double
    let category: DestinationCategory
    let description: String?
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init(
        id: UUID = UUID(),
        name: String,
        latitude: Double,
        longitude: Double,
        category: DestinationCategory,
        description: String? = nil
    ) {
        self.id = id
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.category = category
        self.description = description
    }
    
    /// Convenience initializer with CLLocationCoordinate2D
    init(
        id: UUID = UUID(),
        name: String,
        coordinate: CLLocationCoordinate2D,
        category: DestinationCategory,
        description: String? = nil
    ) {
        self.id = id
        self.name = name
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
        self.category = category
        self.description = description
    }
}

enum DestinationCategory: String, Codable, CaseIterable {
    case city
    case nature
    case landmark
    case beach
    case mountain
    case general
    
    var displayName: String {
        switch self {
        case .city: return "City"
        case .nature: return "Nature"
        case .landmark: return "Landmark"
        case .beach: return "Beach"
        case .mountain: return "Mountain"
        case .general: return "General"
        }
    }
    
    var iconName: String {
        switch self {
        case .city: return "building.2.fill"
        case .nature: return "leaf.fill"
        case .landmark: return "star.fill"
        case .beach: return "beach.umbrella.fill"
        case .mountain: return "mountain.2.fill"
        case .general: return "mappin.circle.fill"
        }
    }
}

