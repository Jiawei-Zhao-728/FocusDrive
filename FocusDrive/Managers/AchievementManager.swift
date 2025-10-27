import Foundation
import SwiftData

/// Manages achievement tracking, unlocking, and progress updates
@Observable
final class AchievementManager {
    // MARK: - Properties
    var achievements: [Achievement] = []
    var recentlyUnlocked: [Achievement] = []
    
    private let modelContext: ModelContext
    
    // MARK: - Initialization
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        loadAchievements()
    }
    
    // MARK: - Achievement Loading
    
    /// Loads all achievements from SwiftData
    private func loadAchievements() {
        let descriptor = FetchDescriptor<Achievement>(
            sortBy: [SortDescriptor(\.progress, order: .reverse)]
        )
        let fetchedAchievements = (try? modelContext.fetch(descriptor)) ?? []
        
        // Sort by category in Swift code (SwiftData can't sort by enums)
        achievements = fetchedAchievements.sorted { $0.category < $1.category }
        
        print("🏆 Loaded \(achievements.count) achievements")
    }
    
    /// Reloads achievements from database
    func reloadAchievements() {
        loadAchievements()
    }
    
    // MARK: - Achievement Checking
    
    /// Checks and updates all achievements after a session completes
    /// - Parameter session: Completed session to check against
    func checkAchievements(after session: Session) {
        print("🔍 Checking achievements after session...")
        
        // Only check achievements for completed sessions
        guard session.completionStatus == .completed else {
            print("⚠️ Session not completed, skipping achievement check")
            return
        }
        
        // Get all necessary data for checking
        let allSessions = fetchAllCompletedSessions()
        let allRoutes = fetchAllRoutes()
        let totalMiles = calculateTotalMiles(from: allSessions)
        
        // Check each category of achievements
        checkDistanceAchievements(totalMiles: totalMiles)
        checkConsistencyAchievements(sessions: allSessions)
        checkExplorationAchievements(routes: allRoutes)
        checkEfficiencyAchievements(session: session, allSessions: allSessions)
        
        // Save any changes
        try? modelContext.save()
        
        print("✅ Achievement check complete")
    }
    
    // MARK: - Distance Achievements
    
    private func checkDistanceAchievements(totalMiles: Double) {
        // First Mile (1 mile)
        checkAndUnlock(
            achievementId: "first_mile",
            condition: totalMiles >= AppConstants.firstMileThreshold,
            progress: min(1.0, totalMiles / AppConstants.firstMileThreshold)
        )
        
        // Century Club (100 miles)
        checkAndUnlock(
            achievementId: "century_club",
            condition: totalMiles >= AppConstants.centuryClubThreshold,
            progress: min(1.0, totalMiles / AppConstants.centuryClubThreshold)
        )
        
        // Road Warrior (500 miles)
        checkAndUnlock(
            achievementId: "road_warrior",
            condition: totalMiles >= AppConstants.roadWarriorThreshold,
            progress: min(1.0, totalMiles / AppConstants.roadWarriorThreshold)
        )
    }
    
    // MARK: - Consistency Achievements
    
    private func checkConsistencyAchievements(sessions: [Session]) {
        let consecutiveDays = calculateConsecutiveDays(from: sessions)
        
        // Three Day Streak
        checkAndUnlock(
            achievementId: "three_day_streak",
            condition: consecutiveDays >= 3,
            progress: min(1.0, Double(consecutiveDays) / 3.0)
        )
        
        // Week Warrior (7 consecutive days)
        checkAndUnlock(
            achievementId: "week_warrior",
            condition: consecutiveDays >= 7,
            progress: min(1.0, Double(consecutiveDays) / 7.0)
        )
    }
    
    // MARK: - Exploration Achievements
    
    private func checkExplorationAchievements(routes: [Route]) {
        let completedRoutes = routes.filter { $0.completed }
        let uniqueDestinations = Set(completedRoutes.map { $0.destinationName }).count
        
        // First Destination
        checkAndUnlock(
            achievementId: "first_destination",
            condition: completedRoutes.count >= 1,
            progress: completedRoutes.count >= 1 ? 1.0 : 0.0
        )
        
        // Explorer (10 different destinations)
        checkAndUnlock(
            achievementId: "explorer",
            condition: uniqueDestinations >= AppConstants.explorerDestinations,
            progress: min(1.0, Double(uniqueDestinations) / Double(AppConstants.explorerDestinations))
        )
    }
    
    // MARK: - Efficiency Achievements
    
    private func checkEfficiencyAchievements(session: Session, allSessions: [Session]) {
        // Perfect Drive (5-star fuel efficiency)
        let isPerfectDrive = session.fuelEfficiency == 5
        checkAndUnlock(
            achievementId: "perfect_drive",
            condition: isPerfectDrive,
            progress: isPerfectDrive ? 1.0 : 0.0
        )
        
        // Efficiency Master (10 drives with 5-star efficiency)
        let perfectDrivesCount = allSessions.filter { $0.fuelEfficiency == 5 }.count
        checkAndUnlock(
            achievementId: "efficiency_master",
            condition: perfectDrivesCount >= AppConstants.efficiencyMasterCount,
            progress: min(1.0, Double(perfectDrivesCount) / Double(AppConstants.efficiencyMasterCount))
        )
    }
    
    // MARK: - Helper Methods
    
    /// Checks and unlocks an achievement if condition is met
    private func checkAndUnlock(achievementId: String, condition: Bool, progress: Double) {
        guard let achievement = achievements.first(where: { $0.id == achievementId }) else {
            return
        }
        
        // Update progress
        achievement.progress = progress
        
        // Unlock if condition met and not already unlocked
        if condition && !achievement.unlocked {
            achievement.unlocked = true
            achievement.unlockedDate = Date()
            recentlyUnlocked.append(achievement)
            
            print("🎉 Achievement unlocked: \(achievement.name)")
            
            // Keep only last 5 recently unlocked
            if recentlyUnlocked.count > 5 {
                recentlyUnlocked.removeFirst()
            }
        }
    }
    
    /// Fetches all completed sessions
    private func fetchAllCompletedSessions() -> [Session] {
        let descriptor = FetchDescriptor<Session>(
            sortBy: [SortDescriptor(\.startTime, order: .reverse)]
        )
        let allSessions = (try? modelContext.fetch(descriptor)) ?? []
        return allSessions.filter { $0.completionStatus == .completed }
    }
    
    /// Fetches all routes
    private func fetchAllRoutes() -> [Route] {
        let descriptor = FetchDescriptor<Route>()
        return (try? modelContext.fetch(descriptor)) ?? []
    }
    
    /// Calculates total miles from all sessions
    private func calculateTotalMiles(from sessions: [Session]) -> Double {
        return sessions.reduce(0) { $0 + $1.distanceMiles }
    }
    
    /// Calculates consecutive days with completed sessions
    private func calculateConsecutiveDays(from sessions: [Session]) -> Int {
        guard !sessions.isEmpty else { return 0 }
        
        // Get unique dates (ignoring time)
        let calendar = Calendar.current
        let uniqueDates = Set(sessions.map { calendar.startOfDay(for: $0.startTime) })
        let sortedDates = uniqueDates.sorted(by: >)
        
        guard let mostRecent = sortedDates.first else { return 0 }
        
        var consecutiveDays = 1
        var currentDate = mostRecent
        
        // Count backwards from most recent date
        for date in sortedDates.dropFirst() {
            let daysBetween = calendar.dateComponents([.day], from: date, to: currentDate).day ?? 0
            
            if daysBetween == 1 {
                consecutiveDays += 1
                currentDate = date
            } else {
                break
            }
        }
        
        return consecutiveDays
    }
    
    // MARK: - Public Queries
    
    /// Gets achievements by category
    func achievements(for category: AchievementCategory) -> [Achievement] {
        return achievements.filter { $0.category == category }
    }
    
    /// Gets all unlocked achievements
    func unlockedAchievements() -> [Achievement] {
        return achievements.filter { $0.unlocked }
    }
    
    /// Gets achievements in progress (not unlocked but have progress)
    func inProgressAchievements() -> [Achievement] {
        return achievements.filter { !$0.unlocked && $0.progress > 0 }
    }
    
    /// Gets locked achievements (no progress yet)
    func lockedAchievements() -> [Achievement] {
        return achievements.filter { !$0.unlocked && $0.progress == 0 }
    }
    
    /// Gets a specific achievement by ID
    func achievement(withId id: String) -> Achievement? {
        return achievements.first { $0.id == id }
    }
    
    // MARK: - Statistics
    
    /// Total number of unlocked achievements
    var unlockedCount: Int {
        achievements.filter { $0.unlocked }.count
    }
    
    /// Total number of achievements
    var totalCount: Int {
        achievements.count
    }
    
    /// Percentage of achievements unlocked (0-100)
    var completionPercentage: Int {
        guard totalCount > 0 else { return 0 }
        return Int((Double(unlockedCount) / Double(totalCount)) * 100)
    }
    
    /// Gets achievement statistics by category
    func statistics(for category: AchievementCategory) -> (unlocked: Int, total: Int) {
        let categoryAchievements = achievements(for: category)
        let unlockedCount = categoryAchievements.filter { $0.unlocked }.count
        return (unlockedCount, categoryAchievements.count)
    }
    
    // MARK: - Notifications
    
    /// Clears the recently unlocked list
    func clearRecentlyUnlocked() {
        recentlyUnlocked.removeAll()
    }
    
    /// Gets the next achievement to unlock (closest to completion)
    func nextAchievementToUnlock() -> Achievement? {
        return achievements
            .filter { !$0.unlocked }
            .sorted { $0.progress > $1.progress }
            .first
    }
}

