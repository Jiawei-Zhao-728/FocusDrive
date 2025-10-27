import Foundation
import CoreLocation

/// Provides seed data for initial destinations
struct SeedData {
    
    /// 50 curated destinations across the United States
    static let initialDestinations: [Destination] = [
        // MARK: - Major Cities (15)
        Destination(
            name: "New York City",
            latitude: 40.7128,
            longitude: -74.0060,
            category: .city,
            description: "The city that never sleeps"
        ),
        Destination(
            name: "Los Angeles",
            latitude: 34.0522,
            longitude: -118.2437,
            category: .city,
            description: "City of Angels"
        ),
        Destination(
            name: "Chicago",
            latitude: 41.8781,
            longitude: -87.6298,
            category: .city,
            description: "The Windy City"
        ),
        Destination(
            name: "San Francisco",
            latitude: 37.7749,
            longitude: -122.4194,
            category: .city,
            description: "The Golden City"
        ),
        Destination(
            name: "Miami",
            latitude: 25.7617,
            longitude: -80.1918,
            category: .city,
            description: "Magic City"
        ),
        Destination(
            name: "Seattle",
            latitude: 47.6062,
            longitude: -122.3321,
            category: .city,
            description: "The Emerald City"
        ),
        Destination(
            name: "Boston",
            latitude: 42.3601,
            longitude: -71.0589,
            category: .city,
            description: "Historic charm and innovation"
        ),
        Destination(
            name: "Austin",
            latitude: 30.2672,
            longitude: -97.7431,
            category: .city,
            description: "Live Music Capital of the World"
        ),
        Destination(
            name: "Denver",
            latitude: 39.7392,
            longitude: -104.9903,
            category: .city,
            description: "The Mile High City"
        ),
        Destination(
            name: "Portland",
            latitude: 45.5152,
            longitude: -122.6784,
            category: .city,
            description: "Keep Portland Weird"
        ),
        Destination(
            name: "Nashville",
            latitude: 36.1627,
            longitude: -86.7816,
            category: .city,
            description: "Music City USA"
        ),
        Destination(
            name: "Las Vegas",
            latitude: 36.1699,
            longitude: -115.1398,
            category: .city,
            description: "The Entertainment Capital"
        ),
        Destination(
            name: "New Orleans",
            latitude: 29.9511,
            longitude: -90.0715,
            category: .city,
            description: "The Big Easy"
        ),
        Destination(
            name: "San Diego",
            latitude: 32.7157,
            longitude: -117.1611,
            category: .city,
            description: "America's Finest City"
        ),
        Destination(
            name: "Phoenix",
            latitude: 33.4484,
            longitude: -112.0740,
            category: .city,
            description: "Valley of the Sun"
        ),
        
        // MARK: - National Parks (10)
        Destination(
            name: "Yosemite National Park",
            latitude: 37.8651,
            longitude: -119.5383,
            category: .nature,
            description: "Iconic granite cliffs and waterfalls"
        ),
        Destination(
            name: "Yellowstone National Park",
            latitude: 44.4280,
            longitude: -110.5885,
            category: .nature,
            description: "America's first national park"
        ),
        Destination(
            name: "Grand Canyon",
            latitude: 36.1069,
            longitude: -112.1129,
            category: .nature,
            description: "Spectacular natural wonder"
        ),
        Destination(
            name: "Zion National Park",
            latitude: 37.2982,
            longitude: -113.0263,
            category: .nature,
            description: "Red rock canyon paradise"
        ),
        Destination(
            name: "Arches National Park",
            latitude: 38.7331,
            longitude: -109.5925,
            category: .nature,
            description: "Natural stone arches and formations"
        ),
        Destination(
            name: "Acadia National Park",
            latitude: 44.3386,
            longitude: -68.2733,
            category: .nature,
            description: "Rocky coastline and mountain views"
        ),
        Destination(
            name: "Rocky Mountain National Park",
            latitude: 40.3428,
            longitude: -105.6836,
            category: .nature,
            description: "Alpine wilderness and wildlife"
        ),
        Destination(
            name: "Great Smoky Mountains",
            latitude: 35.6532,
            longitude: -83.5070,
            category: .nature,
            description: "Misty mountain ranges"
        ),
        Destination(
            name: "Olympic National Park",
            latitude: 47.8021,
            longitude: -123.6044,
            category: .nature,
            description: "Rainforests and rugged coastline"
        ),
        Destination(
            name: "Joshua Tree National Park",
            latitude: 33.8734,
            longitude: -115.9010,
            category: .nature,
            description: "Desert landscape and unique trees"
        ),
        
        // MARK: - Famous Landmarks (10)
        Destination(
            name: "Golden Gate Bridge",
            latitude: 37.8199,
            longitude: -122.4783,
            category: .landmark,
            description: "Iconic suspension bridge"
        ),
        Destination(
            name: "Statue of Liberty",
            latitude: 40.6892,
            longitude: -74.0445,
            category: .landmark,
            description: "Symbol of freedom"
        ),
        Destination(
            name: "Space Needle",
            latitude: 47.6205,
            longitude: -122.3493,
            category: .landmark,
            description: "Seattle's iconic tower"
        ),
        Destination(
            name: "Hollywood Sign",
            latitude: 34.1341,
            longitude: -118.3215,
            category: .landmark,
            description: "Iconic entertainment landmark"
        ),
        Destination(
            name: "Mount Rushmore",
            latitude: 43.8791,
            longitude: -103.4591,
            category: .landmark,
            description: "Presidential memorial"
        ),
        Destination(
            name: "Niagara Falls",
            latitude: 43.0962,
            longitude: -79.0377,
            category: .landmark,
            description: "Powerful waterfalls"
        ),
        Destination(
            name: "Key West",
            latitude: 24.5551,
            longitude: -81.7800,
            category: .landmark,
            description: "Southernmost point of the US"
        ),
        Destination(
            name: "Santa Monica Pier",
            latitude: 34.0092,
            longitude: -118.4974,
            category: .landmark,
            description: "Classic California pier"
        ),
        Destination(
            name: "Pike Place Market",
            latitude: 47.6097,
            longitude: -122.3425,
            category: .landmark,
            description: "Historic public market"
        ),
        Destination(
            name: "French Quarter",
            latitude: 29.9584,
            longitude: -90.0644,
            category: .landmark,
            description: "Heart of New Orleans"
        ),
        
        // MARK: - Beach Destinations (8)
        Destination(
            name: "Malibu Beach",
            latitude: 34.0259,
            longitude: -118.7798,
            category: .beach,
            description: "Stunning California coastline"
        ),
        Destination(
            name: "Outer Banks",
            latitude: 35.5585,
            longitude: -75.4665,
            category: .beach,
            description: "North Carolina barrier islands"
        ),
        Destination(
            name: "Maui",
            latitude: 20.7984,
            longitude: -156.3319,
            category: .beach,
            description: "Hawaiian paradise"
        ),
        Destination(
            name: "Clearwater Beach",
            latitude: 27.9659,
            longitude: -82.8001,
            category: .beach,
            description: "White sand beaches of Florida"
        ),
        Destination(
            name: "Cape Cod",
            latitude: 41.6688,
            longitude: -70.2962,
            category: .beach,
            description: "Classic New England beaches"
        ),
        Destination(
            name: "Laguna Beach",
            latitude: 33.5427,
            longitude: -117.7854,
            category: .beach,
            description: "Artistic beach community"
        ),
        Destination(
            name: "Waikiki Beach",
            latitude: 21.2793,
            longitude: -157.8293,
            category: .beach,
            description: "Famous Honolulu beach"
        ),
        Destination(
            name: "South Beach Miami",
            latitude: 25.7907,
            longitude: -80.1300,
            category: .beach,
            description: "Art Deco and beaches"
        ),
        
        // MARK: - Mountain Destinations (7)
        Destination(
            name: "Aspen",
            latitude: 39.1911,
            longitude: -106.8175,
            category: .mountain,
            description: "World-class ski resort"
        ),
        Destination(
            name: "Lake Tahoe",
            latitude: 39.0968,
            longitude: -120.0324,
            category: .mountain,
            description: "Alpine lake paradise"
        ),
        Destination(
            name: "Stowe",
            latitude: 44.4654,
            longitude: -72.6874,
            category: .mountain,
            description: "Vermont mountain charm"
        ),
        Destination(
            name: "Park City",
            latitude: 40.6461,
            longitude: -111.4980,
            category: .mountain,
            description: "Utah ski town"
        ),
        Destination(
            name: "Jackson Hole",
            latitude: 43.4799,
            longitude: -110.7624,
            category: .mountain,
            description: "Wyoming mountain resort"
        ),
        Destination(
            name: "Telluride",
            latitude: 37.9375,
            longitude: -107.8123,
            category: .mountain,
            description: "Colorado mountain town"
        ),
        Destination(
            name: "Big Sur",
            latitude: 36.2704,
            longitude: -121.8081,
            category: .mountain,
            description: "Dramatic coastal mountains"
        )
    ]
    
