import AVFoundation

/// Manages all audio playback (engine sounds, ambient, music)
@Observable
final class AudioManager {
    // MARK: - Audio Players
    private var enginePlayer: AVAudioPlayer?
    private var ambientPlayer: AVAudioPlayer?
    private var effectsPlayer: AVAudioPlayer?
    
    // MARK: - State
    var isMuted: Bool = false
    var ambientVolume: Float = AppConstants.ambientVolume
    var effectsVolume: Float = AppConstants.effectsVolume
    
    // MARK: - Initialization
    init() {
        setupAudioSession()
    }
    
    // MARK: - Audio Session Setup
    private func setupAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try audioSession.setActive(true)
            print("🔊 Audio session configured")
        } catch {
            print("❌ Failed to setup audio session: \(error)")
        }
    }
    
    // MARK: - Engine Sounds
    
    /// Plays engine start sound for the given vehicle type
    func playEngineStart(vehicleType: VehicleType) {
        guard !isMuted else { return }
        
        let soundName: String
        switch vehicleType {
        case .sedan: soundName = "sedan_start"
        case .suv: soundName = "suv_start"
        case .truck: soundName = "truck_start"
        case .sportsCar: soundName = "sports_start"
        case .electricCar: soundName = "electric_start"
        case .vintageCar: soundName = "vintage_start"
        }
        
        // For now, use system sound as placeholder
        print("🔊 Playing engine start sound: \(soundName)")
        playSound(soundName, player: &effectsPlayer, loop: false)
    }
    
    /// Starts playing ambient driving sounds
    func startDrivingAmbient() {
        guard !isMuted else { return }
        
        print("🔊 Starting ambient driving sounds")
        playSound("highway_ambient", player: &ambientPlayer, loop: true)
        ambientPlayer?.volume = ambientVolume
    }
    
    /// Pauses ambient sounds
    func pauseAmbient() {
        ambientPlayer?.pause()
        print("⏸️ Ambient audio paused")
    }
    
    /// Resumes ambient sounds
    func resumeAmbient() {
        guard !isMuted else { return }
        ambientPlayer?.play()
        print("▶️ Ambient audio resumed")
    }
    
    /// Plays arrival/completion sound
    func playArrival() {
        guard !isMuted else { return }
        
        print("🔊 Playing arrival chime")
        playSound("arrival_chime", player: &effectsPlayer, loop: false)
    }
    
    /// Stops all audio playback
    func stopAll() {
        enginePlayer?.stop()
        ambientPlayer?.stop()
        effectsPlayer?.stop()
        print("🔇 All audio stopped")
    }
    
    // MARK: - Private Helpers
    
    /// Plays a sound file
    /// - Parameters:
    ///   - name: Name of the sound file (without extension)
    ///   - player: Reference to the audio player to use
    ///   - loop: Whether to loop the sound indefinitely
    private func playSound(_ name: String, player: inout AVAudioPlayer?, loop: Bool) {
        // Check if audio file exists in bundle
        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else {
            // Fallback: Use system sound or skip
            print("⚠️ Audio file not found: \(name).mp3 (using placeholder)")
            return
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.numberOfLoops = loop ? -1 : 0
            player?.volume = loop ? ambientVolume : effectsVolume
            player?.prepareToPlay()
            player?.play()
        } catch {
            print("❌ Error playing sound \(name): \(error)")
        }
    }
    
    // MARK: - Volume Control
    
    /// Updates ambient volume
    func setAmbientVolume(_ volume: Float) {
        ambientVolume = max(0.0, min(1.0, volume))
        ambientPlayer?.volume = ambientVolume
    }
    
    /// Updates effects volume
    func setEffectsVolume(_ volume: Float) {
        effectsVolume = max(0.0, min(1.0, volume))
        effectsPlayer?.volume = effectsVolume
    }
    
    /// Toggles mute state
    func toggleMute() {
        isMuted.toggle()
        if isMuted {
            stopAll()
        }
    }
}

