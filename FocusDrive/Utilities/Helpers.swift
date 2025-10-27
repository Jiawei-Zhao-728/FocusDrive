import Foundation
import CoreLocation

// MARK: - Time Formatting
extension TimeInterval {
    /// Formats time interval as "Xh Ym" or "Ym" if less than an hour
    var formattedDuration: String {
        let totalSeconds = Int(self)
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
    
    /// Formats time interval as "HH:MM:SS"
    var formattedTime: String {
        let totalSeconds = Int(self)
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}

// MARK: - Distance Formatting
extension Double {
    /// Formats distance in miles with appropriate precision
    var formattedMiles: String {
        if self < 1 {
            return String(format: "%.1f mi", self)
        } else {
            return String(format: "%.0f mi", self)
        }
    }
    
    /// Formats speed in mph
    var formattedSpeed: String {
        return String(format: "%.0f mph", self)
    }
}

// MARK: - Date Formatting
extension Date {
    /// Returns relative date string (e.g., "Today", "Yesterday", "2 days ago")
    var relativeDateString: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }
    
    /// Returns formatted date string (e.g., "Jan 15, 2024")
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: self)
    }
}

// MARK: - Coordinate Distance Calculation
extension CLLocationCoordinate2D {
    /// Calculates distance in miles to another coordinate
    func distance(to coordinate: CLLocationCoordinate2D) -> Double {
        let location1 = CLLocation(latitude: latitude, longitude: longitude)
        let location2 = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let distanceMeters = location1.distance(from: location2)
        return distanceMeters * AppConstants.metersToMiles
    }
}

// MARK: - Star Rating Helper
struct StarRating {
    /// Converts a 1-5 rating to a star string representation
    static func stars(for rating: Int) -> String {
        let validRating = max(1, min(5, rating))
        return String(repeating: "⭐️", count: validRating)
    }
    
    /// Returns color for rating (green for high, red for low)
    static func colorForRating(_ rating: Int) -> String {
        switch rating {
        case 5: return "green"
        case 4: return "mint"
        case 3: return "yellow"
        case 2: return "orange"
        default: return "red"
        }
    }
}

// MARK: - Progress Calculation
struct ProgressCalculator {
    /// Calculates progress percentage (0.0 - 1.0) based on elapsed time and total duration
    static func progress(elapsedSeconds: TimeInterval, totalSeconds: TimeInterval) -> Double {
        guard totalSeconds > 0 else { return 0 }
        return min(1.0, max(0.0, elapsedSeconds / totalSeconds))
    }
    
    /// Calculates remaining time based on progress and total duration
    static func remainingTime(progress: Double, totalSeconds: TimeInterval) -> TimeInterval {
        return max(0, totalSeconds * (1.0 - progress))
    }
}

