import Foundation
import SwiftData

@Model
final class Achievement {
    @Attribute(.unique) var id: String
    var name: String
    var achievementDescription: String
    var iconName: String
    var unlocked: Bool
    var unlockedDate: Date?
    var progress: Double // 0.0-1.0
    var category: AchievementCategory

    init(
        id: String,
        name: String,
        achievementDescription: String,
        iconName: String,
        category: AchievementCategory,
        unlocked: Bool = false,
        progress: Double = 0.0
    ) {
        self.id = id
        self.name = name
        self.achievementDescription = achievementDescription
        self.iconName = iconName
        self.category = category
        self.unlocked = unlocked
        self.progress = progress
    }
}

enum AchievementCategory: String, Codable, Comparable {
    case distance
    case consistency
    case exploration
    case efficiency
    case special
    
    static func < (lhs: AchievementCategory, rhs: AchievementCategory) -> Bool {
        let order: [AchievementCategory] = [.distance, .consistency, .exploration, .efficiency, .special]
        guard let lhsIndex = order.firstIndex(of: lhs),
              let rhsIndex = order.firstIndex(of: rhs) else {
            return false
        }
        return lhsIndex < rhsIndex
    }
}