    // MARK: - Helper Methods
    
    /// Returns destinations filtered by category
    static func destinations(for category: DestinationCategory) -> [Destination] {
        initialDestinations.filter { $0.category == category }
    }
    
    /// Returns a random destination
    static func randomDestination() -> Destination? {
        initialDestinations.randomElement()
    }
    
    /// Returns nearby destinations to a given coordinate (within a radius in miles)
    static func nearbyDestinations(
        to coordinate: CLLocationCoordinate2D,
        within radiusMiles: Double = 500
    ) -> [Destination] {
        let radiusMeters = radiusMiles * AppConstants.milesToMeters
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        return initialDestinations.filter { destination in
            let destLocation = CLLocation(
                latitude: destination.latitude,
                longitude: destination.longitude
            )
            return location.distance(from: destLocation) <= radiusMeters
        }
    }
    
    /// Returns destinations sorted by distance from a coordinate
    static func destinationsSortedByDistance(from coordinate: CLLocationCoordinate2D) -> [Destination] {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        return initialDestinations.sorted { dest1, dest2 in
            let loc1 = CLLocation(latitude: dest1.latitude, longitude: dest1.longitude)
            let loc2 = CLLocation(latitude: dest2.latitude, longitude: dest2.longitude)
            return location.distance(from: loc1) < location.distance(from: loc2)
        }
    }
}

