import FamilyControls
import ManagedSettings
import Foundation
import UIKit

/// Manages app blocking via Screen Time API
@Observable
final class BlockingManager {
    // MARK: - Properties
    var isBlocking: Bool = false
    var blockedCategories: Set<ActivityCategoryToken> = []
    var isAuthorized: Bool = false
    var authorizationError: String?
    
    private let store = ManagedSettingsStore()
    
    // MARK: - Initialization
    init() {
        checkAuthorizationStatus()
    }
    
    // MARK: - Authorization
    
    /// Requests FamilyControls authorization from the user
    /// - Returns: True if authorized, false otherwise
    func requestAuthorization() async -> Bool {
        do {
            try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
            isAuthorized = true
            authorizationError = nil
            print("✅ FamilyControls authorization granted")
            return true
        } catch {
            isAuthorized = false
            authorizationError = error.localizedDescription
            print("❌ FamilyControls authorization failed: \(error.localizedDescription)")
            return false
        }
    }
    
    /// Checks current authorization status
    private func checkAuthorizationStatus() {
        let status = AuthorizationCenter.shared.authorizationStatus
        isAuthorized = (status == .approved)
        
        switch status {
        case .notDetermined:
            print("⚠️ FamilyControls authorization not determined")
        case .denied:
            print("❌ FamilyControls authorization denied")
            authorizationError = "Authorization denied. Please enable in Settings."
        case .approved:
            print("✅ FamilyControls authorization approved")
        @unknown default:
            print("⚠️ Unknown FamilyControls authorization status")
        }
    }
    
    // MARK: - Blocking Control
    
    /// Starts blocking selected app categories
    /// - Parameter categories: Set of app category tokens to block
    func startBlocking(categories: Set<ActivityCategoryToken>) {
        guard isAuthorized else {
            print("❌ Cannot start blocking: Not authorized")
            authorizationError = "App blocking requires FamilyControls authorization"
            return
        }
        
        guard !categories.isEmpty else {
            print("⚠️ No categories to block")
            return
        }
        
        blockedCategories = categories
        
        // Apply restrictions
        store.shield.applicationCategories = ShieldSettings.ActivityCategoryPolicy.specific(categories)
        isBlocking = true
        
        print("🚫 Started blocking \(categories.count) app categories")
    }
    
    /// Starts blocking with specific application tokens
    /// - Parameter applications: Set of application tokens to block
    func startBlocking(applications: Set<ApplicationToken>) {
        guard isAuthorized else {
            print("❌ Cannot start blocking: Not authorized")
            authorizationError = "App blocking requires FamilyControls authorization"
            return
        }
        
        guard !applications.isEmpty else {
            print("⚠️ No applications to block")
            return
        }
        
        // Apply restrictions to specific apps
        store.shield.applications = applications
        isBlocking = true
        
        print("🚫 Started blocking \(applications.count) specific applications")
    }
    
    /// Stops all app blocking
    func stopBlocking() {
        // Remove all restrictions
        store.shield.applicationCategories = nil
        store.shield.applications = nil
        store.shield.webDomains = nil
        
        isBlocking = false
        blockedCategories.removeAll()
        
        print("✅ Stopped all app blocking")
    }
    
    /// Checks if blocking is currently active
    var isCurrentlyBlocking: Bool {
        return isBlocking && isAuthorized
    }
    
    // MARK: - Session Integration
    
    /// Starts blocking for a focus session
    /// - Parameter categories: Categories to block during session
    func startSessionBlocking(categories: Set<ActivityCategoryToken>) {
        guard isAuthorized else {
            print("⚠️ Skipping blocking: Not authorized")
            return
        }
        
        startBlocking(categories: categories)
        print("🎯 Session blocking activated")
    }
    
    /// Stops blocking after session ends
    func stopSessionBlocking() {
        stopBlocking()
        print("🎯 Session blocking deactivated")
    }
    
    // MARK: - Presets
    
    /// Common blocking presets for different focus levels
    enum BlockingPreset {
        case light      // Social media only
        case medium     // Social media + entertainment
        case heavy      // All distracting apps
        case custom     // User-defined
        
        var description: String {
            switch self {
            case .light: return "Block social media apps"
            case .medium: return "Block social media and entertainment"
            case .heavy: return "Block all distracting apps"
            case .custom: return "Custom selection"
            }
        }
    }
    
    /// Gets suggested categories for a blocking preset
    /// Note: Actual category tokens must be selected by user via FamilyActivityPicker
    /// This provides guidance on what to block for each preset level
    func suggestedCategoriesDescription(for preset: BlockingPreset) -> String {
        switch preset {
        case .light:
            return "Social networking apps (Instagram, Facebook, Twitter, TikTok, etc.)"
        case .medium:
            return "Social networking + Entertainment (YouTube, Netflix, Gaming, etc.)"
        case .heavy:
            return "Social networking + Entertainment + Messaging + Shopping"
        case .custom:
            return "Select your own apps to block"
        }
    }
    
    // MARK: - Error Handling
    
    /// Clears any authorization errors
    func clearError() {
        authorizationError = nil
    }
    
    /// Presents settings to enable FamilyControls
    func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
                print("📱 Opening Settings app")
            }
        }
    }
    
    // MARK: - Helper Methods
    
    /// Provides user-friendly status message
    var statusMessage: String {
        if !isAuthorized {
            return "App blocking requires Screen Time authorization"
        } else if isBlocking {
            return "Apps are currently blocked"
        } else {
            return "Ready to block apps"
        }
    }
    
    /// Returns whether authorization can be requested
    var canRequestAuthorization: Bool {
        return AuthorizationCenter.shared.authorizationStatus == .notDetermined
    }
}

