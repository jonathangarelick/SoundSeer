import AppKit
import OSLog
import ScriptingBridge

enum SpotifyPlaybackState {
    case paused
    case playing
    case stopped

    init(_ descriptor: SpotifyEPlS?) {
        switch descriptor {
        case SpotifyEPlS(rawValue: 0x6b505370): // 'kPSp'
            self = .paused
        case SpotifyEPlS(rawValue: 0x6b505350): // 'kPSP'
            self = .playing
        default:
            self = .stopped
        }
    }
}

class SpotifyModel {
    // https://swiftwithmajid.com/2022/04/06/logging-in-swift/
    private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: SpotifyModel.self)
    )

    @Published var playerState: SpotifyPlaybackState = .stopped

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
        // An event may be fired when Spotify is closed. This prevents it from reopening
        guard Utils.isAppRunning("com.spotify.client") else {
            Logger.playback.debug("Cancelled update. Spotify is not running")
            resetData()
            return
        }

        playerState = SpotifyPlaybackState(spotifyApp.playerState)
        Logger.playback.debug("Player state is now \(String(describing: self.playerState))")

        // Sometimes the AEKeyword will be 0 when the app is killed
        // Something about the Objective-C bridge allows the enum to still be created
        if Utils.playerStateIsStoppedOrUnknown(playerState) {
            Logger.playback.debug("Cancelled update. Player in stopped or unknown state")
            resetData()
            return
        }

        currentSong = spotifyApp.currentTrack?.name ?? ""
        currentSongId = spotifyApp.currentTrack?.id?().components(separatedBy: ":").last ?? ""
        currentArtist = spotifyApp.currentTrack?.artist ?? ""

        // I have no idea why this sometimes happens. It's only for artist
        if currentArtist.isEmpty {
            Self.logger.info("Current artist is empty. Retrying...")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                self?.currentArtist = self?.spotifyApp.currentTrack?.artist ?? ""
            }
        }

        currentAlbum = spotifyApp.currentTrack?.album ?? ""

        Self.logger.info("Retrieved current song: \(self.currentSong, privacy: .public)")
        Self.logger.info("Retrieved current song ID: \(self.currentSongId, privacy: .public)")
        Self.logger.info("Retrieved current artist: \(self.currentArtist, privacy: .public)")
        Self.logger.info("Retrieved current album: \(self.currentAlbum, privacy: .public)")

        Self.logger.info("Update completed successfully")
    }

     
}
