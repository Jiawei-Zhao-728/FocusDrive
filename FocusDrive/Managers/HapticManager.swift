import CoreHaptics
import UIKit

/// Manages haptic feedback for interactions
final class HapticManager {
    // MARK: - Properties
    private var engine: CHHapticEngine?
    private var isHapticsAvailable: Bool = false
    
    // MARK: - Initialization
    init() {
        setupHaptics()
    }
    
    // MARK: - Setup
    private func setupHaptics() {
        // Check if device supports haptics
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
            print("⚠️ Device does not support haptics")
            return
        }
        
        do {
            engine = try CHHapticEngine()
            try engine?.start()
            isHapticsAvailable = true
            
            // Reset handler when engine stops
            engine?.resetHandler = { [weak self] in
                print("⚠️ Haptic engine reset")
                do {
                    try self?.engine?.start()
                } catch {
                    print("❌ Failed to restart haptic engine: \(error)")
                }
            }
            
            // Handle engine stopping
            engine?.stoppedHandler = { reason in
                print("⚠️ Haptic engine stopped: \(reason)")
            }
            
            print("✅ Haptic engine initialized")
        } catch {
            print("❌ Haptic engine error: \(error)")
            isHapticsAvailable = false
        }
    }
    
    // MARK: - Haptic Patterns
    
    /// Plays engine start haptic - two quick taps
    func playEngineStart() {
        // Simple two-tap feedback
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
        
        // Second tap after a brief delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            generator.impactOccurred()
        }
    }
    
    /// Plays seatbelt click haptic
    func playSeatbeltClick() {
        guard isHapticsAvailable else {
            let generator = UIImpactFeedbackGenerator(style: .rigid)
            generator.impactOccurred()
            return
        }
        
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.8)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1.0)
        
        let event = CHHapticEvent(
            eventType: .hapticTransient,
            parameters: [intensity, sharpness],
            relativeTime: 0
        )
        
        playPattern([event])
    }
    
    /// Plays arrival celebration haptic
    func playArrival() {
        guard isHapticsAvailable else {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            return
        }
        
        // Three quick pulses for arrival celebration
        let events = (0..<3).map { i in
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.9)
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.7)
            
            return CHHapticEvent(
                eventType: .hapticTransient,
                parameters: [intensity, sharpness],
                relativeTime: TimeInterval(i) * 0.2
            )
        }
        
        playPattern(events)
    }
    
    /// Plays low fuel warning haptic
    func playLowFuelWarning() {
        guard isHapticsAvailable else {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.warning)
            return
        }
        
        // Two quick pulses for warning
        let events = (0..<2).map { i in
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.7)
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.8)
            
            return CHHapticEvent(
                eventType: .hapticTransient,
                parameters: [intensity, sharpness],
                relativeTime: TimeInterval(i) * 0.15
            )
        }
        
        playPattern(events)
    }
    
    /// Plays simple tap haptic
    func playTap() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    /// Plays selection haptic
    func playSelection() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
    
    // MARK: - Private Helpers
    
    /// Plays a haptic pattern
    private func playPattern(_ events: [CHHapticEvent]) {
        guard let engine = engine, isHapticsAvailable else { return }
        
        do {
            // Try to start engine if it's stopped (just catches error if already running)
            try? engine.start()
            
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: CHHapticTimeImmediate)
        } catch {
            print("❌ Haptic playback error: \(error)")
            // Disable haptics if they consistently fail (simulator)
            isHapticsAvailable = false
        }
    }
}

