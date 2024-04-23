import AppKit
import OSLog
import ScriptingBridge

class SpotifyModel {
    // https://swiftwithmajid.com/2022/04/06/logging-in-swift/
    private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: SpotifyModel.self)
    )

    @Published var playerState: SpotifyEPlSTyped = .stopped

    @Published var currentSong: String = ""
    @Published var currentSongId: String = ""
    @Published var currentArtist: String = ""
    @Published var currentAlbum: String = ""

    private let spotifyApp: SpotifyApplication = SBApplication(bundleIdentifier: "com.spotify.client")!

    private let notificationCenter = DistributedNotificationCenter.default()
    private let notificationName = Notification.Name("com.spotify.client.PlaybackStateChanged")

    init() {
        // Need to trigger a "fake" event when SoundSeer is first opened
        Self.logger.debug("Performing initial update")
        update()

        Self.logger.debug("Subscribing to Spotify playback change events")
        notificationCenter.addObserver(forName: notificationName, object: nil, queue: nil) { [weak self] _ in
            self?.update()
        }
    }

    deinit {
        Self.logger.debug("Removing subscription to Spotify playback events")
        DistributedNotificationCenter.default().removeObserver(self)
    }

    func nextTrack() {
        Self.logger.debug("Skipping track")
        spotifyApp.nextTrack?()
    }

    private func resetData() {
        Self.logger.debug("Resetting data")
        playerState = .stopped

        currentSong = ""
        currentSongId = ""
        currentArtist = ""
        currentAlbum = ""
    }

    private func update() {
        Self.logger.debug("Beginning update...")

        if !(spotifyApp.isRunning ?? false) {
            Self.logger.debug("SB indicates app is not running. Resetting data and ending update")
            resetData()
            return
        }

        // This will open the app if it is closed, so we need to check isRunning first
        playerState = spotifyApp.playerState ?? .stopped

        // Sometimes the AEKeyword will be 0 when the app is killed
        // Something about the Objective-C bridge allows the enum to still be created
        if playerState != .paused && playerState != .playing {
            Self.logger.debug("Spotify is in an unknown or stopped state. Resetting data and ending update")
            resetData()
            return
        }

        currentSong = spotifyApp.currentTrack?.name ?? ""
        currentSongId = spotifyApp.currentTrack?.id?().components(separatedBy: ":").last ?? ""
        currentArtist = spotifyApp.currentTrack?.artist ?? ""
        currentAlbum = spotifyApp.currentTrack?.album ?? ""

        Self.logger.debug("Retrieved current song: \(self.currentSong)")
        Self.logger.debug("Retrieved current song ID: \(self.currentSongId)")
        Self.logger.debug("Retrieved current artist: \(self.currentArtist)")
        Self.logger.debug("Retrieved current album: \(self.currentAlbum)")

        Self.logger.debug("Update completed successfully")
    }
}
